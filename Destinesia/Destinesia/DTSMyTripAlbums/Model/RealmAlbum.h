//
//  RealmAlbum.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/14.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Realm/Realm.h>
#import "RealmPhoto.h"

@interface RealmAlbum : RLMObject

/**
 *  是否已发布. 
 *  新建 - 已发布.
 *  预览 - 未发布.
 *  发布之后立即upload, 完成之后删除本地存储. 若出现网络故障导致upload失败, 则下次会提示.
 *  TODO:
 */
@property BOOL      isPublished;

@property NSString  *albumID;   // 网络请求的albumID设置为空, 本地的albumID设置为非空.
@property NSString  *albumName; // 专辑名称
@property NSString  *albumDesc; // album的描述

@property NSString  *URL;
@property NSString  *author;
@property NSInteger authorGrade; // 用户等级1~3

@property NSString  *country;
@property NSString  *province;
@property NSString  *city;
@property NSString  *district;

@property double    createDate;

@property NSInteger photoCount;
@property NSInteger milesCount;
@property NSInteger reviewCount;
@property NSInteger likeCount;

@property double    longitude;
@property double    latitude;
@property double    altitude;

@property NSString  *albumCoverPhotoID; // 根据ID从 Documents/Photos 目录中取出photo
@property BOOL      isAlbumCoverPhotoUploaded; // 是否已经upload至七牛的标记
@property NSString  *coverPhotoURL;

@property RLMArray<RealmPhoto *><RealmPhoto> *photos;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmAlbum>
RLM_ARRAY_TYPE(RealmAlbum)
