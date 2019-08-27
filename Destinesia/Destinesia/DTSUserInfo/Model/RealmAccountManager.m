//
//  RealmAccountManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/8.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "RealmAccountManager.h"
#import "DTSUserInfoManager.h"

@implementation RealmAccountManager

+ (BOOL)addAccount:(RealmAccount *)account {
    RealmAccount *tempAccount = [[RealmAccount alloc] init];
    tempAccount.username = @"username";
    tempAccount.email = @"email";
    tempAccount.passwd = @"passwd";
    tempAccount.authorGrade = 2;
    tempAccount.lastCity = @"lastCity";
    tempAccount.token = @"token";
    tempAccount.isCurrentLogin = YES;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:tempAccount];
    }];
    
    return YES;
}

+ (BOOL)deleteAccount:(RealmAccount *)account {
    RLMResults *accounts = [RealmAccount objectsWhere:@"grade == 1"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        if (accounts.count != 0) {
            [realm deleteObject:accounts[0]];
        }
    }];
    
    return YES;
}

+ (BOOL)updateAccount {
    RLMResults *accounts = [RealmAccount objectsWhere:@"lastCity == lastCity"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        if (accounts.count != 0) {
            RealmAccount *account = accounts[0];
            account.authorGrade = 2;
        }
    }];
    
    return YES;
}

+ (RLMResults *)queryAccount {
    RLMResults *accounts = [RealmAccount allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    DTSLog(@"fileURL : %@", realm.configuration.fileURL);
    
    for (RealmAccount *account in accounts) {
        DTSLog(@"account : %@", account);
    }
    
    return accounts;
}

+ (RLMResults *)queryRealmAccountSortedBy:(NSString *)sortedProperty {
    RLMResults *accounts = [[RealmAccount allObjects] sortedResultsUsingProperty:sortedProperty ascending:YES];
    
//    for (RealmAccount *account in accounts) {
//        DTSLog(@"account : %@", account);
//    }
    
    return accounts;
}

+ (RLMResults *)queryRealmAccountFilteredBy:(NSPredicate *)filterCondition {
    RLMResults *accounts = [RealmAccount objectsWithPredicate:filterCondition];
    
//    for (RealmAccount *account in accounts) {
//        DTSLog(@"account : %@", account);
//    }
    
    return accounts;
}

+ (RLMResults *)queryRealmAccountWhere:(NSString *)whereConfition {
    // objectsWhere:@"age == 2"
    RLMResults *accounts = [RealmAccount objectsWhere:whereConfition];
    
    //    for (RealmAccount *account in accounts) {
    //        DTSLog(@"account : %@", account);
    //    }
    
    return accounts;
}

+ (RealmAccount *)currentLoginAccount {
    RLMResults *accounts = [RealmAccount objectsWhere:@"isCurrentLogin == YES"];
    if (accounts.count == 1) {
        return [accounts firstObject];
    }
    
    return nil;
}

+ (RealmAccount *)loginWithUsername:(NSString *)username
                             passwd:(NSString *)passwd
                          userGrade:(NSInteger)userGrade
{
    RealmAccount *account;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@ AND passwd == %@", username, passwd];
    RLMResults *accounts = [RealmAccountManager queryRealmAccountFilteredBy:predicate];
    if (accounts.count != 0) {
        account = accounts.firstObject;
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            account.token = [DTSUserDefaults userToken];
            account.authorGrade = userGrade;
            account.isCurrentLogin = YES;
        }];
    } else {
        account = [[RealmAccount alloc] init];
        account.username = username;
        account.passwd = passwd;
        account.token = [DTSUserDefaults userToken];
        account.authorGrade = userGrade;
        account.isCurrentLogin = YES;
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:account];
        }];
    }
    
    [DTSAccountManager sharedInstance].currentLoginAccount = account;
    
    return account;
}

+ (BOOL)logout {
    RealmAccount *currentLoginAccount = [self currentLoginAccount];
    if (currentLoginAccount != nil) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            currentLoginAccount.isCurrentLogin = NO;
        }];
    }
    
    return YES;
}

@end
