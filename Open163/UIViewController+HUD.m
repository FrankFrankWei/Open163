//
//  UIViewController+HUD.m
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>

static const void* progressViewKey = &progressViewKey;

@implementation UIViewController (HUD)

- (void)setProgressView:(MBProgressHUD*)progressView
{
    objc_setAssociatedObject(self, progressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD*)progressView
{
    return objc_getAssociatedObject(self, progressViewKey);
}

- (void)showProgressView
{
    if (!self.progressView) {
        self.progressView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        self.progressView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
        [self.view addSubview:self.progressView];
    }

    [self.progressView showAnimated:YES];
    self.view.userInteractionEnabled = NO;
}

- (void)hideProgressView
{
    [self.progressView hideAnimated:YES];
    self.view.userInteractionEnabled = YES;
}

@end
