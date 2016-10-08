//
//  ShareButton.m
//  Open163
//
//  Created by Frank on 10/8/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width / 2;
    center.y = self.imageView.frame.size.height / 2;
    self.imageView.center = center;

    CGRect frame = [self titleLabel].frame;
    frame.origin.x = 0;
    frame.origin.y = self.imageView.frame.size.height + 2;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
}
@end
