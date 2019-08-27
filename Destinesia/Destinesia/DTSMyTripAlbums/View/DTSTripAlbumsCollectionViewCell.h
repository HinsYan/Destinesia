//
//  DTSTripAlbumsCollectionViewCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "CollectionViewCellBaseXXNibBridge.h"
#import "RealmAlbumManager.h"

static NSString *const kDTSTripAlbumsCollectionViewCellIdentifier = @"kDTSTripAlbumsCollectionViewCellIdentifier";

@interface DTSTripAlbumsCollectionViewCell : CollectionViewCellBaseXXNibBridge

@property (weak, nonatomic) IBOutlet UIView *viewUploading;
@property (weak, nonatomic) IBOutlet UILabel *lbUploadingProcess;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *viewLookCount;
@property (weak, nonatomic) IBOutlet UILabel *lbLookCount;

@property (weak, nonatomic) IBOutlet UIView *viewWatermark;

@property (weak, nonatomic) IBOutlet UILabel *lbUsername;
@property (weak, nonatomic) IBOutlet UIImageView *iconUserGrade;
@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbProvince;
@property (weak, nonatomic) IBOutlet UILabel *lbCountry;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (nonatomic, strong) RealmAlbum *album;

@end
