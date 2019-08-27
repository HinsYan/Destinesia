//
//  DTSTripAlbumsHorizontal.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsHorizontal.h"
#import "DTSTripAlbumsViewManager.h"

@implementation DTSTripAlbumsHorizontal

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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 120) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DTSTripAlbumsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TripAlbumsCollectionHorizontalCellReuseIdentifier"];
    
    DTSTripAlbumsHorizontalCollectionDataSourceManager *dataSourceManager = [DTSTripAlbumsHorizontalCollectionDataSourceManager sharedInstance];
    _collectionView.dataSource = dataSourceManager;
    _collectionView.delegate = dataSourceManager;
    
    dataSourceManager.collectionView = _collectionView;
}

@end
