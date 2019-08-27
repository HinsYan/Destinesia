//
//  DTSTripDetailDataSourceManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripDetailCollectionViewCell.h"
#import "TripDetailCollectionReusableFooter.h"

@protocol DTSTripDetailDataSourceManagerDelegate <NSObject>

- (void)DTSTripDetailScrollViewDidScroll:(CGFloat)offset;

@end


@interface DTSTripDetailDataSourceManager : NSObject
<
    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, strong) NSString *albumID;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<DTSTripDetailDataSourceManagerDelegate> delegate;

@end
