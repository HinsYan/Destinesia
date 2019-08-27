//
//  DTSLocation.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/14.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSLocation.h"


@interface DTSLocation () <

    CLLocationManagerDelegate
>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation DTSLocation

- (void)dealloc {
    [self stopLocation];
    _locationManager = nil;
}

+ (instancetype)sharedInstance {
    static DTSLocation *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSLocation alloc] init];
        [sharedInstance initLocationManager];
    });
    return sharedInstance;
}

- (void)initLocationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyKilometer;
        _locationManager.delegate = self;
    } else {
        [DTSToastUtil toastWithText:@"当前定位不可用" withShowTime:2.0f];
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

- (void)startLocation {
    [_locationManager startUpdatingLocation];
}

- (void)stopLocation {
    [_locationManager stopUpdatingHeading];
}

- (void)cityOfLocation:(CLLocation *)location withCompletionBlock:(DTSLocationCompletionBlock)completionBlock
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *currentCity;
        
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *country = placemark.country;
            NSString *province = placemark.administrativeArea;
            currentCity = placemark.locality;
            NSString *district = placemark.subLocality;
            NSArray<NSString *> *areasOfInterest = placemark.areasOfInterest;
            if (areasOfInterest.count == 0) {
                currentCity = [NSString stringWithFormat:@"%@, %@, %@", district, currentCity, country];
            } else {
                currentCity = [NSString stringWithFormat:@"%@, %@, %@", areasOfInterest[0], currentCity, country];
            }
        }
        
        if (completionBlock) {
            completionBlock(currentCity);
        }
        
    }];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self startLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    _currentLocation = locations.lastObject;
    DTSLog(@"%f, %f", _currentLocation.coordinate.longitude, _currentLocation.coordinate.latitude);
    
    [self cityOfLocation:_currentLocation withCompletionBlock:^(NSString *currentCity) {
        
        _currentCity = currentCity;
        
        DTSLog(@"定位信息 %f - %f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
        DTSLog(@"定位城市 %@", _currentCity);
               
        if (_currentCity) {
            if (_delegate && [_delegate respondsToSelector:@selector(DTSLocationDoneWithLocation:withCity:)]) {
                [_delegate DTSLocationDoneWithLocation:_currentLocation withCity:_currentCity];
            }
        } else {
            _currentCity = @"无法定位当前城市";
            if (_delegate && [_delegate respondsToSelector:@selector(DTSLocationFail)]) {
                [_delegate DTSLocationFail];
            }
        }
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

}

@end
