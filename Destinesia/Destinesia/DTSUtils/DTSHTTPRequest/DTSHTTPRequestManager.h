//
//  DTSHTTPRequestManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/21.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(id responseObject);
typedef void(^ErrorBlock)(id responseObject);

@interface DTSHTTPRequestManager : NSObject

+ (void)startMonitoring;

+ (void)stopMonitoring;

+ (BOOL)isNetworkReachable;

+ (BOOL)isNetworkReachableWithAlert:(BOOL)showAlert;

+ (void)GET:(NSString *)urlString
withParameters:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;

+ (void)POST:(NSString *)urlString
withParameters:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;

+ (void)POST_JSON_Content:(NSString *)urlString
           withParameters:(NSDictionary *)parameters
      withCompletionBlock:(CompletionBlock)completionBlock
           withErrorBlock:(ErrorBlock)errorBlock;

+ (void)PUT:(NSString *)urlString
withParameters:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock;

@end
