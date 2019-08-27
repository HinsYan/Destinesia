//
//  AppConstant.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "AppConstant.h"

@implementation AppConstant

#if IS_TEST_ENV

NSString *const DTS_REST_API_BASE_URL   = @"http://139.224.67.45/destinesia";
NSString *const DTS_QINIU_BASE_URL      = @"http://oe5b5o4wx.bkt.clouddn.com/";

#else

NSString *const DTS_REST_API_BASE_URL   = @"http://139.224.67.45/destinesia";
NSString *const DTS_QINIU_BASE_URL      = @"http://oe5b5o4wx.bkt.clouddn.com/";

#endif

@end
