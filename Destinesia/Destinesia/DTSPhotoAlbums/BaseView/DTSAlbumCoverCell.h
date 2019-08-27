//
//  DTSAlbumCoverCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDTSAlbumCoverCell @"kDTSAlbumCoverCell"

@interface DTSAlbumCoverCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *albumAssetsCount;


// Uniquely identify a cancellable async request
@property (nonatomic, assign) int32_t imageRequestID;

@end
