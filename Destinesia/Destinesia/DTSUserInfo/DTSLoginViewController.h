//
//  DTSLoginViewController.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/8.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSUserInfoManager.h"

@protocol DTSLoginViewControllerDelegate <NSObject>

- (void)DTSLoginViewControllerDelegateLoginOK;

- (void)DTSLoginViewControllerDelegateLoginFail;

@end


@interface DTSLoginViewController : UIViewController

@property (nonatomic, weak) id<DTSLoginViewControllerDelegate> delegate;

@end
