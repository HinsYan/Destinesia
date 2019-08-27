//
//  DTSLocalTripAlbumsCollectionViewCell.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/17.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSLocalTripAlbumsCollectionViewCell.h"
#import "RealmAlbumManager.h"

#import <SDWebImage/SDWebImageManager.h>

@implementation DTSLocalTripAlbumsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setAlbum:(RealmAlbum *)album {
    _album = album;

    _lbUsername.text = [album.author uppercaseString];
    _iconUserGrade.image= [UIImage imageNamed:[NSString stringWithFormat:@"iconStar_%ld.png", (long)album.authorGrade]];    
    _lbCity.text = album.city;
    _lbProvince.text = album.province;
    _lbCountry.text = album.country;
    _imageView.frame = self.bounds;
    _lbDate.text = [[DTSDateFormatter sharedInstance] shortDateStringFromUnixTime:album.createDate];
    
    [DTSPhotoDownloader downloadPhoto:_album.albumCoverPhotoID
                  withCompletionBlock:^(UIImage *image) {
        
                      if (image) {
                          _imageView.image = [image dts_imageFitTargetSize:_imageView.frame.size];
                      }
                  }];
    
    
    // TODO: album.authorGrade
    NSInteger authorGrade = 3;
    _iconUserGrade.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconStar_%ld", (long)authorGrade]];
}

@end
