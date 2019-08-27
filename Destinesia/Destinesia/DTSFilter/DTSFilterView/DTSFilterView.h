//
//  DTSFilterView.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/19.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSFilterViewDataSourceManager.h"

@protocol DTSFilterViewDelegate <NSObject>

- (void)DTSFilterViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface DTSFilterView : UIView <

    DTSFilterViewDataSourceManagerDelegate
>

@property (nonatomic, weak) id<DTSFilterViewDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImage *theOriginalImage;

- (void)selectFilterItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)prepareFilteredImages;

@end
