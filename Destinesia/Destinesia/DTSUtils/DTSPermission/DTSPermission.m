//
//  DTSPermission.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSPermission.h"

#import <AVFoundation/AVFoundation.h>

@implementation DTSPermission

#pragma mark - Camera

+ (BOOL)isCameraPermissionAllowed
{
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (void)requestCameraPermission:(PermissionRequestCompletionBlock)completionBlock
{
    
}

#pragma mark - Album

+ (BOOL)isAlbumPermissionAllowed
{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

+ (void)requestAlbumPermission:(PermissionRequestCompletionBlock)completionBlock
{

}

#pragma mark - Location

+ (BOOL)isLocationPermissionAllowed {
    return YES;
}

+ (void)requestLocationPermission:(PermissionRequestCompletionBlock)completionBlock
{

}
//+ (void)requestAlbumPermission:(Block)block {
//    
//    //  权限处理
//    switch ([PHPhotoLibrary authorizationStatus]) {
//        case PHAuthorizationStatusNotDetermined:
//        {
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (status == PHAuthorizationStatusAuthorized) {
//                        block(PermissionAllowed);
//                    } else {
//                        block(PermissionNotDetermined);
//                    }
//                });
//            }];
//        }
//            break;
//        case PHAuthorizationStatusRestricted:
//        case PHAuthorizationStatusDenied:
//        {
//            block(PermissionDenied);
//        }
//            break;
//        case PHAuthorizationStatusAuthorized:
//        {
//            block(PermissionAllowed);
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//+ (void)requestCameraPermission:(Block)block {
//    
//    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authorizationStatus == AVAuthorizationStatusNotDetermined) {
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//            
//            if (granted) {
//                block(PermissionAllowed);
//            } else {
//                block(PermissionDenied);
//            }
//        }];
//    } else if (authorizationStatus == AVAuthorizationStatusAuthorized) {
//        block(PermissionAllowed);
//    } else {
//        block(PermissionDenied);
//    }
//}

@end
