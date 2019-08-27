//
//  DTSFilterCollectionViewCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/6.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSFilterCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (weak, nonatomic) IBOutlet UIImageView *iconFilterSelected;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
