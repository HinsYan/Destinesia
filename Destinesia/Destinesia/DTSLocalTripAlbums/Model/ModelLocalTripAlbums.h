//
//  ModelLocalTripAlbums.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/25.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAlbum.h"

/**
 *  仅用来保存当地专辑页的展示信息
 *  用于当地旅行专辑的概况. 包含albums及每个album的基本信息(albumID, city, 封面等). 
 *  点击album之后, 再根据albumID获取每个album的详细信息.
 */
@interface ModelLocalTripAlbums : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, assign) NSInteger userCount;
@property (nonatomic, assign) NSInteger albumsCount;

// 网络请求获取到的album不包含photos信息, 即该albums中仅包含基本的album信息, 然后再根据albumID分别获取对应的photos等详情.
@property (nonatomic, strong) NSArray<RealmAlbum *> *albums;

@end
