//
//  DTSToastUtil.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSToastUtil.h"
#import "MBProgressHUD.h"

#import "UIApplication+DTSCategory.h"

@implementation DTSToastUtil

+ (void)toastWithText:(NSString*)text {
    [self toastWithText:text withShowTime:1.0f];
}

+ (void)toastWithText:(NSString*)text withShowTime:(NSTimeInterval)showTime {
//    UIWindow *window = [UIApplication sharedApplication].windows[0];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
//    [window addSubview:hud];
    
    UIView *currentView = [[UIApplication sharedApplication] dts_currentViewController].view;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:currentView];
    [currentView addSubview:hud];
    
    hud.detailsLabel.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = hud.label.font;
    hud.minShowTime = showTime;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:hud.minShowTime];
}

+ (void)loadingWithOperationBlock:(LoadingOperationBlock)loadingOperationBlock
              withCompletionBlock:(LoadingCompletionBlock)completionBlock
{
    UIView *currentView = [[UIApplication sharedApplication] dts_currentViewController].view;
    
    [MBProgressHUD showHUDAddedTo:currentView animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (loadingOperationBlock) {
            loadingOperationBlock();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:currentView animated:YES];
            
            if (completionBlock) {
                completionBlock();
            }
        });
    });
}


@end
