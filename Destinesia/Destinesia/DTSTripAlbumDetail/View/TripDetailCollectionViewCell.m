//
//  TripDetailCollectionViewCell.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "TripDetailCollectionViewCell.h"
#import "ViewDateLocationWatermark.h"
#import "RealmAlbumManager.h"
#import "RealmAccountManager.h"
#import "DTSPhotoKitManager.h"

@interface TripDetailCollectionViewCell ()

@property (weak, nonatomic) IBOutlet ViewDateLocationWatermark *viewDateLocationWatermark;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation TripDetailCollectionViewCell
{
    RealmPhoto *currentRealmPhoto;
}

- (void)setPhotoID:(NSString *)photoID ofAlbum:(NSString *)albumID
{
    currentRealmPhoto = [RealmAlbumManager realmPhotoOfID:photoID ofAlbum:albumID];
    
    [self updateWatermark];
    
    // 对于自己发布的专辑，从相册中取高清图
    if ([currentRealmPhoto.albumID hasPrefix:@"RealmAlbum_"] &&
        [currentRealmPhoto.author isEqualToString:[RealmAccountManager currentLoginAccount].username]) {
        [self getPhotoViaLocalIdentifier:currentRealmPhoto.photoID];
    } else {
        [self getPhotoViaURL:currentRealmPhoto.photoURL];
    }
}

- (void)updateWatermark
{
    if (currentRealmPhoto.createDate > 0) {
        _viewDateLocationWatermark.dateTime = currentRealmPhoto.createDate;
    }
    
    if (currentRealmPhoto.city && ![currentRealmPhoto.city isEqualToString:@""]) {
        _viewDateLocationWatermark.location = currentRealmPhoto.city;
    }
}

- (void)getPhotoViaLocalIdentifier:(NSString *)localIdentifier
{
    [[DTSPhotoKitManager sharedInstance] requestImageForAssetLocalIdentifier:localIdentifier
                                                                  targetSize:PHImageManagerMaximumSize
                                                                 contentMode:PHImageContentModeAspectFit
                                                               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                   
                                                                   if (result) {
                                                                       _imageView.image = result;
                                                                   }
                                                                   
                                                               }];
}

- (void)getPhotoViaURL:(NSString *)urlString
{
    [DTSPhotoDownloader downloadPhoto:urlString
                  withCompletionBlock:^(UIImage *image) {
                      
                      if (image) {
                          _imageView.image = image;
                      }
                      
                  }];
}

@end
