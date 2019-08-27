//
//  TripDetailCollectionReusableFooter.h
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>


static CGFloat kWidthPhotoDetailDesc = 247;

static NSString * const kTripDetailCollectionReusableFooterIdentifier = @"kTripDetailCollectionReusableFooterIdentifier";


@interface TripDetailCollectionReusableFooter : UICollectionReusableView

@property (nonatomic, assign) BOOL isLiked;

@property (weak, nonatomic) IBOutlet UILabel *lbCountry;

@property (weak, nonatomic) IBOutlet UILabel *lbProvince;

@property (weak, nonatomic) IBOutlet UILabel *lbCity;

@property (weak, nonatomic) IBOutlet UILabel *lbDistrict;

@property (weak, nonatomic) IBOutlet UILabel *lbStreet;


@property (weak, nonatomic) IBOutlet UILabel *lbPhotoIndex;



@property (weak, nonatomic) IBOutlet UILabel *lbPhotoDetail;


@property (weak, nonatomic) IBOutlet UILabel *lbLikeCount;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnVote;


- (void)setPhotoID:(NSString *)photoID ofAlbum:(NSString *)albumID;

@end
