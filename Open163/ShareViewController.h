//
//  ShareViewController.h
//  Open163
//
//  Created by Frank on 10/7/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@class ShareViewController;
@protocol ShareViewControllerDelegate <NSObject>

- (void)shareViewDidClickToDismiss:(ShareViewController *)viewController;

@end

@interface ShareViewController : UIViewController

@property (strong, nonatomic) Course *course;
@property (weak, nonatomic) id<ShareViewControllerDelegate> delegate;

@end
