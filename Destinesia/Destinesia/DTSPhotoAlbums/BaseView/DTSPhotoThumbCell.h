//
//  DTSPhotoThumbCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDTSPhotoThumbCell @"kDTSPhotoThumbCell"

@interface DTSPhotoThumbCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

@property (weak, nonatomic) IBOutlet UILabel *lbPhotoIndex;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;


// Uniquely identify a cancellable async request
@property (nonatomic, assign) int32_t imageRequestID;

@end
