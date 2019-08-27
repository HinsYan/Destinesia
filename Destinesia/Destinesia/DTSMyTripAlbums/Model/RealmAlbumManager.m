//
//  RealmAlbumManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/15.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "RealmAlbumManager.h"

@implementation RealmAlbumManager

+ (BOOL)addRealmAlbum:(RealmAlbum *)realmAlbum {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:realmAlbum];
    }];
    
    return YES;
}

+ (BOOL)deleteRealmAlbumOfAlbumID:(NSString *)albumID
{
    RealmAlbum *albumToDelete = [self realmAlbumOfAlbumID:albumID];
    if (!albumToDelete) {
        return YES;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        for (RealmPhoto *photo in albumToDelete.photos) {
            [realm deleteObject:photo];
        }
        
        [realm deleteObject:albumToDelete];
    }];
    
    if ([self realmAlbumOfAlbumID:albumID]) {
        return NO;
    }
    
    DTSLog(@"delete realm album ok : %@", albumID);
    
    return YES;
}

#pragma mark - query

+ (NSMutableArray *)queryAllRealmAlbums {
    NSArray *albumsPublished = (NSArray *)[[RealmAlbum objectsWhere:@"createDate > 0"] sortedResultsUsingProperty:@"createDate" ascending:NO];
    
    NSArray *albumsUnPublished = (NSArray *)[RealmAlbum objectsWhere:@"createDate = 0"];
    
    NSMutableArray *albums = [NSMutableArray array];
    // 将未发布的album排在前边
    [albums addObjectsFromArray:albumsUnPublished];
    [albums addObjectsFromArray:albumsPublished];
    
    DTSLog(@"realm中一共存储 %lu 个album.", (unsigned long)albums.count);
    
    return albums;
}

+ (RLMResults *)queryRealmAlbumFilteredBy:(NSPredicate *)filterCondition {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];    
    RLMResults *albums = [RealmAlbum objectsWithPredicate:filterCondition];
    
    return albums;
}

+ (RLMResults *)queryRealmAlbumWhere:(NSString *)whereConfition {
    // objectsWhere:@"age == 2"
    RLMResults *albums = [RealmAlbum objectsWhere:whereConfition];
    
    return albums;
}

+ (RealmAlbum *)realmAlbumOfAlbumID:(NSString *)albumID
{
    NSPredicate *predicateAlbumID = [NSPredicate predicateWithFormat:@"albumID == %@", albumID];
    RLMResults *albums = [RealmAlbum objectsWithPredicate:predicateAlbumID];
    if (albums.count > 0) {
        return [albums firstObject];
    }
    
    return nil;
}

+ (RealmPhoto *)realmPhotoOfID:(NSString *)photoID ofAlbum:(NSString *)albumID
{
    RealmPhoto *retPhoto = nil;
    
    RealmAlbum *album = [self realmAlbumOfAlbumID:albumID];
    for (RealmPhoto *tmpPhoto in album.photos) {
        if ([tmpPhoto.photoID isEqualToString:photoID]) {
            retPhoto = tmpPhoto;
            break;
        }
    }
    
    return retPhoto;
}

#pragma mark - 将json转换成model

+ (RealmPhoto *)realmPhotoFromJSON:(id)photoDict
{
    RealmPhoto *realmPhoto      = [[RealmPhoto alloc] init];
    realmPhoto.albumID          = [photoDict objectForKey:@"albumId"];
    realmPhoto.photoID          = [photoDict objectForKey:@"id"];
    realmPhoto.photoName        = [photoDict objectForKey:@"name"];
    realmPhoto.photoType        = [[photoDict objectForKey:@"type"] integerValue];
    realmPhoto.photoDesc        = [photoDict objectForKey:@"description"];
    
    realmPhoto.photoURL         = [photoDict objectForKey:@"path"];
    realmPhoto.createDate       = [[photoDict objectForKey:@"createDate"] doubleValue];
    
    realmPhoto.longitude        = [[photoDict objectForKey:@"longitude"] doubleValue];
    realmPhoto.latitude         = [[photoDict objectForKey:@"latitude"] doubleValue];
    realmPhoto.altitude         = [[photoDict objectForKey:@"altitude"] doubleValue];
    
    
    NSDictionary *region        = [photoDict objectForKey:@"regionDTO"];
    realmPhoto.country          = [region objectForKey:@"country"];
    realmPhoto.province         = [region objectForKey:@"province"];
    realmPhoto.city             = [region objectForKey:@"city"];
    realmPhoto.district         = [region objectForKey:@"district"];
    
    return realmPhoto;
}

+ (RealmAlbum *)realmAlbumFromJSON:(id)albumDict
{
    RealmAlbum *realmAlbum          = [[RealmAlbum alloc] init];
    realmAlbum.albumID              = [albumDict objectForKey:@"id"];
    realmAlbum.albumName            = [albumDict objectForKey:@"name"];
    realmAlbum.coverPhotoURL        = [albumDict objectForKey:@"cover"];
    if ([realmAlbum.coverPhotoURL hasPrefix:@"http"]) {
        NSArray *arr = [realmAlbum.coverPhotoURL componentsSeparatedByString:@"com/"];
        if (arr.count > 0) {
            realmAlbum.albumCoverPhotoID = [arr lastObject];
        }
    }
    realmAlbum.author               = [albumDict objectForKey:@"userNickName"];
    realmAlbum.authorGrade          = [[albumDict objectForKey:@"userGrade"] integerValue];
    realmAlbum.photoCount           = [[albumDict objectForKey:@"picCount"] integerValue];
    realmAlbum.createDate           = [[albumDict objectForKey:@"createDate"] doubleValue];
    realmAlbum.albumDesc            = [albumDict objectForKey:@"description"];
    realmAlbum.reviewCount          = [[albumDict objectForKey:@"viewed"] integerValue];
    realmAlbum.likeCount            = [[albumDict objectForKey:@"votes"] integerValue];
    
    NSDictionary *region            = [albumDict objectForKey:@"region"];
    realmAlbum.country              = [region objectForKey:@"country"];
    realmAlbum.province             = [region objectForKey:@"province"];
    realmAlbum.city                 = [region objectForKey:@"city"];
    realmAlbum.district             = [region objectForKey:@"district"];
    
    NSArray *photos                 = [albumDict objectForKey:@"picList"];
    if (photos != [NSNull null]) {
        for (NSDictionary *photoDict in photos) {
            [realmAlbum.photos addObject:[self realmPhotoFromJSON:photoDict]];
        }
    }
    
    return realmAlbum;
}

+ (NSArray<RealmAlbum *> *)realmAlbumListFromJSON:(id)dict
{
    NSMutableArray *albums = [NSMutableArray array];
    for (NSDictionary *albumDict in dict) {
        RealmAlbum *album = [self realmAlbumFromJSON:albumDict];
        [albums addObject:album];
    }

    return albums;
}

@end
