//
//  DTSSlider.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/8.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSSliderDelegate;

typedef NS_ENUM(NSInteger, DTSSliderDirection) {
    kDTSSliderDirection_Horizontal = 0,
    kDTSSliderDirection_Vertical,
};

typedef NS_ENUM(NSInteger, DTSSliderTrackTintType) {
    kDTSSliderTrackTintType_Linear = 0,
    kDTSSliderTrackTintType_Divide,
};

@interface DTSSlider : UISlider

@property (nonatomic, weak) id<DTSSliderDelegate> delegate;

@property (nonatomic, assign) float middleVaule;

@property (nonatomic, assign) DTSSliderDirection sliderDirection;

// Please use DTSSliderTrackTintType in viewDidAppear method.
// Please use DTSSliderTrackTintType after csMinimumTrackTintColor and csMaximumTrackTintColor set already if you do not want to use the default color.
// Please do not set minimumValueImage and maximumValueImage before fully test.
@property (nonatomic, assign) DTSSliderTrackTintType trackTintType;

@property (nonatomic, strong) UIImage *csThumbImage;
@property (nonatomic, strong) UIColor *csMinimumTrackTintColor;
@property (nonatomic, strong) UIColor *csMaximumTrackTintColor;

- (void)increasePercentRate:(NSInteger)percent;
- (void)decreasePercentRate:(NSInteger)percent;

@end


@protocol DTSSliderDelegate <NSObject>

- (void)DTSSliderValueChanged:(DTSSlider *)sender;

@optional
- (void)DTSSliderTouchDown:(DTSSlider *)sender;
- (void)DTSSliderTouchUp:(DTSSlider *)sender;
- (void)DTSSliderTouchCancel:(DTSSlider *)sender;

@end
