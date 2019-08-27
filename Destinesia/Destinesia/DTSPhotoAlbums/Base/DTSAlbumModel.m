//
//  DTSAlbumModel.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSAlbumModel.h"
#import "DTSPhotoKitManager.h"

@interface DTSAlbumModel ()

@end

@implementation DTSAlbumModel

- (NSString *)albumName
{
    return _assetCollection.localizedTitle;
}

- (NSUInteger)assetsCount
{
    return _fetchResult.count;
}

- (int32_t)asyncFetchAlbumCoverWithImageSize:(CGSize)imageSize
                               resultHandler:(void (^__nullable)(UIImage *__nullable result))resultHandler
{
    PHAsset *asset = _fetchResult[0];
    if (self.isCameraRoll) {
        asset = [_fetchResult lastObject];
    }
    PHImageRequestID requestID = [[DTSPhotoKitManager sharedInstance] requestImageForAsset:asset
                                                                              targetSize:imageSize
                                                                             contentMode:PHImageContentModeAspectFill 
                                                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                               if (resultHandler) {
                                                                                   resultHandler(result);
                                                                               }
                                                                           }];
    return requestID;

}

- (void)cancelAlbumCoverRequest:(int32_t)requestID
{
    [[DTSPhotoKitManager sharedInstance] cancelImageRequest:requestID];
}

@end
