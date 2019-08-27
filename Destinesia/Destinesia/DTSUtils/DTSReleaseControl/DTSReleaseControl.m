//
//  DTSReleaseControl.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSReleaseControl.h"
#import "DTSNetworking.h"

@implementation DTSReleaseControl

+ (BOOL)isNewVersionReleased {
    [self queryNewVersion];
    
    return [DTSUserDefaults isNewVersionReleased];
}

+ (void)queryNewVersion {
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", APP_ID_APPSTORE];
    
    [DTSNetworking GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject && [[responseObject objectForKey:@"results"][0] objectForKey:@"version"]) {
            NSString *version = [[responseObject objectForKey:@"results"][0] objectForKey:@"version"];
            
            if ([APP_VERSION compare:version] != NSOrderedDescending) {
                DTSLog(@"version released : %@", version);
                [DTSUserDefaults setIsNewVersionReleased:YES];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DTSLog(@"%@", error);
    }];
}

@end
