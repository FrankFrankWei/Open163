//
//  VideoAnimation.h
//  Open163
//
//  Created by Frank on 9/26/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@property (strong, nonatomic) UIImageView *posterImageView;
@property (nonatomic) CGRect originRectOfposterImageViewInScrollView;
@property (nonatomic) BOOL isPush;

@end
