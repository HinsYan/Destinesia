//
//  DTSLocation.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/14.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^DTSLocationCompletionBlock)(NSString *currentCity);


@protocol DTSLocationDelegate <NSObject>

- (void)DTSLocationDoneWithLocation:(CLLocation *)location withCity:(NSString *)city;

- (void)DTSLocationFail;

@end

@interface DTSLocation : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id <DTSLocationDelegate> delegate;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSString *currentCity;

- (void)startLocation;
- (void)stopLocation;

- (void)cityOfLocation:(CLLocation *)location withCompletionBlock:(DTSLocationCompletionBlock)completionBlock;

@end
