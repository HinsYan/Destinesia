//
//  UtilsMacro.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h


/*
 @note: debug模式日志打印宏
 */
#ifdef DEBUG
#define _DTSDebugShowLogs
#endif

#ifdef _DTSDebugShowLogs
#define DTSDebugShowLogs			1
//#define DTSLog( s, ... )        NSLog( @"<%s %@:(%d)> %@", __func__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define DTSString           [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DTSLog( ... )       printf("%s-%d: %s\n", [DTSString UTF8String], __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define DTSDebugShowLogs			0
#define DTSLog( s, ... )
#endif


// 屏幕尺寸
#define kDTSScreenSize          [[UIScreen mainScreen] bounds].size
#define kDTSScreenWidth         [[UIScreen mainScreen] bounds].size.width
#define kDTSScreenHeight        [[UIScreen mainScreen] bounds].size.height

#define kDTSScreenScale         [UIScreen mainScreen].scale
#define kDTSFullScreenSize      (CGSize){kDTSScreenWidth*kDTSScreenScale,kDTSScreenHeight*kDTSScreenScale}

// 机型
#define iPhone4                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6                 [[[UIDevice currentDevice] platformString] isEqualToString:@"iPhone 6"]
#define iPhone6Plus             [[[UIDevice currentDevice] platformString] isEqualToString:@"iPhone 6 Plus"]
#define iPhone6PlusBigMode      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6S                [[[UIDevice currentDevice] platformString] isEqualToString:@"iPhone 6S"]
#define iPhone6SStandard        [[[UIDevice currentDevice] platformString] isEqualToString:@"iPhone 6S"]&&([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6SPlus            [[[UIDevice currentDevice] platformString] isEqualToString:@"iPhone 6S Plus"]
#define iPhone6SPlusStandard    [[[UIDevice currentDevice] platformString] isEqualToString:@"iPhone 6S Plus"] && ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


// 颜色宏定义
#define RGB(r,g,b)              [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]
#define RGBA(r,g,b,a)           [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define RGBHEX(hex)             RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),1.f)
#define RGBAHEX(hex,a)          RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)

// APP主色调
#define kUIColorMain              RGBHEX(0x00AB99)


// 系统语言
#define CURRENT_LANGUAGE		([[NSLocale preferredLanguages] objectAtIndex:0])	// 当前语言

#define IS_LANGUAGE(l)			[CURRENT_LANGUAGE hasPrefix:l]	// 判断语言类型

#define IS_LANGUAGE_EN			IS_LANGUAGE(@"en")				// 英语
#define IS_LANGUAGE_ZH_HANS		IS_LANGUAGE(@"zh-Hans")			// 中文简体
#define IS_LANGUAGE_ZH_HANT		IS_LANGUAGE(@"zh-Hant")			// 中文繁体
#define IS_LANGUAGE_JA			IS_LANGUAGE(@"ja")				// 日语
#define IS_LANGUAGE_KO			IS_LANGUAGE(@"ko")				// 韩语





#endif /* UtilsMacro_h */
