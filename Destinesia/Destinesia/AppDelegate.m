//
//  AppDelegate.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "AppDelegate.h"
#import "DTSReleaseControl.h"
#import "DTSUserInfoManager.h"
#import "DTSInviteViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DTSUserDefaults setIsContinueUploading:NO];
    
    if (![DTSUserDefaults deviceNO]) {
        [DTSUserDefaults setDeviceNO:[UIDevice currentDevice].identifierForVendor.UUIDString];
    }
    
    // Override point for customization after application launch.
    /*
    if (IS_TEST_ENV) {
        DTSLog(@"test env");
    } else {
        DTSLog(@"product env");
    }

    DTSLog(@"%@", URLTest);
    
    DTSLog(@"This version released : %d", [DTSReleaseControl isNewVersionReleased]);
     */
    
    [RealmAccountManager queryAccount];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kDTSScreenWidth, kDTSScreenHeight)];
    [self.window makeKeyAndVisible];
    
    if (![DTSUserDefaults isInvited]) {
        [DTSUserDefaults setIsInvited:YES];
        [self gotoInvite];
        return YES;
    }
    
    [self gotoCamera];
    
    return YES;
}

- (void)gotoInvite {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTSInviteViewController *inviteVC = [main instantiateViewControllerWithIdentifier:@"DTSInviteViewController"];
    self.window.rootViewController = inviteVC;
}

- (void)gotoCamera {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *cameraNav = [main instantiateViewControllerWithIdentifier:@"DTSCameraNavigationController"];
    self.window.rootViewController = cameraNav;
}

#pragma mark - Migration

- (void)addRealmConfigurationMigrationBlock {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1; // migration需要指定
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 没有执行过migration, 则oldSchemaVersion为0
        if (oldSchemaVersion < config.schemaVersion) {
            [migration enumerateObjects:RealmAccount.className
                                  block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                                      
                                      // 如v1已经有了isMarried属性, 就不重复migration
                                      // 使用场景:用户A每次及时更新(v0->v1->v2); 而用户B不及时,可能跳级(v0->v2).
                                      if (oldSchemaVersion < 1) {
                                          newObject[@"isMarried"] = @NO;
                                      }
                                      
                                      //                                      if (oldSchemaVersion < 2) {
                                      //                                          newObject[@"username"] = @"";
                                      //                                      }
                                      
                                  }];
            
            // rename与enumerateObjects无关, 不能放在其中.
            //            [migration renamePropertyForClass:PersonRealm.className oldName:@"username" newName:@"username"];
        }
        
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
