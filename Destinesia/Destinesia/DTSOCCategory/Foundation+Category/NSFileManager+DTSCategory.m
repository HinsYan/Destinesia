//
//  NSFileManager+DTSCategory.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/6.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "NSFileManager+DTSCategory.h"

@implementation NSFileManager (DTSCategory)

- (NSString *)dts_homeDirectory {
    return NSHomeDirectory();
}

- (NSString *)dts_tempDirectory {
    return NSTemporaryDirectory();
}

- (NSString *)dts_documentDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)dts_libraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)dts_cacheDirectory {
return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

@end