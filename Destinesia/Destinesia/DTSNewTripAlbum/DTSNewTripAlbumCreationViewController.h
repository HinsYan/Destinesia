//
//  DTSNewTripAlbumCreationViewController.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSAssetsGridViewController.h"
#import "DTSNewTripPhotosSelectionManager.h"

// 区分从camera或是旅行专辑进入, 因为路径不同
typedef NS_ENUM(NSInteger, GoToNewTripAlbumFromSource) {
    kGoToNewTripAlbumFromSource_Camera = 0,
    kGoToNewTripAlbumFromSource_TripAlbums,
};

// 相册来源
typedef NS_ENUM(NSInteger, DTSAlbumSource) {
    kDTSAlbumSource_Destinesia = 0,  // Destinesia胶卷
    kDTSAlbumSource_Album            // 系统相册
};

@interface DTSNewTripAlbumCreationViewController : DTSAssetsGridViewController

@property (nonatomic, assign) GoToNewTripAlbumFromSource goToNewTripAlbumFromSource;

@end
