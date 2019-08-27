//
//  AppMacro.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


// ENV
#ifdef TEST_ENV
#define IS_TEST_ENV 1
#else
#define IS_TEST_ENV 0
#endif


//  iTunes ID
#define APP_ID_APPSTORE @"1096082348"

#define APP_NAME        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//#define kSystemAlbum    @"Camera Roll" // 模拟器, iOS 8
#define kSystemAlbum    @"All Photos"

// 本地推送周期
#if IS_TEST_ENV
#define kLocalNotificationTimeInterval_7Days        (60*5)
#define kLocalNotificationTimeInterval_30Days       (60*8)
#else
#define kLocalNotificationTimeInterval_7Days        (24*60*60*7)
#define kLocalNotificationTimeInterval_30Days       (24*60*60*30)
#endif



#endif /* AppMacro_h */
