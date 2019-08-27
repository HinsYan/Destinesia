//
//  DTSOrientationMonitor.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/15.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//


#import "DTSOrientationMonitor.h"
#import <CoreMotion/CoreMotion.h>

typedef struct {
	float x;			/**< The X-componenent of the vector. */
	float y;			/**< The Y-componenent of the vector. */
	float z;			/**< The Z-componenent of the vector. */
} Vector;

static inline Vector VectorMake(float x, float y, float z) {
	Vector v;
	v.x = x;
	v.y = y;
	v.z = z;
	return v;
}

/** Returns the dot-product of the two given vectors (v1 . v2). */
static inline float VectorDot(Vector v1, Vector v2) {
	return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
}

/** Returns the angle of the two given vectors (v1 . v2). */
static inline float VectorAngle(Vector v1, Vector v2) {
    float dot = VectorDot(v1, v2);
    dot = dot > 1.0f ? 1.0f : dot;
    dot = dot < -1.0f ? -1.0f :dot;
	return acosf(dot);
}


NSString *const kDTSOrientationMonitorDidChangeNotification  = @"kDTSOrientationMonitorDidChangeNotification";

@implementation DTSOrientationMonitor {

    UIDeviceOrientation willOrientation;
    
    CMMotionManager *motionManager;  // 重力感应
}

- (void)dealloc {
    [motionManager stopAccelerometerUpdates];
}

+ (instancetype)sharedInstance {
    static DTSOrientationMonitor *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSOrientationMonitor alloc] init];
        sharedInstance.deviceOrientation = UIDeviceOrientationPortrait;
    });
    return sharedInstance;
}

// 重力感应开启
- (void)beginOrientationMonitor {
    if (motionManager == nil) {
        motionManager = [[CMMotionManager alloc] init];
    }
    
    if (motionManager.accelerometerAvailable && !motionManager.isAccelerometerActive) {
        [motionManager setAccelerometerUpdateInterval:1/10.f];
        NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
        [motionManager startAccelerometerUpdatesToQueue:operationQueue withHandler:^(CMAccelerometerData *data,NSError *error)
         {
             if (!error) {                 
                 CMAcceleration acceleration = data.acceleration;
                 Vector accVector = VectorMake(acceleration.x, acceleration.y, acceleration.z);
                 
                 UIDeviceOrientation tmpOrientation;
                 
                 float radian = M_PI/180.0*40.0;
                 if (VectorAngle(accVector, VectorMake(0, -1, 0)) < radian) {
                     tmpOrientation = UIDeviceOrientationPortrait;
                 }
                 else if (VectorAngle(accVector, VectorMake(0, 1, 0)) < radian) {
                     tmpOrientation = UIDeviceOrientationPortraitUpsideDown;
                 }
                 else if (VectorAngle(accVector, VectorMake(-1, 0, 0)) < radian) {
                     tmpOrientation = UIDeviceOrientationLandscapeLeft;
                 }
                 else if (VectorAngle(accVector, VectorMake(1, 0, 0)) < radian) {
                     tmpOrientation = UIDeviceOrientationLandscapeRight;
                 }
                 else if (VectorAngle(accVector, VectorMake(0, 0, -1)) < radian) {
                     tmpOrientation = UIDeviceOrientationFaceUp;
                 }
                 else if (VectorAngle(accVector, VectorMake(0, 0, 1)) < radian) {
                     tmpOrientation = UIDeviceOrientationFaceDown;
                 }
                 else {
                     tmpOrientation = UIDeviceOrientationUnknown;
                 }
                 
                 if (tmpOrientation != willOrientation && tmpOrientation != UIDeviceOrientationUnknown) {
                     willOrientation = tmpOrientation;
                     [NSObject cancelPreviousPerformRequestsWithTarget:self];
                     [self performSelector:@selector(deviceOrientationChanged) withObject:nil afterDelay:0.5f];
                 }
             }
         }];
    }
}

- (void)endOrientationMonitor {
    if (motionManager) {
        [motionManager stopAccelerometerUpdates];
    }
}

- (void)deviceOrientationChanged {
    _deviceOrientation = willOrientation;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDTSOrientationMonitorDidChangeNotification object:nil];
}

- (UIImageOrientation)UIImageOrientationFromUIDeviceOrientation:(BOOL)isFront frontMirror:(BOOL)isForntMirror {
    
    UIImageOrientation orientImage = UIImageOrientationLeftMirrored;
    switch (_deviceOrientation)
    {
        case UIDeviceOrientationPortrait:
        default:
            if (isFront == YES) {
                if (isForntMirror) {
                    orientImage = UIImageOrientationLeftMirrored;
                }
                else{
                    orientImage = UIImageOrientationRight;
                }
            }
            else {
                orientImage = UIImageOrientationRight;
            }
            break;
        case UIDeviceOrientationLandscapeRight:
            if (isFront == YES) {
                if (isForntMirror) {
                    orientImage = UIImageOrientationUpMirrored;
                } else {
                    orientImage = UIImageOrientationUp;
                }
            }
            else {
                orientImage = UIImageOrientationDown;
            }
            
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (isFront == YES) {
                if (isForntMirror) {
                    orientImage = UIImageOrientationDownMirrored;
                } else {
                    orientImage = UIImageOrientationDown;
                }
            }
            else {
                orientImage = UIImageOrientationUp;
            }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            if (isFront == YES) {
                if (isForntMirror) {
                    orientImage = UIImageOrientationRightMirrored;
                } else {
                    orientImage = UIImageOrientationLeft;
                }
            }
            else {
                orientImage = UIImageOrientationLeft;
            }
            break;
    }
    
    return orientImage;
}

@end
