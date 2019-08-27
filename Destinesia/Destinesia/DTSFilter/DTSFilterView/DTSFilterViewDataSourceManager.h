//
//  DTSFilterViewDataSourceManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/19.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSGPUImageFilterManager.h"
#import "DTSFilterCollectionViewCell.h"


#define kDTSFilterCollectionViewCellIdentifier  @"kDTSFilterCollectionViewCellIdentifier"


@protocol DTSFilterViewDataSourceManagerDelegate <NSObject>

- (void)DTSFilterViewDataSourceManagerDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface DTSFilterViewDataSourceManager : NSObject <

    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, weak) id<DTSFilterViewDataSourceManagerDelegate> delegate;

@property (nonatomic, strong) UIImage *theOriginalImage;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dtsFilters;

+ (instancetype)sharedInstance;

- (void)prepareFilteredImages;

@end
