//
//  DTSLocalTripAlbumsDataSourceManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSLocalTripAlbumsDataSourceManager.h"

#define kLocalTripAlbumsCellCountOfLine      3
#define kLocalTripAlbumsCellOffset           10
// 包含屏幕最左,最右的offset
#define kLocalTripAlbumsCellWidth            (kDTSScreenWidth - kLocalTripAlbumsCellOffset * (kLocalTripAlbumsCellCountOfLine + 1)) / kLocalTripAlbumsCellCountOfLine

@implementation DTSLocalTripAlbumsDataSourceManager

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [DTSLocalTripAlbumsManager sharedInstance].localTripAlbums.count;
}

- (DTSLocalTripAlbumsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DTSLocalTripAlbumsCollectionViewCell *cell = (DTSLocalTripAlbumsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDTSLocalTripAlbumsCollectionViewCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndex:indexPath.item];
    
    return cell;
}

- (void)configureCell:(DTSLocalTripAlbumsCollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index < [DTSLocalTripAlbumsManager sharedInstance].localTripAlbums.count) {
        cell.album = [[DTSLocalTripAlbumsManager sharedInstance].localTripAlbums objectAtIndex:index];
    }
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(DTSLocalTripAlbumsDataSourceManagerDelegateDidSelectAlbum:)]) {
        RealmAlbum *album = [[DTSLocalTripAlbumsManager sharedInstance].localTripAlbums objectAtIndex:indexPath.item];
        [_delegate DTSLocalTripAlbumsDataSourceManagerDelegateDidSelectAlbum:album.albumID];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 包含屏幕最左,最右的offset
    CGFloat width = (kDTSScreenWidth - kLocalTripAlbumsCellOffset * 3) / 2;
    return CGSizeMake(width, width * 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(120.f, kLocalTripAlbumsCellOffset, 0, kLocalTripAlbumsCellOffset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kLocalTripAlbumsCellOffset * 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end

