//
//  DTSAlbumManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/20.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSAlbumManager.h"

@implementation DTSAlbumManager

+ (BOOL)isAlbumExisting:(NSString *)albumName {
    __block BOOL isAlbumExisting = NO;
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 遍历并获取指定相册
    [topLevelUserCollections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
        
        if ([assetCollection.localizedTitle isEqualToString:APP_NAME]) {
            *stop = NO;
            isAlbumExisting = YES;
        }
    }];
    
    return isAlbumExisting;
}

+ (BOOL)createAlbum:(NSString *)albumName {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        // 创建相册
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
    
    return YES;
}

+ (BOOL)saveImage:(UIImage *)imageToSave toAlbum:(NSString *)albumName {
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 遍历并获取指定相册
    [topLevelUserCollections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
        
        if ([assetCollection.localizedTitle isEqualToString:APP_NAME]) {
            *stop = NO;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                // 请求改变相册
                PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                
                // 请求创建一个asset
                PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:imageToSave];
                
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset;
                
                // 相册中添加照片
                [assetCollectionChangeRequest addAssets:@[assetPlaceholder]];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                NSLog(@"save ok");
                
            }];
        }
    }];
    
    return NO;
}

+ (PHFetchResult<PHAsset *> *)allAssetsOfAlbum:(NSString *)albumName {
    __block PHFetchResult<PHAsset *> *assets;
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//        options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary; // iOS 9 才有
    
    if (albumName) {
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        // 遍历并获取指定相册
        [topLevelUserCollections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
            
            if ([assetCollection.localizedTitle isEqualToString:APP_NAME]) {
                *stop = NO;
                
                // fetch所有的asset
                assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            }
        }];
    } else {
        // 获取所有资源，包括图片和视频
        assets = [PHAsset fetchAssetsWithOptions:options];
    }
    
    return assets;
}

// 同步获取相册中的image
+ (UIImage *)imageOfLocalIdentifier:(NSString *)localIdentifier
{
    return [self imageOfLocalIdentifier:localIdentifier
                         withTargetSize:PHImageManagerMaximumSize];
}

+ (UIImage *)imageOfLocalIdentifier:(NSString *)localIdentifier withTargetSize:(CGSize)targetSize
{
    __block UIImage *image = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    if (assets.count > 0) {
        PHAsset *asset = [assets firstObject];
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    if (result) {
                                                        image = result;
                                                    }
                                                    dispatch_semaphore_signal(semaphore);
                                                    
                                                }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return image;
}

// 异步获取相册中的image
+ (void)imageOfLocalIdentifier:(NSString *)localIdentifier
           withCompletionBlock:(DTSAlbumManagerFetchImageCompletionBlock)fetchImageCompletionBlock
{
    [self imageOfLocalIdentifier:localIdentifier
                  withTargetSize:PHImageManagerMaximumSize
             withCompletionBlock:fetchImageCompletionBlock];
}

+ (void)imageOfLocalIdentifier:(NSString *)localIdentifier
                withTargetSize:(CGSize)targetSize
           withCompletionBlock:(DTSAlbumManagerFetchImageCompletionBlock)fetchImageCompletionBlock
{
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    if (assets.count > 0) {
        PHAsset *asset = [assets firstObject];
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    if (result && fetchImageCompletionBlock) {
                                                        fetchImageCompletionBlock(result);
                                                    }
                                                    
                                                }];
    }
}

@end
