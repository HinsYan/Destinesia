//
//  NSFileManager+DTSCategory.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/6.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (DTSCategory)

- (NSString *)dts_homeDirectory;

- (NSString *)dts_tempDirectory;

- (NSString *)dts_documentDirectory;

- (NSString *)dts_libraryDirectory;

- (NSString *)dts_cacheDirectory;

@end