//
//  DTSWelcomeViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/13.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSWelcomeViewController.h"
#import "EAIntroView.h"

@interface DTSWelcomeViewController () <

    EAIntroDelegate
>

@end

@implementation DTSWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWelcomeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWelcomeView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello Destinesia";
    page1.desc = @"sample desc 1";
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Page 2";
    page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page2.titlePositionY = 220;
    page2.desc = @"sample desc 2";
    page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page2.descPositionY = 200;
//    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchScreen.jpg"]];
//    page2.titleIconPositionY = 0;
    
//    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"ViewInviteWelcome"];
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:self.view.bounds
                                                       andPages:@[page1, page2]];
    introView.delegate = self;
    [introView showInView:self.view animateDuration:0 withInitialPageIndex:0];
}

#pragma mark - <EAIntroDelegate>

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    if (wasSkipped) {
        if (_delegate && [_delegate respondsToSelector:@selector(DTSWelcomeViewControllerSkip)]) {
            [_delegate DTSWelcomeViewControllerSkip];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(DTSWelcomeViewControllerDone)]) {
            [_delegate DTSWelcomeViewControllerDone];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

@end
