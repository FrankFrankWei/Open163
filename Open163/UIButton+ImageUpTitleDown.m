//
//  UIButton+ImageUpTitleDown.m
//  Open163
//
//  Created by Frank on 10/8/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "UIButton+ImageUpTitleDown.h"

@implementation UIButton (ImageUpTitleDown)

- (void)upImageAndDownTitle
{
    CGFloat offset = 20.0f;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height - offset / 20 - 20, 0);

    //        _weiXinFrendBtn.titleEdgeInsets = UIEdgeInsetsMake(-_weiXinFrendBtn.imageView.frame.size.height - offset / 2 - 20 - _weiXinFrendBtn.titleLabel.frame.size.height, -_weiXinFrendBtn.imageView.frame.size.width, 0, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.intrinsicContentSize.width);
    //    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - offset / 2, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}

@end
