//
//  DTSLocalTripAlbumsManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAlbumManager.h"
#import "ModelLocalTripAlbums.h"
#import <YYKit/YYThreadSafeArray.h>


@protocol DTSLoalTripAlbumsManagerDelegate <NSObject>

- (void)DTSLocalTripAlbumsManagerReloadData;

@end


@interface DTSLocalTripAlbumsManager : NSObject

@property (nonatomic, weak) id<DTSLoalTripAlbumsManagerDelegate> delegate;

/**
 *  用于当地旅行专辑的概况. 包含albums及每个album的基本信息(albumID, city, 封面等).
 *  点击album之后, 再根据albumID获取每个album的详细信息.
 */
@property (nonatomic, strong) ModelLocalTripAlbums *localTripAlbumsInfo;

// 当地专辑列表
@property (nonatomic, strong) YYThreadSafeArray *localTripAlbums;

// 点击封面进入detail页, 则update该专辑
@property (nonatomic, strong) RealmAlbum *selectedLocalTripAlbum;

@property (nonatomic, assign) NSInteger localTotalUserCount;

@property (nonatomic, strong) NSString *localCity;
@property (nonatomic, strong) NSString *localLocation;

+ (instancetype)sharedInstance;

- (void)updateLocalTripAlbums;

@end
