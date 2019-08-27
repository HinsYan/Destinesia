//
//  DTSNetworking.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSNetworking.h"
#import "Reachability.h"
#import "AFNetworking.h"

@implementation DTSNetworking

+ (BOOL)isNetworkReachable {
    if ([Reachability reachabilityForInternetConnection].isReachable) {
        return YES;
    }
    
    return NO;
}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
   progress:(void (^)(NSProgress *downloadProgress))downloadProgress
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    if (![self isNetworkReachable]) {
        return;
    }
    
    [[AFHTTPSessionManager manager] GET:URLString
                             parameters:parameters
                               progress:downloadProgress
                                success:success
                                failure:failure];
     
}

@end
