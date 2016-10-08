//
//  ShareView.m
//  Open163
//
//  Created by Frank on 10/7/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "ShareView.h"
@interface ShareView ()

@property (strong, nonatomic) UIView *linkView;
@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.linkView];
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    }

    return self;
}
#pragma mark - lazy init

- (UIView *)linkView
{
    if (!_linkView) {
        _linkView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 150, [UIScreen mainScreen].bounds.size.width, 150)];
        _linkView.backgroundColor = [UIColor blueColor];
        _linkView.alpha = 1;
    }

    return _linkView;
}
@end
