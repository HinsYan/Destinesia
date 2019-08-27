//
//  DTSToastUtil.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^LoadingOperationBlock)();
typedef void(^LoadingCompletionBlock)();

@interface DTSToastUtil : NSObject

+ (void)toastWithText:(NSString*)text;

+ (void)toastWithText:(NSString*)text withShowTime:(NSTimeInterval)showTime;

/**
 *  loading
 *
 *  @param loadingOperationBlock running in background
 *  @param completionBlock       running in main thread
 */
+ (void)loadingWithOperationBlock:(LoadingOperationBlock)loadingOperationBlock
              withCompletionBlock:(LoadingCompletionBlock)completionBlock;

@end
