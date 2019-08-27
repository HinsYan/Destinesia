//
//  DTSWelcomeViewController.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/13.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSWelcomeViewControllerDelegate <NSObject>

- (void)DTSWelcomeViewControllerDone;

- (void)DTSWelcomeViewControllerSkip;

@end


@interface DTSWelcomeViewController : UIViewController

@property (nonatomic, weak) id<DTSWelcomeViewControllerDelegate> delegate;

@end
