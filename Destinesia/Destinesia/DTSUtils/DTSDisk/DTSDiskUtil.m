//
//  DTSDiskUtil.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSDiskUtil.h"
#import "NSFileManager+DTSCategory.h"

@implementation DTSDiskUtil

+ (UIImage *)imageOfPhotosDir:(NSString *)photoID
{
    NSString *docDir = [[NSFileManager defaultManager] dts_documentDirectory];
    NSString *photosDir = [NSString stringWithFormat:@"%@/Photos", docDir];
    NSString *path = [NSString stringWithFormat:@"%@/%@.png", photosDir, photoID];
    return [UIImage imageWithContentsOfFile:path];
}

+ (BOOL)saveImageToPhotosDir:(UIImage *)image withPhotoID:(NSString *)photoID
{
    NSString *docDir = [[NSFileManager defaultManager] dts_documentDirectory];
    NSString *photosDir = [NSString stringWithFormat:@"%@/Photos", docDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photosDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:photosDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.png", photosDir, photoID];
    return [image dts_saveImageToFile:path compressionFactor:1.0f];
}

@end
