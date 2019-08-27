//
//  DTSMyAlbumCollectionViewHeader.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSMyAlbumCollectionViewHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *lbCity;

@property (weak, nonatomic) IBOutlet UILabel *lbCountry;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbPhotoCount;

@property (weak, nonatomic) IBOutlet UILabel *lbVideoCount;

@property (weak, nonatomic) IBOutlet UILabel *lbDiscoverCount;

@end
