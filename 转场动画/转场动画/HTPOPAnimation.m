//
//  HTPOPAnimation.m
//  转场动画
//
//  Created by 张海涛 on 2017/3/16.
//  Copyright © 2017年 张海涛. All rights reserved.
//

#import "HTPOPAnimation.h"

@implementation HTPOPAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toViewController = toViewController;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    // parallax effect; the offset matches the one used in the pop animation in iOS 7.1
    CGFloat toViewControllerXTranslation = - CGRectGetWidth([transitionContext containerView].bounds) * 0.3f;
    toViewController.view.transform = CGAffineTransformMakeTranslation(toViewControllerXTranslation, 0);
    
    // add a shadow on the left side of the frontmost view controller
    UIView *dimmingView = [[UIView alloc] initWithFrame:toViewController.view.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [toViewController.view addSubview:dimmingView];
    // Uses linear curve for an interactive transition, so the view follows the finger. Otherwise, uses a navigation transition curve.
    UIViewAnimationOptions curveOption = UIViewAnimationOptionCurveLinear;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionNone | curveOption animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.frame.size.width, 0);
        dimmingView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        /*完成和取消都会进来   如果完成了  toViewController 和 fromViewController 都会回到原来的位置 只是fromViewController还得释放掉
         如果取消了  fromViewController 回到原来的位置  toViewController 通过 - (void)animationEnded:(BOOL) transitionCompleted回到原来的位置
        */
        [dimmingView removeFromSuperview];
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    
}

- (void)animationEnded:(BOOL) transitionCompleted{
    if (!transitionCompleted) {
        self.toViewController.view.transform = CGAffineTransformIdentity;
    }
}
@end
