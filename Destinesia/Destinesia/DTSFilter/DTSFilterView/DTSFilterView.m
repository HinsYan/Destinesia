//
//  DTSFilterView.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/19.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSFilterView.h"

@implementation DTSFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DTSFilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDTSFilterCollectionViewCellIdentifier];
    
    DTSFilterViewDataSourceManager *dataSourceManager = [DTSFilterViewDataSourceManager sharedInstance];
    _collectionView.dataSource = dataSourceManager;
    _collectionView.delegate = dataSourceManager;
    
    dataSourceManager.collectionView = _collectionView;
    dataSourceManager.delegate = self;
}

- (void)setTheOriginalImage:(UIImage *)theOriginalImage {
    _theOriginalImage = theOriginalImage;
    
    [DTSFilterViewDataSourceManager sharedInstance].theOriginalImage = _theOriginalImage;
}

- (void)selectFilterItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                  animated:YES
                            scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)prepareFilteredImages {
    [[DTSFilterViewDataSourceManager sharedInstance] prepareFilteredImages];
}

#pragma mark - <DTSFilterViewDataSourceManagerDelegate>

- (void)DTSFilterViewDataSourceManagerDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(DTSFilterViewDidSelectItemAtIndexPath:)]) {
        [_delegate DTSFilterViewDidSelectItemAtIndexPath:indexPath];
    }
}

@end
