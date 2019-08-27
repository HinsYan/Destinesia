//
//  DTSTripAlbumsViewManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsViewManager.h"
#import "DTSTripAlbumsManager.h"

#define kTripAlbumsVerticalCellCountOfLine      3
#define kTripAlbumsVerticalCellOffset           10
// 包含屏幕最左,最右的offset
#define kTripAlbumsVerticalCellWidth            (kDTSScreenWidth - kTripAlbumsVerticalCellOffset * (kTripAlbumsVerticalCellCountOfLine + 1)) / kTripAlbumsVerticalCellCountOfLine


#pragma mark - DTSTripAlbumsHorizontalCollectionDataSourceManager

@implementation DTSTripAlbumsHorizontalCollectionDataSourceManager

+ (instancetype)sharedInstance {
    static DTSTripAlbumsHorizontalCollectionDataSourceManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([DTSTripAlbumsManager sharedInstance].myTripAlbums.count > 5) {
        return 5;
    } else {
        return [DTSTripAlbumsManager sharedInstance].myTripAlbums.count;
    }
}

- (__kindof DTSTripAlbumsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DTSTripAlbumsCollectionViewCell *cell = (DTSTripAlbumsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TripAlbumsCollectionHorizontalCellReuseIdentifier" forIndexPath:indexPath];
    
    [self configureCell:cell atIndex:indexPath.item];
    
    return cell;
}

- (void)configureCell:(DTSTripAlbumsCollectionViewCell *)cell atIndex:(NSInteger)index {
    cell.album = [DTSTripAlbumsManager sharedInstance].myTripAlbums[index];
    cell.lbLookCount.text = [NSString stringWithFormat:@"%ld", (long)index];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RealmAlbum *album = [DTSTripAlbumsManager sharedInstance].myTripAlbums[indexPath.item];
    [[DTSTripAlbumsVerticalCollectionDataSourceManager sharedInstance] didSelectAlbum:album.albumID];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = kTripAlbumsVerticalCellWidth * 2 + kTripAlbumsVerticalCellOffset;
    return CGSizeMake(width, CGRectGetHeight(collectionView.frame));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kTripAlbumsVerticalCellOffset, 0, kTripAlbumsVerticalCellOffset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kTripAlbumsVerticalCellOffset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end



#pragma mark - DTSTripAlbumsVerticalCollectionDataSourceManager

@implementation DTSTripAlbumsVerticalCollectionDataSourceManager

+ (instancetype)sharedInstance {
    static DTSTripAlbumsVerticalCollectionDataSourceManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)didSelectAlbum:(NSString *)albumID {
    if (_delegate && [_delegate respondsToSelector:@selector(DTSTripAlbumsViewManagerDelegateDidSelectAlbum:)]) {
        [_delegate DTSTripAlbumsViewManagerDelegateDidSelectAlbum:albumID];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([DTSTripAlbumsManager sharedInstance].myTripAlbums.count > 5) {
        return [DTSTripAlbumsManager sharedInstance].myTripAlbums.count - 5;
    } else {
        return 0;
    }
}

- (__kindof DTSTripAlbumsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DTSTripAlbumsCollectionViewCell *cell = (DTSTripAlbumsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDTSTripAlbumsCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if ([DTSTripAlbumsManager sharedInstance].myTripAlbums.count > 5) {
        [self configureCell:cell atIndex:(indexPath.item + 5)];
    }
    
    return cell;
}

- (void)configureCell:(DTSTripAlbumsCollectionViewCell *)cell atIndex:(NSInteger)index {
    cell.album = [DTSTripAlbumsManager sharedInstance].myTripAlbums[index];
}

- (DTSTripAlbumsHorizontal *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DTSTripAlbumsHorizontal *reusableView = (DTSTripAlbumsHorizontal *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TripAlbumsCollectionVerticalReusableViewIdentifier" forIndexPath:indexPath];
    
    return reusableView;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([DTSTripAlbumsManager sharedInstance].myTripAlbums.count > 5) {
        RealmAlbum *album = [DTSTripAlbumsManager sharedInstance].myTripAlbums[(indexPath.item + 5)];
        [self didSelectAlbum:album.albumID];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kTripAlbumsVerticalCellWidth, 165);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kTripAlbumsVerticalCellOffset * 2,
                            kTripAlbumsVerticalCellOffset,
                            kTripAlbumsVerticalCellOffset * 2,
                            kTripAlbumsVerticalCellOffset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kTripAlbumsVerticalCellOffset * 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    // TODO: 大图的高为340? 暂取400
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 400 + 120);
}

@end
