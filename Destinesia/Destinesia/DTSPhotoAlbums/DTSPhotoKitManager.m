//
//  DTSPhotoKitManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSPhotoKitManager.h"

@interface DTSPhotoKitManager ()

@property (nonatomic, strong, nullable) PHCachingImageManager *imageManager;

@end

@implementation DTSPhotoKitManager

+ (instancetype)sharedInstance;
{
    static DTSPhotoKitManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSPhotoKitManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _imageManager = [[PHCachingImageManager alloc] init];
        _albumArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray<DTSAlbumModel *> *__nullable)syncAlbums
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount>0"];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:options];
    
    PHFetchResult *cameraRollResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    void (^handleAssetCollection)(PHAssetCollection *, BOOL) = ^(PHAssetCollection * assetCollection,BOOL isCameraRoll)
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType=1"];
        PHFetchResult *photos = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        if (photos.count) {
            DTSAlbumModel *albumModel = [[DTSAlbumModel alloc] init];
            albumModel.assetCollection = assetCollection;
            albumModel.fetchResult = photos;
            albumModel.isCameraRoll = isCameraRoll;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.1 &&
                [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
                assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                [_albumArray insertObject:albumModel atIndex:0];
            } else {
                // "相机胶卷"放置到首位
                if (assetCollection.assetCollectionType == PHAssetCollectionTypeSmartAlbum &&
                    assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [_albumArray insertObject:albumModel atIndex:0];
                } else {
                    [_albumArray addObject:albumModel];
                }
            }
        }
    };
    
    [_albumArray removeAllObjects];
    [cameraRollResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
//        NSLog(@"localizedTitle = %@,assetCollectionSubtype = %ld",obj.localizedTitle,obj.assetCollectionSubtype);
        if (obj.assetCollectionSubtype == 101 || obj.assetCollectionSubtype == 1000000201) {
            
        }else {
            handleAssetCollection(obj,YES);
        }
    }];
     [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
//        NSLog(@"localizedTitle = %@,assetCollectionSubtype = %ld",obj.localizedTitle,obj.assetCollectionSubtype);
         if (obj.assetCollectionSubtype == 101 || obj.assetCollectionSubtype == 1000000201) {
             
         }else {
             handleAssetCollection(obj,NO);
         }
    }];
    
    return _albumArray;
}

#pragma mark - PHAsset operation

- (int32_t)requestFullImageForAsset:(PHAsset *__nullable)asset
                      resultHandler:(void (^__nullable)(NSDictionary *__nullable photoInfo))resultHandler
{
    PHImageRequestID requestID = [_imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (resultHandler) {
            
            CIImage* ciImage = [CIImage imageWithData:imageData];
            UIImage *fullImage = [UIImage imageWithData:imageData];
            NSDictionary *photoInfo = @{UIImagePickerControllerOriginalImage:fullImage,@"metadata":ciImage.properties.description};
            resultHandler(photoInfo);
        }
    }];
    
    return requestID;
}

- (int32_t)requestImageForAsset:(PHAsset *__nullable)asset
                     targetSize:(CGSize)targetSize
                    contentMode:(PHImageContentMode)contentMode
                  resultHandler:(void (^__nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    PHImageRequestID requestID = [_imageManager requestImageForAsset:asset
                                                          targetSize:targetSize
                                                         contentMode:contentMode
                                                             options:nil
                                                       resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                if (resultHandler) {
                                                                    resultHandler(result,info);
                                                                }
                                                        }];
    return requestID;
}

- (void)cancelImageRequest:(int32_t)requestID
{
    if (requestID) {
        [_imageManager cancelImageRequest:requestID];
    }
}

- (void)handleDeleteAsset:(PHAsset *__nullable)asset
{
    // Delete asset from library
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[asset]];
    } completionHandler:nil];
}

- (void)startCachingImagesForAssets:(NSArray<PHAsset *> *__nonnull)assets
                         targetSize:(CGSize)targetSize
{
    [_imageManager startCachingImagesForAssets:assets
                                    targetSize:targetSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil];
}

- (void)stopCachingImagesForAssets:(NSArray<PHAsset *> *__nonnull)assets
                        targetSize:(CGSize)targetSize
{
    [_imageManager stopCachingImagesForAssets:assets
                                   targetSize:targetSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:nil];
}

- (void)stopCachingImagesForAllAssets
{
    [_imageManager stopCachingImagesForAllAssets];
}

#pragma mark - PHAsset identifier

- (void)requestImageForAssetLocalIdentifier:(NSString *__nullable)localIdentifier
                                 targetSize:(CGSize)targetSize
                                contentMode:(PHImageContentMode)contentMode
                              resultHandler:(void (^__nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    if (assets.count == 0) {
        return;
    }
    
    [self requestImageForAsset:[assets firstObject]
                    targetSize:targetSize
                   contentMode:contentMode
                 resultHandler:resultHandler];
}

- (void)startCachingImagesForAssetLocalIdentifiers:(NSArray<NSString *> *__nonnull)localIdentifiers
                                        targetSize:(CGSize)targetSize
{
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:localIdentifiers options:nil];
    [self startCachingImagesForAssets:(NSArray *)assets targetSize:PHImageManagerMaximumSize];
}

@end
