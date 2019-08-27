//
//  ViewTripDetailCover.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewTripDetailCover.h"
#import "RealmAlbumManager.h"
#import "RealmAccountManager.h"
#import "DTSPhotoKitManager.h"

@implementation ViewTripDetailCover
{
    RealmAlbum *currentRealmAlbum;
    
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _imageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"LaunchScreen.jpg"];
}

- (void)setAlbumID:(NSString *)albumID
{
    _albumID = albumID;
    
    currentRealmAlbum = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    
    // 对于自己发布的专辑，从相册中取高清图
    if ([currentRealmAlbum.albumID hasPrefix:@"RealmAlbum_"] &&
        [currentRealmAlbum.author isEqualToString:[RealmAccountManager currentLoginAccount].username]) {
        
        [self getPhotoViaLocalIdentifier:currentRealmAlbum.albumCoverPhotoID];
    } else {
        [self getPhotoViaURL:currentRealmAlbum.coverPhotoURL];
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
                                                                   [DTSToastUtil toastWithText:@"操作成功" withShowTime:1.0];
                                                               }];
}

- (void)getPhotoViaURL:(NSString *)urlString
{
    [DTSPhotoDownloader downloadPhoto:urlString
                  withCompletionBlock:^(UIImage *image) {
                      
                      if (image) {
                          _imageView.image = image;
                      }
                      [DTSToastUtil toastWithText:@"操作成功" withShowTime:1.0];
                  }];
}

@end
