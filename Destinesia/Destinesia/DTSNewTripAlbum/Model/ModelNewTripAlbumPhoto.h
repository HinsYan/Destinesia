//
//  ModelNewTripAlbumPhoto.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  新建旅行专辑中使用
 */
@interface ModelNewTripAlbumPhoto : NSObject

@property (nonatomic, assign) BOOL isAlbumCover;

@property (nonatomic, assign) NSInteger indexOfSelectedCell;    // 当前photo在已选photo中的index, 从1开始.

@property (nonatomic, assign) NSInteger indexOfAlbumDataSource; // 当前photo对应的cell在album中的index, 用于new trip照片选择的逻辑. 从0开始.

@property (nonatomic, strong) NSString *localIdentifier;        // 存于photos中的命名, 与photokit一致.


@property (nonatomic, strong) NSString *photoPesc;              // photo的描述信息

@property (nonatomic, assign) double        createDate;

@property (nonatomic, strong) NSString      *country;
@property (nonatomic, strong) NSString      *province;
@property (nonatomic, strong) NSString      *city;
@property (nonatomic, strong) NSString      *district;

@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) double        latitude;
@property (nonatomic, assign) double        altitude;

@end
