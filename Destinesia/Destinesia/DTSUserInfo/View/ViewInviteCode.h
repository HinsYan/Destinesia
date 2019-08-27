//
//  ViewInviteCode.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewBaseXXNibBridge.h"

@protocol ViewInviteCodeDelegate <NSObject>

- (void)ViewInviteCodeActionDone:(NSString *)verifyCode;

@end

@interface ViewInviteCode : ViewBaseXXNibBridge

@property (nonatomic, weak) id<ViewInviteCodeDelegate> delegate;

- (void)beginInputInviteKey;

- (BOOL)verifyInviteCode;

@end
