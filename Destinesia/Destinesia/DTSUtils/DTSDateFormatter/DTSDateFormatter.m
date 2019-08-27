//
//  DTSDateFormatter.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/24.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSDateFormatter.h"

@interface DTSDateFormatter ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DTSDateFormatter

- (void)dealloc {
    _dateFormatter = nil;
}

+ (instancetype)sharedInstance {
    static DTSDateFormatter *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initDateFormatter];
    });
    return sharedInstance;
}

- (void)initDateFormatter {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
}

- (NSString *)stringDateFormatted:(NSDate *)date {
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)stringShortDateFormatted:(NSDate *)date {
    _dateFormatter.dateFormat = @"MM/dd";
    NSString *ret = [_dateFormatter stringFromDate:date];
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    return ret;
}

- (NSString *)stringCompleteDateFormatted:(NSDate *)date {
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString *ret = [_dateFormatter stringFromDate:date];
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    return ret;
}

- (NSString *)dateStringFromUnixTime:(double)unixTime
{
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss:SSS";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime / 1000];
    NSString *dateString = [_dateFormatter stringFromDate:date];
    
    _dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    return dateString;
}

- (NSString *)shortDateStringFromUnixTime:(double)unixTime
{
    NSString *dateStr = [[DTSDateFormatter sharedInstance] dateStringFromUnixTime:unixTime];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@" "];
    if (dateArr.count != 0) {
        dateStr = [dateArr firstObject];
        dateArr = [dateStr componentsSeparatedByString:@"/"];
        dateStr = [NSString stringWithFormat:@"%@/%@", dateArr[1], dateArr[2]];
    }
    return dateStr;
}
@end
