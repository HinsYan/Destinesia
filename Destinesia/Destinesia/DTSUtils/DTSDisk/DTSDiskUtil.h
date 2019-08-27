//
//  DTSDiskUtil.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSDiskUtil : NSObject

+ (UIImage *)imageOfPhotosDir:(NSString *)photoID;

+ (BOOL)saveImageToPhotosDir:(UIImage *)image withPhotoID:(NSString *)photoID;

@end
