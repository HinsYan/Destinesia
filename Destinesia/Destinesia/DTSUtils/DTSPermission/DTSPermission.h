//
//  DTSPermission.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSPermissionView.h"

typedef NS_ENUM(NSUInteger, PermissionRequestResult) {
    kPermissionRequestResult_Allowed,
    kPermissionRequestResult_NotDetermined,
    kPermissionRequestResult_Denied,
};


typedef void(^PermissionRequestCompletionBlock)(PermissionRequestResult permissionRequestResult);


@interface DTSPermission : NSObject

#pragma mark - Camera

+ (BOOL)isCameraPermissionAllowed;
+ (void)requestCameraPermission:(PermissionRequestCompletionBlock)completionBlock;

#pragma mark - Album

+ (BOOL)isAlbumPermissionAllowed;
+ (void)requestAlbumPermission:(PermissionRequestCompletionBlock)completionBlock;

#pragma mark - Location

+ (BOOL)isLocationPermissionAllowed;
+ (void)requestLocationPermission:(PermissionRequestCompletionBlock)completionBlock;

@end
