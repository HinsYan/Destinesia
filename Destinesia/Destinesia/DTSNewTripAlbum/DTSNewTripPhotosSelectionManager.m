//
//  DTSNewTripPhotosSelectionManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/17.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSNewTripPhotosSelectionManager.h"
#import "RealmAlbumManager.h"
#import "RealmAccountManager.h"

@interface DTSNewTripPhotosSelectionManager ()

@end


@implementation DTSNewTripPhotosSelectionManager {
    
    PHAsset *selectedCoverAsset;
    PHFetchResult<PHAsset *> *selectedPhotosAssets;
}

+ (instancetype)sharedInstance {
    static DTSNewTripPhotosSelectionManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSNewTripPhotosSelectionManager alloc] init];
        
        sharedInstance.selectedPhotoModels = [NSMutableArray array];
    });
    return sharedInstance;
}

- (void)addNewTripPhoto:(ModelNewTripAlbumPhoto *)photo {
    [_selectedPhotoModels addObject:photo];
    
    for (ModelNewTripAlbumPhoto *tmpPhoto in _selectedPhotoModels) {
        NSLog(@"\n\nphoto : %ld - %ld", (long)tmpPhoto.indexOfSelectedCell, (long)tmpPhoto.indexOfAlbumDataSource);
    }
}

- (NSInteger)removeNewTripPhotoAtIndexPath:(NSIndexPath *)indexPathToRemove {
    NSInteger indexOfSelectedCell = 0;
    for (ModelNewTripAlbumPhoto *photo in _selectedPhotoModels) {
        if (photo.indexOfAlbumDataSource == indexPathToRemove.item) {
            NSLog(@"\n\nphoto to remove : %ld , indexPath : %ld", (long)photo.indexOfSelectedCell, (long)photo.indexOfAlbumDataSource);
            indexOfSelectedCell = photo.indexOfSelectedCell;
            [_selectedPhotoModels removeObject:photo];
            break;
        }
    }
    
    for (ModelNewTripAlbumPhoto *tmpPhoto in _selectedPhotoModels) {
        NSLog(@"\n\nphoto : %ld - %ld", (long)tmpPhoto.indexOfSelectedCell, (long)tmpPhoto.indexOfAlbumDataSource);
    }
    
    return indexOfSelectedCell;
}

- (void)resetSelectedPhotos {
    _selectedCoverPhotoModel = nil;
    
    [_selectedPhotoModels removeAllObjects];
}

- (BOOL)createPreviewNewTripAlbum
{
    return [self didCreateNewTripAlbum:0];
}

- (BOOL)createNewTripAlbum
{
    _isNewTripAlbumCreated = YES;
    
    return [self didCreateNewTripAlbum:1];
}

/**
 *  0为preview,临时的. 1为create,实际的.
 */
- (BOOL)didCreateNewTripAlbum:(NSInteger)type
{
    RealmAlbum *realmAlbum = [[RealmAlbum alloc] init];
    realmAlbum.isPublished = NO;
    
    // TODO: 暂时使用NSDate来作为albumID, 格式: RealmAlbum_2016/09/28 15:20
    NSDate *nowDate = [NSDate date];
    NSString *realmPrefix = type ? @"RealmAlbum" : @"PreviewAlbum";
    realmAlbum.albumID = [NSString stringWithFormat:@"%@_%@", realmPrefix, [[DTSDateFormatter sharedInstance] stringCompleteDateFormatted:nowDate]];
    _currentAlbumID = realmAlbum.albumID;
    
    // TODO: 暂时为0, 新建上传到服务器之后从服务端返回
    realmAlbum.createDate = 0;
    
    realmAlbum.author = [RealmAccountManager currentLoginAccount].username;
    realmAlbum.authorGrade = [RealmAccountManager currentLoginAccount].authorGrade;
    
    realmAlbum.albumCoverPhotoID = _selectedCoverPhotoModel.localIdentifier;
                       
    // TODO: city确认
    NSArray<NSString *> *cityStringArr = [[DTSLocation sharedInstance].currentCity componentsSeparatedByString:@", "];
    if (cityStringArr.count > 2) {
        realmAlbum.city = [cityStringArr objectAtIndex:0];
        realmAlbum.province = [cityStringArr objectAtIndex:1];
        realmAlbum.country = [cityStringArr objectAtIndex:2];
    }
    
    // TODO: Location
    CLLocation *currentLocation = [DTSLocation sharedInstance].currentLocation;
    realmAlbum.longitude        = currentLocation.coordinate.longitude;
    realmAlbum.latitude         = currentLocation.coordinate.latitude;
    realmAlbum.altitude         = 0;
    
    realmAlbum.photoCount = _selectedPhotoModels.count;
    
    for (ModelNewTripAlbumPhoto *modelPhoto in _selectedPhotoModels) {
        RealmPhoto *realmPhoto = [[RealmPhoto alloc] init];
        realmPhoto.photoID = modelPhoto.localIdentifier;
        realmPhoto.photoDesc = modelPhoto.photoPesc ? modelPhoto.photoPesc : @"";
        
        // TODO: 照片的city等信息暂时与album一样. 是否需要区分? 是否需要精简RealmPhoto的结构
        realmPhoto.albumID = realmAlbum.albumID;
        realmPhoto.author = realmAlbum.author;
        realmPhoto.city = realmAlbum.city;
        realmPhoto.province = realmAlbum.province;
        realmPhoto.country = realmAlbum.country;
        
        [realmAlbum.photos addObject:realmPhoto];
    }
    
    DTSLog(@"didCreateNewTripAlbum : %@ : %@", realmPrefix, realmAlbum);
    
    // preview的也全部存于realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:realmAlbum];
        DTSLog(@"realm create ok : %@", realmAlbum.albumID);
    }];
    
    if (type == 1) {
        [[DTSNewTripAlbumUploader sharedInstance] uploadAlbum:realmAlbum.albumID withCompletionBlock:nil];
    }
    return YES;
}

// 设置预览的cover图片
- (void)updateSelectedCoverForSize:(CGSize)size WithCompletionBlock:(DTSAlbumManagerFetchImageCompletionBlock)completionBlock {
    NSString *localIdentifierOfCover = [DTSNewTripPhotosSelectionManager sharedInstance].selectedCoverPhotoModel.localIdentifier;
    [DTSAlbumManager imageOfLocalIdentifier:localIdentifierOfCover
                             withTargetSize:size
                        withCompletionBlock:^(UIImage *imageFetched) {
                            
                            if (completionBlock) {
                                completionBlock(imageFetched);
                            }
                            
    }];
}

@end
