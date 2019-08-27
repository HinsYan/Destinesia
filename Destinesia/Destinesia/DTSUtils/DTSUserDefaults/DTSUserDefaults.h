//
//  DTSUserDefaults.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSUserDefaults : NSObject

#pragma mark - Release

+ (BOOL)isNewVersionReleased;
+ (void)setIsNewVersionReleased:(BOOL)hasReleased;

#pragma mark - Welcome

+ (BOOL)isWelcomeShown;
+ (void)setIsWelcomeShown:(BOOL)hasShown;

#pragma mark - Invite

+ (BOOL)isInvited;
+ (void)setIsInvited:(BOOL)hasInvited;

#pragma mark - User Info

+ (NSString *)userToken;
+ (void)setUserToken:(NSString *)userToken;

#pragma mark - Album

+ (BOOL)isDestinesiaAlbumExisting;
+ (void)setIsDestinesiaAlbumExisting:(BOOL)isExisting;

#pragma mark - DeviceNO

+ (NSString *)deviceNO;
+ (void)setDeviceNO:(NSString *)deviceNO;

#pragma mark - isContinueUploading

+ (BOOL)isContinueUploading;
+ (void)setIsContinueUploading:(BOOL)isContinueUploading;

@end
