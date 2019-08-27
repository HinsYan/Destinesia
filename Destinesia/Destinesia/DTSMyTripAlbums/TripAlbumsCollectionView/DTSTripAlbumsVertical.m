//
//  DTSTripAlbumsVertical.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsVertical.h"

@interface DTSTripAlbumsVertical () <

    DTSTripAlbumsViewManagerDelegate
>

@end


@implementation DTSTripAlbumsVertical

- (instancetype)initWithFrame:(CGRect)frame withTopEdgeInset:(CGFloat)topEdgeInset
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCollectionViewWithTopEdgeInset:topEdgeInset];
    }
    return self;
}

- (void)initCollectionViewWithTopEdgeInset:(CGFloat)topEdgeInset {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DTSTripAlbumsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDTSTripAlbumsCollectionViewCellIdentifier];
    
    [_collectionView registerClass:[DTSTripAlbumsHorizontal class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TripAlbumsCollectionVerticalReusableViewIdentifier"];
    
    DTSTripAlbumsVerticalCollectionDataSourceManager *dataSourceManager = [DTSTripAlbumsVerticalCollectionDataSourceManager sharedInstance];
    _collectionView.dataSource = dataSourceManager;
    _collectionView.delegate = dataSourceManager;
    
    dataSourceManager.delegate = self;
    dataSourceManager.collectionView = _collectionView;
    dataSourceManager.topEdgeInset = topEdgeInset;
}

#pragma mark - <DTSTripAlbumsViewManagerDelegate>

- (void)DTSTripAlbumsViewManagerDelegateDidSelectAlbum:(NSString *)albumID {
    if (_delegate && [_delegate respondsToSelector:@selector(DTSTripAlbumsVerticalDelegateDidSelectAlbum:)]) {
        [_delegate DTSTripAlbumsVerticalDelegateDidSelectAlbum:albumID];
    }
}

- (void)reloadData {
    [[DTSTripAlbumsVerticalCollectionDataSourceManager sharedInstance].collectionView reloadData];
    [[DTSTripAlbumsHorizontalCollectionDataSourceManager sharedInstance].collectionView reloadData];
}

#pragma mark - publish 进度

- (void)albumPublished:(NSString *)albumID
{
    DTSTripAlbumsCollectionViewCell *horizontalCell = (DTSTripAlbumsCollectionViewCell *)[[DTSTripAlbumsHorizontalCollectionDataSourceManager sharedInstance].collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    DTSLog(@"第一个cell ： %@", horizontalCell.album.albumID);
    if ([albumID isEqualToString:horizontalCell.album.albumID]) {
        horizontalCell.lbUploadingProcess.text = @"专辑上传成功";
        horizontalCell.lbDate.text = [[DTSDateFormatter sharedInstance] shortDateStringFromUnixTime:horizontalCell.album.createDate];
        
        [UIView animateWithDuration:2.0 animations:^{
            horizontalCell.viewUploading.alpha = 0.f;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
