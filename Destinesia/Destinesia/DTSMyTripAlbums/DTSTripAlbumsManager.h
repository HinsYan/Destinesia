//
//  DTSTripAlbumsManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAlbumManager.h"


@protocol DTSTripAlbumsManagerDelegate <NSObject>

- (void)DTSTripAlbumsManagerReloadData;

@end


@interface DTSTripAlbumsManager : NSObject

@property (nonatomic, weak) id<DTSTripAlbumsManagerDelegate> delegate;

+ (instancetype)sharedInstance;

// 个人专辑列表, 包含realm和服务端请求(请求后也暂存realm中，但不包含RealmPhoto，因此再次发送detail请求)
@property (nonatomic, strong) NSMutableArray<RealmAlbum *> *myTripAlbums;

@property (nonatomic, assign) NSInteger myTripAlbumsTotalMiles;

@property (nonatomic, assign) NSInteger myTripAlbumsTotalLikes;

// 服务端请求的realm，去重后存于本地。
- (void)requestMyTripAlbumsFromServer;
- (void)updateMyTripAlbumsFromRealm;

- (void)reset;

// 进入个人专辑页预先加载封面图片
- (void)startCachingAssetsOfTripAlbumCovers;

- (void)photosOfAlbum:(NSString *)albumID;

- (void)albumsOfUser:(NSString *)user;

- (void)albumsOfCity:(NSString *)city;

- (void)albumsOfLocationLat:(NSString *)lat lon:(NSString *)lon;

@end
