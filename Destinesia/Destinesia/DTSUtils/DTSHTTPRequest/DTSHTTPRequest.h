//
//  DTSHTTPRequest.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/21.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSHTTPRequestManager.h"

@interface DTSHTTPRequest : NSObject


#pragma mark -  Album

/**
 *  album_delete: /album/delete
 *  POST
 *  @param parameters:
 *      albumId     : String    专辑ID
 {
 "albumId":"4b8d5e5ec1da0fad27b786387030ecd4",
 }
 *  @return
 200:
 {
 
 }
 
 400:
 {
 "code": 1,
 "msg": "相册不存在"
 }
 */
+ (void)album_delete:(NSDictionary *)parameters
 withCompletionBlock:(CompletionBlock)completionBlock
      withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  album_view: /album/view
 *  POST
 *  @param parameters:
 *      albumId     : String    专辑ID
 *      deviceNO    : String    设备识别码
        {
            "albumId":"4b8d5e5ec1da0fad27b786387030ecd4",
            "deviceNO": "dxedwewew"
        }
 *  @return
        200:
        {

        }

        400:
        {
            "code": 1,
            "msg": "相册不存在"
        }
 */
+ (void)album_view:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  album_save: /album/save
 *  PUT
 *  权限:none
 *
 *  @param parameters:
 *      id          : String    专辑ID为空则为新建; 非空则为更新
 *      name        : String    专辑名称
 *      desc        : String    专辑描述
 *      cover       : String    专辑封面
 *      lat         : String    纬度
 *      lon         : String    经度
**      country     : String    国家
**      city        : String    城市
**      district    : String    地区
 *      pics        : Array     图片列表
 *          path        : String    图片地址
 *          type        : int       类型, 1图片, 2视频, 3AR
 *          name        : String    片名称
 *          desc        : String    图片描述
 *          lat         : String    图片拍摄点的纬度
 *          lon         : String    图片拍摄点的经度
        {
            "token": "4b8d5e5ec1da0fad27b786387030ecd4",
            "name": "Great Day",
            "desc": "Great Day",
            "nickName": "LOVE DESTINESIA",
            "country": "CHINA",
            "city": "上海",
            "district": "黄浦区",
            "pics": [
                {
                    "path": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
                    "type": 1,
                    "desc": "这是一个测试图片上传",
                    "lat": "23.8403430000",
                    "lon": "121.1997770000"
                },
                {
                    "path": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
                    "type": 1,
                    "desc": "这是一个测试图片上传",
                    "lat": "23.8403430000",
                    "lon": "121.1997770000"
                }
            ]
        }
 *  @return
        200:
        {
        }

        400:
        {
            "code": 1,
            "msg": "名称不能为空"
        }
 */
+ (void)album_save:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;

/**
 *  album_listbyloc: /album/listbyloc
 *  根据距离获取专辑列表, 按照时间排序
 *
 *  @param parameters      lat, long
 *  @param completionBlock 同 /album/list
 */
+ (void)album_listbyloc:(NSDictionary *)parameters
    withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  album_list: /album/list
 *  权限:none
 *
 *  @param parameters:
 *      type        : int    获取专辑类型, 1个人专辑, 2根据距离获取专辑
        {
            "type": 1
        }
 *  @return
id	String  专辑id
name	String  专辑名称
cover	String  专辑封面
nickName	String  用户昵称
country	String  国家
city	String  城市
district	String  地区
createDate	Double  专辑创建日期
votes	int 专辑点赞数量
viewed	int 专辑浏览数量
        200:
        [
        {
        "id": "4b8d5e5ec1da0fad27b786387030ecd4",
        "name": "Great Day",
        "cover": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
        "nickName": "LOVE DESTINESIA",
        "country": "CHINA",
        "city": "上海",
        "district": "黄浦区",
        "createDate": 1474325515000,
        "viewed": 3409,
        "votes": 66
        },
        {
        "id": "4b8d5e5ec1da0fad27b786387030ecd4",
        "name": "Great Day 2",
        "cover": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
        "nickName": "LOVE DESTINESIA",
        "country": "AMERICA",
        "city": "HOUSTON",
        "district": "TEXAS",
        "createDate": 1474325515000,
        "viewed": 3409,
        "votes": 88
        }
        ]
 
        500:
        {

        }
 */
+ (void)album_list:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  album_detail: /album/detail
 *  根据专辑ID获取专辑详情
 *
 *  @param parameters      id 专辑ID
 *  @param completionBlock
 *  @return
 {
 "name": "Great Day",
 "id": "4b8d5e5ec1da0fad27b786387030ecd4",
 "region": {
 "id": "50f391e56c20444db18958a91f05b8e5",
 "country": "中国",
 "province": "山东",
 "city": "济南",
 "district": "历城区"
 },
 "votes": 33,
 "createDate": 1474325515000,
 "viewed": 333,
 "promotion": false,
 "cover": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
 "picList": [
 {
 "name": "Great Day pic",
 "id": "78ea74ef02cf4ab8aba131f1367c0d08",
 "type": 1,
 "path": "http://7xlovk.com2.z0.glb.qiniucdn.com/exchange/upload/roomPhoto/20160816/147133686654354.jpeg",
 "region": {
 "id": "50f391e56c20444db18958a91f05b8e5",
 "country": "中国",
 "province": "山东",
 "city": "济南",
 "district": "历城区"
 },
 "createDate": 1474334158000,
 "albumId": "4b8d5e5ec1da0fad27b786387030ecd4",
 "longitude": 121.47617,
 "latitude": 41.672394,
 "description": "Great Day pic desc"
 },
 {
 "name": "Great Day2 pic",
 "id": "0a8fea07ef0c498fa1c1ed1defe37d24",
 "type": 1,
 "path": "http://7xlovk.com2.z0.glb.qiniucdn.com/exchange/upload/roomPhoto/20160816/147133686654480.jpeg",
 "region": {
 "id": "e7c272421fe6407195473a7abb11c4ab",
 "country": "AMERICA",
 "province": "",
 "city": "HOUSTON",
 "district": "TEXAS"
 },
 "createDate": 1474334307000,
 "albumId": "4b8d5e5ec1da0fad27b786387030ecd4",
 "longitude": 114.19084,
 "latitude": 39.37021,
 "description": "Great Day2 pic desc"
 }
 ],
 "description": "Great Day"
 }
 */
+ (void)album_detail:(NSDictionary *)parameters
 withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;



/**
 *  album_photo: /album/piclist
 *
 *  @param parameters:
 *      albumId     : String    专辑ID
        {
            "albumId":"4b8d5e5ec1da0fad27b786387030ecd4",
        }
 *  @return
 *      id          : String    图片ID
 *      path        : String    图片地址
 *      desc        : String    图片描述
 *      isVoted     : int       是否点赞
        200:
        [
            {
                "id": "4b8d5e5ec1da0fad27b786387030ecd4",
                "path": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
                "desc": "好喜欢这里",
                "isVoted": true
            },
            {
                "id": "4b8d5e5ec1da0fad27b786387030ecd4",
                "path": "http://img.hb.aicdn.com/d304dd628fcd9380da97f38ccabc1c7e68661f893e0d4-RsmISE_fw658",
                "desc": "在这里吃饭",
                "isVoted": false
            }
        ]

        500:
        {
            "code": "1",
            "msg": "相册不存在"
        }
 */
+ (void)album_photo:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
     withErrorBlock:(ErrorBlock)errorBlock;


#pragma mark - Picture


/**
 *  photo_vote: /picture/vote
 *
 *  @param parameters:
 *      albumId     : String    专辑ID
 *      pictureId   : String    图片ID
        {
            "albumId":"4b8d5e5ec1da0fad27b786387030ecd4",
            "pictureId":"51cd003dd9605f4a6756ff537b3d96a4",
        }
 
 *  @return
 
        200:
        {

        }

        400:
        {
            "code": 1,
            "msg": "相册不存在"
        }
 */
+ (void)photo_vote:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  photo_unvote: /picture/unvote
 *
 *  @param parameters:
 *      albumId     : String    专辑ID
 *      pictureId   : String    图片ID
        {
            "albumId":"4b8d5e5ec1da0fad27b786387030ecd4",
            "pictureId":"51cd003dd9605f4a6756ff537b3d96a4",
        }
 
 *  @return
 
        200:
        {

        }
 
        400:
        {
        "code": 1,
        "msg": "相册不存在"
        }
 */
+ (void)photo_unvote:(NSDictionary *)parameters
 withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;


#pragma mark -  User

/**
 *  user_register: /user/register
 *  POST
 *  @param parameters:
 *      nickName    : String    昵称
 *      name        : String    账号
 *      password    : String    MD5加密
 *      mail        : String    邮箱
 *      deviceId    : String    硬件设备号
 *      platform    : int       平台 0-iOS, 1-Android, 默认0
        {
            "nickName": "love destinesia",
            "name": "love_desti",
            "password": "e10adc3949ba59abbe56e057f20f883e",
            "mail": "traval@destinesia.cn",
            "deviceId": "1FD69B7C03308FAF",
            "plantform": 0
        }
 *  @return
 *      nickName    : String    昵称
 *      grade       : int       用户等级
 *      token       : String    TOKEN
 
        200:
        {
            "nickName": "love destinesia",
            "grade": 3,
            "token": "ce94db3b1fd69b7c03308faf2cc912d8"
        }
 
        400:
        {
            "code": 1,
            "msg": "XX为空"
        }
 */
+ (void)user_register:(NSDictionary *)parameters
  withCompletionBlock:(CompletionBlock)completionBlock
       withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  user_login: /user/login
 *  POST
 *  @param parameters:
 *      key         : String    用户邮箱/昵称
 *      password    : String    MD5加密
        {
            "key": "traval@destinesia.cn",
            "password": "e10adc3949ba59abbe56e057f20f883e"
        }
 
 *  @return
 *      nickName    : String    昵称
 *      grade       : int       用户等级
 *      token       : String    TOKEN
 
        200:
        {
            "nickName": "love destinesia",
            "grade": 3,
            "token": "ce94db3b1fd69b7c03308faf2cc912d8"
        }

        400:
        {
            "code": 1,
            "msg": "用户不存在"
        }
  */
+ (void)user_login:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  user_resetPasswd: /user/reset
 *  POST
 *  @param parameters:
 *      mail        : String    用户邮箱
        {
            "mail": "traval@destinesia.cn"
        }
 
 *  @return
 
        200:
        {

        }

        400:
        {
            "code": 1,
            "msg": "用户不存在"
        }
 */
+ (void)user_resetPasswd:(NSDictionary *)parameters
     withCompletionBlock:(CompletionBlock)completionBlock
          withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  user_recommend: /user/recommend
 *
 *  @param parameters:
 *      recommend       : String    邀请码
        {
            "recommend": "wk68vn3d"
        }
 
 *  @return
 *      grade           : int       用户等级
        200:
        {
            "grade": 3,
        }

        400:
        {
            "code": 1,
            "msg": "邀请码为空"
        }
 */
+ (void)user_recommend:(NSDictionary *)parameters
   withCompletionBlock:(CompletionBlock)completionBlock
        withErrorBlock:(ErrorBlock)errorBlock;


@end
