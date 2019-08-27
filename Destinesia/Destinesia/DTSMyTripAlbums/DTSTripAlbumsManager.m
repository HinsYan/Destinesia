//
//  DTSTripAlbumsManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsManager.h"
#import "DTSUserInfoManager.h"
#import "DTSPhotoKitManager.h"

@implementation DTSTripAlbumsManager

+ (instancetype)sharedInstance {
    static DTSTripAlbumsManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSTripAlbumsManager alloc] init];
    });
    return sharedInstance;
}

- (void)reset
{
    [_myTripAlbums removeAllObjects];
    _myTripAlbums = nil;
    
    _myTripAlbumsTotalMiles = 0;
    _myTripAlbumsTotalLikes = 0;
}

- (void)requestMyTripAlbumsFromServer
{
    RealmAccount *currentLoginAccount = [[DTSAccountManager sharedInstance] currentLoginAccount];
    if (currentLoginAccount != nil) {
        // 服务端请求
        NSDictionary *pamermeters = @{
                                      @"token": [DTSUserDefaults userToken],
                                      @"type": @1,
                                      };
        [DTSHTTPRequest album_list:pamermeters withCompletionBlock:^(id responseObject) {
            
            NSArray *albums = [RealmAlbumManager realmAlbumListFromJSON:responseObject];
            DTSLog(@"服务端请求 %lu 个album.", (unsigned long)albums.count);
            
            // realm和server获取的album去重
            NSMutableArray *albumsUniqued = [NSMutableArray array];
            
            NSMutableArray *tmpAlbumsFromRealm = [RealmAlbumManager queryAllRealmAlbums];
            if (tmpAlbumsFromRealm.count > 0) {
                for (RealmAlbum *realmAlbumServer in albums) {
                    BOOL isAlreadyHave = NO;
                    for (RealmAlbum *realmAlbum in tmpAlbumsFromRealm) {
                        if ([realmAlbumServer.albumID isEqualToString:realmAlbum.albumID]) {
                            isAlreadyHave = YES;
                            break;
                        }
                    }
                    
                    if (!isAlreadyHave) {
                        [albumsUniqued addObject:realmAlbumServer];
                    }
                }
            } else {
                [albumsUniqued addObjectsFromArray:albums];
            }
            
            RLMResults *albumsPublished = [RealmAlbumManager queryRealmAlbumWhere:@"isPublished == YES"];
            RLMResults *albumsPreview   = [RealmAlbumManager queryRealmAlbumWhere:@"albumID BEGINSWITH 'PreviewAlbum_'"];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                // 删除已经published的
                [realm deleteObjects:albumsPublished];
                [realm deleteObjects:albumsPreview];
                
                [realm addObjects:albumsUniqued];
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(DTSTripAlbumsManagerReloadData)]) {
                [_delegate DTSTripAlbumsManagerReloadData];
            }
            
        } withErrorBlock:^(id responseObject) {
            if (![responseObject isKindOfClass:[NSError class]]) {
                DTSLog(@"%@", [responseObject objectForKey:@"code"]);
                [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
            } else {
                
            }
        }];
    }
}

- (void)updateMyTripAlbumsFromRealm {
    RealmAccount *currentLoginAccount = [[DTSAccountManager sharedInstance] currentLoginAccount];
    if (currentLoginAccount != nil) {
        _myTripAlbums = [NSMutableArray array];
        
        // Realm存储
        NSArray *albumsFromRealm = (NSArray *)[RealmAlbumManager queryAllRealmAlbums];
        if (albumsFromRealm.count > 0) {
            // 个人专辑页过滤掉当地专辑
            for (RealmAlbum *album in albumsFromRealm) {
                if ([album.author isEqualToString:currentLoginAccount.username]) {
                    [_myTripAlbums addObject:album];
                }
            }
        }
        DTSLog(@"realm中一共存储 %lu 个我的个人album.", (unsigned long)_myTripAlbums.count);
    } else {
        _myTripAlbums = nil;
        _myTripAlbumsTotalMiles = 0;
        _myTripAlbumsTotalLikes = 0;
    }
}

- (void)startCachingAssetsOfTripAlbumCovers
{
    NSMutableArray *localIdentifiers = [NSMutableArray array];
    
    for (RealmAlbum *realmAlbum in _myTripAlbums) {
        [localIdentifiers addObject:realmAlbum.albumCoverPhotoID];
    }
    
    [[DTSPhotoKitManager sharedInstance] startCachingImagesForAssetLocalIdentifiers:localIdentifiers targetSize:kDTSScreenSize];
}

- (void)photosOfAlbum:(NSString *)albumID {
    NSDictionary *parameters = @{
                                 @"albumId":@"4b8d5e5ec1da0fad27b786387030ecd4",
                                 };
    [DTSHTTPRequest album_photo:parameters withCompletionBlock:^(id responseObject) {
        
    } withErrorBlock:^(id responseObject) {
        
    }];
}

- (void)albumsOfUser:(NSString *)user {

}

- (void)albumsOfCity:(NSString *)city {

}

- (void)albumsOfLocationLat:(NSString *)lat lon:(NSString *)lon {

}

@end
