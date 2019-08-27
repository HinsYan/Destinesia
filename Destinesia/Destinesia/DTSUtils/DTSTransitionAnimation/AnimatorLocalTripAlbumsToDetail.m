//
//  AnimatorLocalTripAlbumsToDetail.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "AnimatorLocalTripAlbumsToDetail.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation AnimatorLocalTripAlbumsToDetail

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.toView.bounds];
    [DTSPhotoDownloader downloadPhoto:_imageURL withCompletionBlock:^(UIImage *image) {
        if (image) {
            imageView.image = [image dts_imageFitTargetSize:imageView.frame.size];
        }
    }];
    
    [self.containerView addSubview:imageView];
    imageView.center = _itemCenter;
    
    CGFloat initialScale = _itemSize.width / CGRectGetWidth(imageView.frame);
    imageView.transform = CGAffineTransformMakeScale(initialScale, initialScale);
    
    NSLog(@"y : %f", imageView.center.y);
    
    // toView在UIImageView到达最终位置，动画完成之后再显示出来
    self.toView.frame = [self.transitionContext finalFrameForViewController:self.to];
    [self.containerView addSubview:self.toView];
    CGPoint toViewFinalCenter = self.toView.center;
    self.toView.center = toViewFinalCenter;
    self.toView.alpha = 0.0f;
    
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    typeof (&*self) __weak weakSelf = self;
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.transform = CGAffineTransformIdentity;
        imageView.center = toViewFinalCenter;
        
        self.fromView.alpha = 0.0f; // fromView 渐隐
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        
        weakSelf.toView.alpha = 1.0f;
        weakSelf.fromView.alpha = 1.0f;
        
        [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
    }];
}

- (void)animationPop {
    self.toView.frame = [self.transitionContext finalFrameForViewController:self.to];
    [self.containerView insertSubview:self.toView belowSubview:self.fromView];
    
    self.toView.alpha = 0.0f;
    
    self.fromView.backgroundColor = [UIColor clearColor];
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    typeof (&*self) __weak weakSelf = self;
    
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat initialScale = _itemSize.width / 200;
        weakSelf.fromView.transform = CGAffineTransformMakeScale(initialScale, initialScale);
        weakSelf.fromView.center = weakSelf.itemCenter;
        
        weakSelf.toView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        weakSelf.fromView.alpha = 0.0f;
        
        [weakSelf.transitionContext completeTransition:![weakSelf.transitionContext transitionWasCancelled]];
    }];
}

- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"%s", __func__);
}

@end
