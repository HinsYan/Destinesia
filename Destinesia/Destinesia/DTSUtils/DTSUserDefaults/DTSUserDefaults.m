//
//  DTSUserDefaults.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSUserDefaults.h"


//static NSString *const kIsNewVersionReleased    = @"kIsNewVersionReleased";

#define kIsNewVersionReleased           [NSString stringWithFormat:@"%@_versionReleased", APP_VERSION]

#define kIsWelcomeShown                 [NSString stringWithFormat:@"%@_welcomeShown", APP_VERSION]

#define kIsUserInvited                  @"kIsUserInvited"

#define kUserToken                      @"kUserToken"

#define kIsDestinesiaAlbumExisting      @"kIsDestinesiaAlbumExisting"

#define kDeviceNO                       @"kDeviceNO"

#define kIsContinueUploading            @"kIsContinueUploading"


@implementation DTSUserDefaults

#pragma mark - Release

+ (BOOL)isNewVersionReleased {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsNewVersionReleased];
}

+ (void)setIsNewVersionReleased:(BOOL)hasReleased {
    [[NSUserDefaults standardUserDefaults] setBool:hasReleased forKey:kIsNewVersionReleased];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Welcome

+ (BOOL)isWelcomeShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsWelcomeShown];
}

+ (void)setIsWelcomeShown:(BOOL)hasShown {
    [[NSUserDefaults standardUserDefaults] setBool:hasShown forKey:kIsWelcomeShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Invite

+ (BOOL)isInvited {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsUserInvited];
}

+ (void)setIsInvited:(BOOL)hasInvited {
    [[NSUserDefaults standardUserDefaults] setBool:hasInvited forKey:kIsUserInvited];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - User Info

+ (NSString *)userToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserToken];
}

+ (void)setUserToken:(NSString *)userToken
{
    [[NSUserDefaults standardUserDefaults] setValue:userToken forKey:kUserToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Album

+ (BOOL)isDestinesiaAlbumExisting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsDestinesiaAlbumExisting];
}

+ (void)setIsDestinesiaAlbumExisting:(BOOL)isExisting {
    [[NSUserDefaults standardUserDefaults] setBool:isExisting forKey:kIsDestinesiaAlbumExisting];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - DeviceNO

+ (NSString *)deviceNO
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceNO];
}

+ (void)setDeviceNO:(NSString *)deviceNO
{
    [[NSUserDefaults standardUserDefaults] setValue:deviceNO forKey:kDeviceNO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - isUploading

+ (BOOL)isContinueUploading
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsContinueUploading];
}

+ (void)setIsContinueUploading:(BOOL)isContinueUploading
{
    [[NSUserDefaults standardUserDefaults] setBool:isContinueUploading forKey:kIsContinueUploading];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
