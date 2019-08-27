//
//  DTSHTTPRequestManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/21.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSHTTPRequestManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation DTSHTTPRequestManager

+ (void)startMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (BOOL)isNetworkReachable
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

+ (BOOL)isNetworkReachableWithAlert:(BOOL)showAlert
{
    BOOL isReachable = [self isNetworkReachable];
    
    if (!isReachable && showAlert) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前无网络可以使用" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:cancel];
        
        [[self currentViewController] presentViewController:alert animated:YES completion:nil];
    }
    
    return isReachable;
}

+ (UIViewController *)currentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}


+ (void)GET:(NSString *)urlString
withParameters:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    
    [requestManager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject : %@", responseObject);
        
        if (completionBlock) {
            completionBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:errorData
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:nil];
        
        if (errorBlock) {
            errorBlock(responseObject);
        }
    }];
}

+ (void)POST:(NSString *)urlString
withParameters:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    
    [requestManager POST:[NSString stringWithFormat:@"%@%@", DTS_REST_API_BASE_URL, urlString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            completionBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!errorBlock) {
            return;
        }
        
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:errorData
                                                                           options:NSJSONReadingMutableLeaves
                                                                             error:nil];
            
            errorBlock(responseObject);
        } else {
            errorBlock(error);
        }
    }];
}

+ (void)POST_JSON_Content:(NSString *)urlString
           withParameters:(NSDictionary *)parameters
      withCompletionBlock:(CompletionBlock)completionBlock
           withErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // AFN会自己设置content-type
//        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", DTS_REST_API_BASE_URL, urlString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DTSLog(@"responseObject : %@", responseObject);
        
        if (completionBlock) {
            completionBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:errorData
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:nil];
        
        if (errorBlock) {
            errorBlock(responseObject);
        }
    }];
}

+ (void)PUT:(NSString *)urlString
withParameters:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    
    DTSLog(@"parameters : %@", parameters);
    
    [requestManager PUT:[NSString stringWithFormat:@"%@%@", DTS_REST_API_BASE_URL, urlString] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@", responseObject);
        
        if (completionBlock) {
            completionBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:errorData
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:nil];
        
        if (errorBlock) {
            errorBlock(responseObject);
        }
    }];
}

@end

