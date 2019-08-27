//
//  DTSFilterCollectionViewCell.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/6.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSFilterCollectionViewCell.h"

@implementation DTSFilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _maskView.hidden = YES;
    _iconFilterSelected.hidden = YES;
    
    _imageView.image = [UIImage imageNamed:@"Model.png"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _maskView.hidden = YES;
    _iconFilterSelected.hidden = YES;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        _maskView.hidden = NO;
        _iconFilterSelected.hidden = NO;
    } else {
        _maskView.hidden = YES;
        _iconFilterSelected.hidden = YES;
    }
}

@end
