//
//  ArticleViewController.h
//  Open163
//
//  Created by Frank on 9/25/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoViewController;
@protocol VideoViewControllerDelegate <NSObject>

- (void)videoViewDidClickBackButton:(VideoViewController *)viewController;

@end
@interface VideoViewController : UIViewController
@property (weak, nonatomic) id<VideoViewControllerDelegate> delegate;
@end
