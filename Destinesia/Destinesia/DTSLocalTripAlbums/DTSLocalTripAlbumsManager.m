//
//  DTSLocalTripAlbumsManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSLocalTripAlbumsManager.h"
#import "RealmAlbumManager.h"

@interface DTSLocalTripAlbumsManager ()

@end

@implementation DTSLocalTripAlbumsManager

+ (instancetype)sharedInstance {
    static DTSLocalTripAlbumsManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSLocalTripAlbumsManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)localLocation {
    return [DTSLocation sharedInstance].currentCity;
}

- (RLMResults<RealmAlbum *> *)localTripAlbumsOfCity:(NSString *)currentCity {
    NSPredicate *predicateCity = [NSPredicate predicateWithFormat:@"city == %@", currentCity];
    RLMResults *results = [RealmAlbumManager queryRealmAlbumFilteredBy:predicateCity];
    return results;
}

- (void)updateLocalTripAlbums
{
    if (![DTSUserDefaults userToken]) {
        return;
    }
    
    CLLocation *currentLocation = [DTSLocation sharedInstance].currentLocation;
    NSDictionary *pamermeters = @{
                                  @"lat": @(currentLocation.coordinate.latitude),
                                  @"lon": @(currentLocation.coordinate.longitude),
                                  };
    
    [DTSHTTPRequest album_listbyloc:pamermeters withCompletionBlock:^(id responseObject) {
        if ([NSJSONSerialization isValidJSONObject:responseObject]) {
            // TODO:
            _localTripAlbums = (YYThreadSafeArray *)[RealmAlbumManager realmAlbumListFromJSON:responseObject];
            
            DTSLog(@"当地一共有 %lu 个album, %f - %f", (unsigned long)_localTripAlbums.count,
                   currentLocation.coordinate.latitude,
                   currentLocation.coordinate.longitude);
            
            if (_delegate && [_delegate respondsToSelector:@selector(DTSLocalTripAlbumsManagerReloadData)]) {
                [_delegate DTSLocalTripAlbumsManagerReloadData];
            }
            
        }
    } withErrorBlock:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSError class]]) {
            DTSLog(@"%@", [responseObject objectForKey:@"code"]);
            [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
        } else {
            
        }
    }];
}

- (ModelLocalTripAlbums *)localTripAlbumsInfo {
    // TODO:
    ModelLocalTripAlbums *tmpModel = [[ModelLocalTripAlbums alloc] init];
    tmpModel.city = [[DTSLocation sharedInstance] currentCity];
    tmpModel.location = [[DTSLocation sharedInstance] currentLocation];
    tmpModel.albums = _localTripAlbums; // TODO: 从JSON解析得来
    tmpModel.albumsCount = tmpModel.albums.count;
    tmpModel.userCount = 100;    
    return tmpModel;
}

@end
