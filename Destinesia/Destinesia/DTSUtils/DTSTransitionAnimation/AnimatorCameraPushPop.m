//
//  AnimatorCameraPushPop.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/19.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "AnimatorCameraPushPop.h"

@implementation AnimatorCameraPushPop

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];
}

- (void)animationPush {
    self.containerView.backgroundColor = self.toView.backgroundColor;
    
    UIView *fromView = self.fromView;
    UIView *toView = self.toView;
    toView.alpha = 0.f;
    
    [self.containerView addSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    typeof (&*self) __weak weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.f;
        toView.alpha = 1.f;
    } completion:^(BOOL finished) {
        //        fromView.alpha = 1.f;
        
        [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
    }];
}

- (void)animationPop {
    self.containerView.backgroundColor = self.toView.backgroundColor;
    
    UIView *fromView = self.fromView;
    UIView *toView = self.toView;
    toView.alpha = 0.f;
    
    [self.containerView addSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    typeof (&*self) __weak weakSelf = self;
    
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.f;
        toView.alpha = 1.f;
    } completion:^(BOOL finished) {
        //        fromView.alpha = 1.f;
        
        [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
    }];
}

- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"%s", __func__);
}

@end

