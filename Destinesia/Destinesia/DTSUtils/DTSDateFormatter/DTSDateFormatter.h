//
//  DTSDateFormatter.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/24.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSDateFormatter : NSObject

+ (instancetype)sharedInstance;

- (NSString *)stringDateFormatted:(NSDate *)date;

- (NSString *)stringShortDateFormatted:(NSDate *)date;

- (NSString *)stringCompleteDateFormatted:(NSDate *)date;

/**
 *  将毫秒级别的unixTime转换成可读的时间字符串
 */
- (NSString *)dateStringFromUnixTime:(double)unixTime;

- (NSString *)shortDateStringFromUnixTime:(double)unixTime;

@end
