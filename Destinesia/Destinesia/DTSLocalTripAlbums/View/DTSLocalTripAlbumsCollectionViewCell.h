//
//  DTSLocalTripAlbumsCollectionViewCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/17.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "CollectionViewCellBaseXXNibBridge.h"
#import "RealmAlbumManager.h"

static NSString *const kDTSLocalTripAlbumsCollectionViewCellIdentifier = @"kDTSLocalTripAlbumsCollectionViewCellIdentifier";


@interface DTSLocalTripAlbumsCollectionViewCell : CollectionViewCellBaseXXNibBridge

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *viewWatermark;

@property (weak, nonatomic) IBOutlet UILabel *lbUsername;
@property (weak, nonatomic) IBOutlet UIImageView *iconUserGrade;
@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbProvince;
@property (weak, nonatomic) IBOutlet UILabel *lbCountry;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (nonatomic, strong) RealmAlbum *album; // 用于存储album的基本信息

@end
