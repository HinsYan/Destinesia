//
//  DTSTripAlbumsCollectionViewCell.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsCollectionViewCell.h"

static const CGFloat kLabelCornerRadius = 5.f;

@implementation DTSTripAlbumsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_viewLookCount.bounds
                                           byRoundingCorners: UIRectCornerBottomLeft
                                                 cornerRadii: (CGSize){kLabelCornerRadius, kLabelCornerRadius}].CGPath;
    _viewLookCount.layer.mask = maskLayer;
    
    _viewUploading.alpha = 0.f;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _viewUploading.alpha = 0.f;
    
    _imageView.image = [UIImage imageNamed:@"LaunchScreen.jpg"];
}

- (void)setAlbum:(RealmAlbum *)album {
    _album = album;
    
    _lbUsername.text    = [album.author uppercaseString];
    _iconUserGrade.image= [UIImage imageNamed:[NSString stringWithFormat:@"iconStar_%ld.png", (long)album.authorGrade]];
    _lbCity.text        = album.city;
    _lbProvince.text    = album.province;
    _lbCountry.text     = album.country;
    if (album.createDate > 0) {
        _lbDate.text = [[DTSDateFormatter sharedInstance] shortDateStringFromUnixTime:album.createDate];
    } else {
        _lbDate.text = @"";
    }
    
    _imageView.frame    = self.bounds;
    
    if ([album.albumID containsString:@"Album_"] &&
        album.createDate == 0 &&
        !album.isPublished) {
        
        _viewUploading.alpha = 1.f;
        _lbUploadingProcess.text = @"uploading";
        
        // realm
        [DTSAlbumManager imageOfLocalIdentifier:album.albumCoverPhotoID withCompletionBlock:^(UIImage *imageFetched) {
            _imageView.image = [imageFetched dts_imageFitTargetSize:_imageView.frame.size];
        }];
    } else {
        // server
        [DTSPhotoDownloader downloadThumbnail:album.coverPhotoURL
                          withCompletionBlock:^(UIImage *image) {
                              
                              if (image) {
                                  _imageView.image = [image dts_imageFitTargetSize:_imageView.frame.size];
                              }
                          }];
        
        [DTSPhotoDownloader downloadPhoto:album.coverPhotoURL
                      withCompletionBlock:^(UIImage *image) {
                          
                          if (image) {
                              _imageView.image = [image dts_imageFitTargetSize:_imageView.frame.size];
                          }
                          
                      }];
    }
}

@end
