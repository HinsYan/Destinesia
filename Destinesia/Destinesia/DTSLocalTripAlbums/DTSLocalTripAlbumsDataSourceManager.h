//
//  DTSLocalTripAlbumsDataSourceManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSLocalTripAlbumsManager.h"
#import "DTSLocalTripAlbumsCollectionViewCell.h"

@protocol DTSLocalTripAlbumsDataSourceManagerDelegate <NSObject>

- (void)DTSLocalTripAlbumsDataSourceManagerDelegateDidSelectAlbum:(NSString *)albumID;

@end


@interface DTSLocalTripAlbumsDataSourceManager : NSObject <

    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, weak) id<DTSLocalTripAlbumsDataSourceManagerDelegate> delegate;


@end
