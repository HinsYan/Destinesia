//
//  DTSPhotoDownloader.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/3.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSPhotoDownloader.h"
#import "SDWebImageManager.h"

// http://oe5b5o4wx.bkt.clouddn.com/DA2D5A01-8DBC-4526-8F0D-2C1436943C0C?imageMogr2/thumbnail/320x
// http://oe5b5o4wx.bkt.clouddn.com/ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED?imageView2/2/h/200

static NSString *const kQiniuDownloadFormat         = @"?imageView2/2";

static const NSInteger kHeightOfPhotoDownload       = 1920;

static NSString *const kQiniuDownloadFormat_Thumbnail = @"?imageMogr2/thumbnail";

static const NSInteger kHeightOfThumbnailDownload   = 200;


@implementation DTSPhotoDownloader

+ (void)downloadPhoto:(NSString *)photoURL
  withCompletionBlock:(DTSPhotoDownloaderCompletionBlock)completionBlock
{
    NSString *qiniuDownloadFormat = [NSString stringWithFormat:@"%@/h/%ld", kQiniuDownloadFormat, (long)kHeightOfPhotoDownload];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", photoURL, qiniuDownloadFormat];

    [self didDownloadPhoto:urlString withCompletionBlock:completionBlock];
}

+ (void)downloadThumbnail:(NSString *)photoURL
      withCompletionBlock:(DTSPhotoDownloaderCompletionBlock)completionBlock
{
    NSString *qiniuDownloadFormat = [NSString stringWithFormat:@"%@/%ldx", kQiniuDownloadFormat_Thumbnail, (long)kHeightOfThumbnailDownload];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", photoURL, qiniuDownloadFormat];
    
    [self didDownloadPhoto:urlString withCompletionBlock:completionBlock];
}

+ (void)didDownloadPhoto:(NSString *)urlString
     withCompletionBlock:(DTSPhotoDownloaderCompletionBlock)completionBlock
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString]
                                                    options:SDWebImageDelayPlaceholder
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      
                                                      if (completionBlock) {
                                                          completionBlock(image);
                                                      }
                                                      
                                                  }];
}


@end
