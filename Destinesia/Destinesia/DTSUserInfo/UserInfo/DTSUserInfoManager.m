//
//  DTSUserInfoManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/7.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSUserInfoManager.h"
#import "DTSEncrypt.h"

@implementation DTSAccountManager

+ (instancetype)sharedInstance {
    static DTSAccountManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSAccountManager alloc] init];
    });
    return sharedInstance;
}

- (RealmAccount *)currentLoginAccount {
    _currentLoginAccount = [RealmAccountManager currentLoginAccount];
    
    return _currentLoginAccount;
}

- (BOOL)verifyInviteCode:(NSString *)inviteCode
     withCompletionBlock:(CompletionBlock)completionBlock
          withErrorBlock:(ErrorBlock)errorBlock
{
    // TODO: /user/recommend, 返回信息包括grade
    NSDictionary *parameters = @{
                                 @"recommend": inviteCode
                                 };
    [DTSHTTPRequest user_recommend:parameters
               withCompletionBlock:completionBlock
                    withErrorBlock:errorBlock];
    
    return YES;
}

- (BOOL)registerWithUsername:(NSString *)username
                       email:(NSString *)email
                      passwd:(NSString *)passwd
         withCompletionBlock:(CompletionBlock)completionBlock
              withErrorBlock:(ErrorBlock)errorBlock
{
    NSDictionary *parameters = @{
                                 @"nickName": username,
                                 @"name": @"",
                                 @"password": [DTSEncrypt encryptViaMD5:passwd],
                                 @"mail": email,
                                 @"lat": @123,
                                 @"lon": @23,
                                 @"deviceId": @"1FD69B7C03308FAF",
                                 @"recommend": _verifyCode,  // 推荐码必需
                                 @"inviteCode": _verifyCode, // 暂不需要
                                 @"plantform": @0,
                                 };
    [DTSHTTPRequest user_register:parameters
              withCompletionBlock:completionBlock
                   withErrorBlock:errorBlock];
    return YES;
}

- (BOOL)loginWithUsername:(NSString *)username
                   passwd:(NSString *)passwd
      withCompletionBlock:(CompletionBlock)completionBlock
           withErrorBlock:(ErrorBlock)errorBlock
{
    // TODO:
    NSDictionary *parameters = @{
                                 @"key": username,
                                 @"password": [DTSEncrypt encryptViaMD5:passwd],
                                 };
    [DTSHTTPRequest user_login:parameters
           withCompletionBlock:completionBlock
                withErrorBlock:errorBlock];
    return YES;
}

- (BOOL)logout {
    _currentLoginAccount = nil;
    return [RealmAccountManager logout];
}

- (BOOL)resetPasswd:(NSString *)username {
    NSDictionary *parameters = @{
                                 @"mail": @"traval@destinesia.cn",
                                 };
    [DTSHTTPRequest user_resetPasswd:parameters withCompletionBlock:^(id responseObject) {
        
    } withErrorBlock:^(id responseObject) {
        
    }];
    
    return NO;
}

@end
