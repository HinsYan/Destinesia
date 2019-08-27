//
//  ViewInviteUserInfo.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewBaseXXNibBridge.h"

@protocol ViewInviteUserInfoDelegate <NSObject>

- (void)ViewInviteUserInfoActionDone;

@end

@interface ViewInviteUserInfo : ViewBaseXXNibBridge

@property (nonatomic, weak) id<ViewInviteUserInfoDelegate> delegate;

- (void)beginInputUsername;

- (BOOL)completeUserInfo;
    
@end
