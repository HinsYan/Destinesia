//
//  RealmAccount.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/8.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmAccount : RLMObject

@property NSString      *username;
@property NSString      *email;
@property NSString      *passwd;

@property NSInteger     authorGrade;      // 星级

@property NSString      *lastCity;  // 上次定位城市

@property NSString      *token;

@property BOOL          isCurrentLogin;

@property NSInteger     albumCount; // 已发布专辑个数
@property NSInteger     fansCount;  // 所有fans个数
@property NSInteger     likeCount;  // 收获的所有的点赞数

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmAccount>
RLM_ARRAY_TYPE(RealmAccount)
