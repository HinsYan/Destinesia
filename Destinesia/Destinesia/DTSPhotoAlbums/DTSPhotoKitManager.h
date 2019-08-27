//
//  DTSPhotoKitManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "DTSAlbumModel.h"

@interface DTSPhotoKitManager : NSObject

@property (nonatomic, strong, readonly, nullable) NSMutableArray *albumArray;


+ (_Nullable instancetype)sharedInstance;

/**
 *	@brief  同步系统相册
 */
- (NSArray<DTSAlbumModel *> *__nullable)syncAlbums;

#pragma mark - PHAsset operation

- (int32_t)requestFullImageForAsset:(PHAsset *__nullable)asset
                      resultHandler:(void (^__nullable)(NSDictionary *__nullable photoInfo))resultHandler;

- (int32_t)requestImageForAsset:(PHAsset *__nullable)asset
                     targetSize:(CGSize)targetSize
                    contentMode:(PHImageContentMode)contentMode
                  resultHandler:(void (^__nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

- (void)cancelImageRequest:(int32_t)requestID;

- (void)handleDeleteAsset:(PHAsset *__nullable)asset;

- (void)startCachingImagesForAssets:(NSArray<PHAsset *> *__nonnull)assets
                         targetSize:(CGSize)targetSize;
- (void)stopCachingImagesForAssets:(NSArray<PHAsset *> *__nonnull)assets
                        targetSize:(CGSize)targetSize;
- (void)stopCachingImagesForAllAssets;

#pragma mark - PHAsset identifier

- (void)requestImageForAssetLocalIdentifier:(NSString *__nullable)localIdentifier
                                 targetSize:(CGSize)targetSize
                                contentMode:(PHImageContentMode)contentMode
                              resultHandler:(void (^__nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

- (void)startCachingImagesForAssetLocalIdentifiers:(NSArray<NSString *> *__nonnull)localIdentifiers
                                        targetSize:(CGSize)targetSize;

@end
