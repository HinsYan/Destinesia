//
//  DTSPhotoAssetCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSPhotoAssetCell : UICollectionViewCell

@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, strong) UIImage *assetImage;

@end
