//
//  DTSCameraWatermark.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/14.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSCameraWatermark : UIView

@property (nonatomic, strong) UILabel *lbDate;
@property (nonatomic, strong) UILabel *lbLocation;

@property (nonatomic, strong) NSTimer *timer; // 用于拍照页更新时间

- (void)updateCameraWatermarkCity:(NSString *)city;

@end
