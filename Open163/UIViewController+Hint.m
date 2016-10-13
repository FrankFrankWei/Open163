//
//  UIViewController+Hint.m
//  Open163
//
//  Created by Frank on 10/13/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "UIViewController+Hint.h"

@implementation UIViewController (Hint)

- (void)showHintWithMessage:(NSString *)message
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    label.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.alpha = 0.9;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    [self.view addSubview:label];

    //设置动画
    CATransition *transion = [CATransition animation];
    transion.type = kCATransitionFade; //设置动画方式
    transion.subtype = kCATransitionFromTop; //设置动画从那个方向开始
    [label.layer addAnimation:transion forKey:nil]; //给Label.layer 添加动画
    //设置延时效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    }); //这句话的意思是1.5秒后，把label移出视图
}

@end
