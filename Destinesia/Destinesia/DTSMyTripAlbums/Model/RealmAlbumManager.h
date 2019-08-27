//
//  RealmAlbumManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/15.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAlbum.h"

@interface RealmAlbumManager : NSObject

+ (BOOL)addRealmAlbum:(RealmAlbum *)realmAlbum;

+ (BOOL)deleteRealmAlbumOfAlbumID:(NSString *)albumID;

#pragma mark - query

+ (NSMutableArray *)queryAllRealmAlbums;
+ (RLMResults *)queryRealmAlbumFilteredBy:(NSPredicate *)filterCondition;
+ (RLMResults *)queryRealmAlbumWhere:(NSString *)whereConfition;

+ (RealmAlbum *)realmAlbumOfAlbumID:(NSString *)albumID;

+ (RealmPhoto *)realmPhotoOfID:(NSString *)photoID ofAlbum:(NSString *)albumID;

#pragma mark - 将json转换成model

+ (RealmPhoto *)realmPhotoFromJSON:(id)photoDict;

+ (RealmAlbum *)realmAlbumFromJSON:(id)albumDict;

+ (NSArray<RealmAlbum *> *)realmAlbumListFromJSON:(id)dict;

@end
