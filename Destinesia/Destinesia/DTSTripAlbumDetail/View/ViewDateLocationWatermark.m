//
//  ViewDateLocationWatermark.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewDateLocationWatermark.h"

@interface ViewDateLocationWatermark ()

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbLocation;

@end


@implementation ViewDateLocationWatermark

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    _lbDate.text = @"";
    _lbLocation.text = @"";
}

- (void)setDateTime:(double)dateTime
{
    _dateTime = dateTime;
    
    _lbDate.text = [[DTSDateFormatter sharedInstance] shortDateStringFromUnixTime:dateTime];
}

- (void)setLocation:(NSString *)location
{
    _location = location;
    
    _lbLocation.attributedText = [self attributedStringCity:location];
}

- (NSMutableAttributedString *)attributedStringCity:(NSString *)city {
    NSMutableAttributedString *attributedCity = [[NSMutableAttributedString alloc] initWithString:city];
    NSRange rangeOfFirstComma = [city rangeOfString:@","];
    if (rangeOfFirstComma.length == 0) {
        return nil;
    }
    
    NSRange cityRange = NSMakeRange(0, rangeOfFirstComma.location);
    [attributedCity addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:cityRange];
    
    return attributedCity;
}

@end
