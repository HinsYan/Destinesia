//
//  DTSEncrypt.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSEncrypt : NSObject

// 32位MD5加密
+ (NSString *)encryptViaMD5:(NSString *)stringToEncrypt;

@end
