//
//  ViewInviteWelcome.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "ViewBaseXXNibBridge.h"

@protocol ViewInviteWelcomeDelegate <NSObject>

- (void)ViewInviteWelcomeActionGotoCamera;

@end


@interface ViewInviteWelcome : ViewBaseXXNibBridge

@property (nonatomic, weak) id<ViewInviteWelcomeDelegate> delegate;

@end
