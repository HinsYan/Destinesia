//
//  DTSTripAlbumsViewManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DTSTripAlbumsHorizontal.h"

#import "DTSTripAlbumsCollectionViewCell.h"


@protocol DTSTripAlbumsViewManagerDelegate <NSObject>

- (void)DTSTripAlbumsViewManagerDelegateDidSelectAlbum:(NSString *)albumID;

@end



#pragma mark - DTSTripAlbumsHorizontalCollectionDataSourceManager

@interface DTSTripAlbumsHorizontalCollectionDataSourceManager : NSObject <

    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;

+ (instancetype)sharedInstance;

@end



#pragma mark - DTSTripAlbumsVerticalCollectionDataSourceManager

@interface DTSTripAlbumsVerticalCollectionDataSourceManager : NSObject <

    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, weak) id<DTSTripAlbumsViewManagerDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat topEdgeInset;

+ (instancetype)sharedInstance;

// 统一传入albumID,跳转至tripDetail
- (void)didSelectAlbum:(NSString *)albumID;

@end
