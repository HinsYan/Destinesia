//
//  DTSPhotoDownloader.h
//  Destinesia
//
//  Created by Chris Hu on 16/10/3.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^DTSPhotoDownloaderCompletionBlock)(UIImage *image);


@interface DTSPhotoDownloader : NSObject

+ (void)downloadPhoto:(NSString *)photoURL
  withCompletionBlock:(DTSPhotoDownloaderCompletionBlock)completionBlock;

+ (void)downloadThumbnail:(NSString *)photoURL
      withCompletionBlock:(DTSPhotoDownloaderCompletionBlock)completionBlock;

@end
