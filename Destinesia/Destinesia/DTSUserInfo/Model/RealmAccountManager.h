//
//  RealmAccountManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/8.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAccount.h"

@interface RealmAccountManager : NSObject

+ (BOOL)addAccount:(RealmAccount *)account;
+ (BOOL)deleteAccount:(RealmAccount *)account;
+ (BOOL)updateAccount;

+ (RLMResults *)queryAccount;
+ (RLMResults *)queryRealmAccountSortedBy:(NSString *)sortedProperty;
+ (RLMResults *)queryRealmAccountFilteredBy:(NSPredicate *)filterCondition;
+ (RLMResults *)queryRealmAccountWhere:(NSString *)whereConfition;

+ (RealmAccount *)currentLoginAccount;

+ (RealmAccount *)loginWithUsername:(NSString *)username
                             passwd:(NSString *)passwd
                          userGrade:(NSInteger)userGrade;

+ (BOOL)logout;

@end
