//
//  DTSUserInfoManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/7.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAccountManager.h"

typedef void(^CompletionBlock)(id responseObject);

@interface DTSAccountManager : NSObject

@property (nonatomic, strong) NSString *verifyCode;

@property (nonatomic, strong) RealmAccount *currentLoginAccount;

@property (nonatomic, assign) NSInteger authorGrade;

+ (instancetype)sharedInstance;

- (BOOL)verifyInviteCode:(NSString *)inviteCode
     withCompletionBlock:(CompletionBlock)completionBlock
          withErrorBlock:(ErrorBlock)errorBlock;

- (BOOL)registerWithUsername:(NSString *)username
                       email:(NSString *)email
                      passwd:(NSString *)passwd
         withCompletionBlock:(CompletionBlock)completionBlock
              withErrorBlock:(ErrorBlock)errorBlock;

- (BOOL)loginWithUsername:(NSString *)username
                   passwd:(NSString *)passwd
      withCompletionBlock:(CompletionBlock)completionBlock
           withErrorBlock:(ErrorBlock)errorBlock;

- (BOOL)logout;

- (BOOL)resetPasswd:(NSString *)username;

@end
