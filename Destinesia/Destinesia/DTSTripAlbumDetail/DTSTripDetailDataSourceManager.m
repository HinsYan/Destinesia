//
//  DTSTripDetailDataSourceManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripDetailDataSourceManager.h"
#import "RealmAlbumManager.h"

@implementation DTSTripDetailDataSourceManager
{
    RealmAlbum *_realmAlbum;
}

- (void)setAlbumID:(NSString *)albumID
{
    _albumID = albumID;
    
    _realmAlbum = [RealmAlbumManager realmAlbumOfAlbumID:_albumID];
    
    [_collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _realmAlbum.photos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (TripDetailCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TripDetailCollectionViewCell *cell = (TripDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"kTripDetailCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    RealmPhoto *realmPhoto = _realmAlbum.photos[indexPath.section];
    [cell setPhotoID:realmPhoto.photoID ofAlbum:_realmAlbum.albumID];
    
    return cell;
}

- (TripDetailCollectionReusableFooter *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TripDetailCollectionReusableFooter *footer = (TripDetailCollectionReusableFooter *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kTripDetailCollectionReusableFooterIdentifier forIndexPath:indexPath];
    
    RealmPhoto *realmPhoto = _realmAlbum.photos[indexPath.section];
    [footer setPhotoID:realmPhoto.photoID ofAlbum:_realmAlbum.albumID];
    
    return footer;
}

#pragma mark - <UICollectionViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    
    if (offset > 0) {
        
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(DTSTripDetailScrollViewDidScroll:)]) {
            [_delegate DTSTripDetailScrollViewDidScroll:offset];
        }
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kWidthPhotoDetailDesc, CGRectGetHeight(collectionView.frame));
}

@end
