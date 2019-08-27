//
//  RealmPhoto.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/14.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmPhoto : RLMObject

@property NSString      *albumID;    // 所属的专辑ID
@property NSString      *photoID;    // 根据photoID从 Documents/Photos 目录中取出photo
@property NSString      *photoName;  // photo的名称
@property NSString      *photoDesc;  // photo的描述
@property NSInteger     photoType;

@property NSString      *photoURL;
@property NSString      *author;

@property NSString      *country;
@property NSString      *province;
@property NSString      *city;
@property NSString      *district;

@property double        createDate;

@property double        longitude;
@property double        latitude;
@property double        altitude;

@property NSInteger     reviewCount;
@property NSInteger     likeCount;

@property BOOL          isLiked;

@property BOOL          isPhotoUploaded; // 是否已经upload至七牛的标记

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmPhoto>
RLM_ARRAY_TYPE(RealmPhoto)
