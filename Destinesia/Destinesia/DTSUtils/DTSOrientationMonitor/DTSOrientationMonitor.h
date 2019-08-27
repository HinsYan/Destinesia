//
//  DTSOrientationMonitor.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/15.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//


extern NSString *const kDTSOrientationMonitorDidChangeNotification;

@interface DTSOrientationMonitor : NSObject

@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

/**
 *  app 内部方向设备管理对象 （#注意#:首次创建单实例前需要开启重力感应, 退出相机后关闭重力感应）
 *
 *  @return 返回单实例的管理设备方向的对象
 */
+ (instancetype)sharedInstance;

/**
 *  重力感应开启/关闭
 */
- (void)beginOrientationMonitor;
- (void)endOrientationMonitor;

@end
