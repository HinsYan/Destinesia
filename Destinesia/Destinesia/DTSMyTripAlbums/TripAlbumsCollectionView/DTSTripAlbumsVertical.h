//
//  DTSTripAlbumsVertical.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTripAlbumsViewManager.h"


@protocol DTSTripAlbumsVerticalDelegate <NSObject>

- (void)DTSTripAlbumsVerticalDelegateDidSelectAlbum:(NSString *)albumID;

@end


@interface DTSTripAlbumsVertical : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<DTSTripAlbumsVerticalDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withTopEdgeInset:(CGFloat)topEdgeInset;

- (void)reloadData;

#pragma mark - publish 进度

- (void)albumPublished:(NSString *)albumID;

@end
