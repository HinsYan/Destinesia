//
//  DTSCameraWatermark.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/14.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSCameraWatermark.h"

@implementation DTSCameraWatermark

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self initLbDate];
    [self initLbLocation];
    [self initTimer];
}

- (void)initLbDate {
    _lbDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.frame), 20)];
    _lbDate.textColor = [UIColor whiteColor];
    _lbDate.font = [UIFont systemFontOfSize:12];
    [self addSubview:_lbDate];
    
    _lbDate.text = [[DTSDateFormatter sharedInstance] stringDateFormatted:[NSDate date]];
}

- (void)initLbLocation {
    _lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.frame), 30)];
    _lbLocation.textColor = [UIColor whiteColor];
    _lbLocation.font = [UIFont systemFontOfSize:12];
    [self addSubview:_lbLocation];
    
    _lbLocation.text = @"";
}

- (void)updateCameraWatermarkCity:(NSString *)city {
    _lbLocation.attributedText = [self attributedStringCity:city];
}

- (NSMutableAttributedString *)attributedStringCity:(NSString *)city {
    NSMutableAttributedString *attributedCity = [[NSMutableAttributedString alloc] initWithString:city];
    NSRange rangeOfFirstComma = [city rangeOfString:@","];
    NSRange cityRange = NSMakeRange(0, rangeOfFirstComma.location);
    [attributedCity addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:cityRange];
    
    return attributedCity;
}

- (void)initTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(actionTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)actionTimer:(NSTimer *)sender {
    _lbDate.text = [[DTSDateFormatter sharedInstance] stringDateFormatted:[NSDate date]];
}

@end
