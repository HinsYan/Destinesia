//
//  DTSAlbumManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/20.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


typedef void(^DTSAlbumManagerFetchImageCompletionBlock)(UIImage *imageFetched);


@interface DTSAlbumManager : NSObject

+ (BOOL)isAlbumExisting:(NSString *)albumName;

+ (BOOL)createAlbum:(NSString *)albumName;

+ (BOOL)saveImage:(UIImage *)imageToSave toAlbum:(NSString *)albumName;

+ (PHFetchResult<PHAsset *> *)allAssetsOfAlbum:(NSString *)albumName;

// 同步获取相册中的image
+ (UIImage *)imageOfLocalIdentifier:(NSString *)localIdentifier;

+ (UIImage *)imageOfLocalIdentifier:(NSString *)localIdentifier withTargetSize:(CGSize)targetSize;

// 异步获取相册中的image
+ (void)imageOfLocalIdentifier:(NSString *)localIdentifier
           withCompletionBlock:(DTSAlbumManagerFetchImageCompletionBlock)fetchImageCompletionBlock;

+ (void)imageOfLocalIdentifier:(NSString *)localIdentifier
                withTargetSize:(CGSize)targetSize
           withCompletionBlock:(DTSAlbumManagerFetchImageCompletionBlock)fetchImageCompletionBlock;

@end
