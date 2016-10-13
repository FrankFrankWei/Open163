//
//  VideoAnimation.m
//  Open163
//
//  Desc: moving top and spread
//  Created by Frank on 9/26/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "VideoAnimation.h"

@interface VideoAnimation ()

@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UIImageView *maskPosterImageView;

@end

@implementation VideoAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPush) {
        [self pushAnimation:transitionContext];
    }
    else {
        [self popAnimation:transitionContext];
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat heightOffsetOfCellInScreen = self.originRectOfposterImageViewInScrollView.origin.y;
    toViewController.view.frame = CGRectMake(0, heightOffsetOfCellInScreen - 20, screenBounds.size.width, self.posterImageView.frame.size.height + 20);

    UIView *containerView = [transitionContext containerView];
    [toViewController.view addSubview:self.statusBarView];
    _maskPosterImageView = [[UIImageView alloc] initWithFrame:CGRectOffset(self.posterImageView.frame, 0, 20)];
    _maskPosterImageView.image = self.posterImageView.image;
    [toViewController.view addSubview:_maskPosterImageView];
    [containerView addSubview:toViewController.view];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [toViewController.view addSubview:self.statusBarView];
        fromViewController.view.alpha = 0.f;
        self.statusBarView.alpha = 1.0f;
        toViewController.view.frame = finalFrame;
    }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _maskPosterImageView.alpha = 0;
            }
                completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
        }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    // 1. Get controllers from transition context
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // 2. Set init frame for fromVC
    // set initial frame
    CGFloat heightOffsetOfCellInScreen = self.originRectOfposterImageViewInScrollView.origin.y;

    CGRect finalFrame = CGRectMake(0, heightOffsetOfCellInScreen - 20, screenBounds.size.width, self.posterImageView.frame.size.height + 20);

    [fromVC.view addSubview:_maskPosterImageView];
    _maskPosterImageView.hidden = NO;
    _maskPosterImageView.alpha = 1;

    // 3. Add target view to the container, and move it to back.
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];

    self.statusBarView.alpha = 0;
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.frame = finalFrame;
        toVC.view.alpha = 1.0;
    }
        completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
}

- (UIView *)statusBarView
{
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)]; // 20 is status bar's height
        _statusBarView.backgroundColor = [UIColor blackColor];
        _statusBarView.alpha = 0;
    }

    return _statusBarView;
}

@end
