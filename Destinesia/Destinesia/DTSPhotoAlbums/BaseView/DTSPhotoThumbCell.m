//
//  DTSPhotoThumbCell.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSPhotoThumbCell.h"
#import "ViewNewTripAlbumPhotoEdit.h"
#import "UIApplication+DTSCategory.h"

static const CGFloat kLabelCornerRadius = 5.f;

@implementation DTSPhotoThumbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_lbPhotoIndex.bounds
                                           byRoundingCorners: UIRectCornerBottomLeft
                                                 cornerRadii: (CGSize){kLabelCornerRadius, kLabelCornerRadius}].CGPath;
    _lbPhotoIndex.layer.mask = maskLayer;
    _lbPhotoIndex.hidden = YES;
    
    _btnEdit.hidden = YES;
    _btnEdit.layer.cornerRadius = kLabelCornerRadius;
    [self bringSubviewToFront:_btnEdit];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _lbPhotoIndex.hidden = YES;
    _btnEdit.hidden = YES;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        _lbPhotoIndex.hidden = NO;
        _btnEdit.hidden = NO;
    } else {
        _btnEdit.hidden = YES;
        _lbPhotoIndex.hidden = YES;
    }
}

- (IBAction)actionEdit:(UIButton *)sender {
    UIView *currentView = [[UIApplication sharedApplication] dts_currentViewController].view;
    
    ViewNewTripAlbumPhotoEdit *viewEditPhoto = [[ViewNewTripAlbumPhotoEdit alloc] initWithFrame:currentView.bounds];
//    viewEditPhoto.modelNewTripAlbumPhoto = _modelNewTripAlbumPhoto;
    viewEditPhoto.imageView.image = _thumbImageView.image;
    [currentView addSubview:viewEditPhoto];
}

@end
