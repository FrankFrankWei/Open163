//
//  UIViewController+HUD.h
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

@property (strong, nonatomic) MBProgressHUD* progressView;

- (void)showProgressView;
- (void)hideProgressView;

@end
