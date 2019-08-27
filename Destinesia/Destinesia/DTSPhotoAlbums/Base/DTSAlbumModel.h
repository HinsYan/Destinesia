//
//  DTSAlbumModel.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DTSAlbumModel : NSObject

@property (nonatomic, strong, nullable) PHAssetCollection *assetCollection;

@property (nonatomic, strong, nullable) PHFetchResult *fetchResult;

/**
 *	@brief  相册名字
 */
@property (nonatomic, strong, readonly, nullable) NSString *albumName;

/**
 *	@brief  图片数量
 */
@property (nonatomic, assign, readonly) NSUInteger assetsCount;

/**
 *	@brief  是否是相机胶卷
 */
@property (nonatomic, assign) BOOL isCameraRoll;

/**
 *	@brief  获取相册封面
 *
 *	@param imageSize			图片尺寸
 *	@param resultHandler	block回调
 *
 *	@return 请求id
 */
- (int32_t)asyncFetchAlbumCoverWithImageSize:(CGSize)imageSize
                               resultHandler:(void (^__nullable)(UIImage *__nullable result))resultHandler;

/**
 *	@brief  取消相册封面请求
 *
 *	@param requestID	请求id
 */
- (void)cancelAlbumCoverRequest:(int32_t)requestID;

@end
