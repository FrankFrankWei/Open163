//
//  ShareViewController.m
//  Open163
//
//  Created by Frank on 10/7/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "ShareViewController.h"
#import "UIButton+ImageUpTitleDown.h"
#import "Masonry.h"

@interface ShareViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) UIView *linkView;
@property (strong, nonatomic) UIButton *weiXinFriendBtn;
@property (strong, nonatomic) UIButton *weiXinFriendCirCleBtn;
//@property (strong, nonatomic) ShareButton *weiXinFriendCirCleBtn;
@property (strong, nonatomic) UIButton *weiBoBtn;
@property (strong, nonatomic) UIButton *qqFriendBtn;
@property (strong, nonatomic) UIButton *yiXinFriendCircleBtn;
@property (strong, nonatomic) UIButton *yiXinFriendBtn;
@end

@implementation ShareViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.linkView];
        [self.linkView addSubview:self.weiXinFriendBtn];
        [self.linkView addSubview:self.weiXinFriendCirCleBtn];
        [self.linkView addSubview:self.weiBoBtn];
        [self.linkView addSubview:self.qqFriendBtn];
        [self.linkView addSubview:self.yiXinFriendCircleBtn];
        [self.linkView addSubview:self.yiXinFriendBtn];

        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss:)];
        [self.view addGestureRecognizer:tapGesture];
    }

    [self setConstraints];
    return self;
}

- (void)viewDidLoad
{
}

#pragma mark - add gesture

- (void)tapToDismiss:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint tapLocation = [recognizer locationInView:nil];

        if (![_linkView pointInside:[_linkView convertPoint:tapLocation fromView:_linkView.window] withEvent:nil]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewDidClickToDismiss:)]) {
                [self.delegate shareViewDidClickToDismiss:self];
            }
        }
    }
}

#pragma mark - button actions
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)shareButtonClick:(id)sender
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"“网易公开课”想要开打“qq”" delegate:self cancelButtonTitle:@"打开" otherButtonTitles:@"取消", nil];

        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click index %ld", (long)buttonIndex);
}
#pragma mark - constraints

- (void)setConstraints
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    [_weiXinFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_linkView.mas_centerX);
        make.top.equalTo(_linkView.mas_top).offset(20);
    }];

    [_weiXinFriendCirCleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_linkView.mas_centerX).offset(-(screenSize.width / 4.0 + 10));
        make.top.equalTo(_linkView.mas_top).offset(20);
    }];

    [_weiBoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_linkView.mas_centerX).offset(screenSize.width / 4.0 + 10);
        make.top.equalTo(_linkView.mas_top).offset(20);
    }];

    [_yiXinFriendCircleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_linkView.mas_centerX);
        make.bottom.equalTo(_linkView.mas_bottom).offset(-40);
    }];

    [_qqFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_linkView.mas_centerX).offset(-(screenSize.width / 4.0 + 10));
        make.bottom.equalTo(_linkView.mas_bottom).offset(-40);
    }];

    [_yiXinFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_linkView.mas_centerX).offset(screenSize.width / 4.0 + 10);
        make.bottom.equalTo(_linkView.mas_bottom).offset(-40);
    }];
}
#pragma mark - lazy init

- (UIView *)linkView
{
    if (!_linkView) {
        _linkView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 210, [UIScreen mainScreen].bounds.size.width, 210)];
        _linkView.backgroundColor = [UIColor whiteColor];
        _linkView.alpha = 1;
    }

    return _linkView;
}

- (UIButton *)weiXinFriendCirCleBtn
{
    if (!_weiXinFriendCirCleBtn) {
        _weiXinFriendCirCleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _weiXinFriendCirCleBtn.frame = CGRectMake(0, 0, 60, 66);
        _weiXinFriendCirCleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_weiXinFriendCirCleBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        _weiXinFriendCirCleBtn.tintColor = [UIColor lightGrayColor];
        [_weiXinFriendCirCleBtn setImage:[[UIImage imageNamed:@"player_share_wxmoments_55x55_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [_weiXinFriendCirCleBtn upImageAndDownTitle];

        [_weiXinFriendCirCleBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _weiXinFriendCirCleBtn;
}

- (UIButton *)weiXinFriendBtn
{
    if (!_weiXinFriendBtn) {
        _weiXinFriendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _weiXinFriendBtn.frame = CGRectMake(0, 0, 60, 66);
        _weiXinFriendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_weiXinFriendBtn setTitle:@"微信好友" forState:UIControlStateNormal];
        _weiXinFriendBtn.tintColor = [UIColor lightGrayColor];
        [_weiXinFriendBtn setImage:[[UIImage imageNamed:@"player_share_wxfriend_55x55_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [_weiXinFriendBtn upImageAndDownTitle];
    }

    return _weiXinFriendBtn;
}

- (UIButton *)weiBoBtn
{
    if (!_weiBoBtn) {
        _weiBoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _weiBoBtn.frame = CGRectMake(0, 0, 60, 66);
        _weiBoBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_weiBoBtn setTitle:@"微博" forState:UIControlStateNormal];
        _weiBoBtn.tintColor = [UIColor lightGrayColor];
        [_weiBoBtn setImage:[[UIImage imageNamed:@"player_share_weibo_55x55_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [_weiBoBtn upImageAndDownTitle];
    }

    return _weiBoBtn;
}

- (UIButton *)qqFriendBtn
{
    if (!_qqFriendBtn) {
        _qqFriendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _qqFriendBtn.frame = CGRectMake(0, 0, 60, 66);
        _qqFriendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_qqFriendBtn setTitle:@"qq好友" forState:UIControlStateNormal];
        _qqFriendBtn.tintColor = [UIColor lightGrayColor];
        [_qqFriendBtn setImage:[[UIImage imageNamed:@"player_share_qq_55x55_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [_qqFriendBtn upImageAndDownTitle];
    }

    return _qqFriendBtn;
}

- (UIButton *)yiXinFriendCircleBtn
{
    if (!_yiXinFriendCircleBtn) {
        _yiXinFriendCircleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _yiXinFriendCircleBtn.frame = CGRectMake(0, 0, 60, 66);
        _yiXinFriendCircleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_yiXinFriendCircleBtn setTitle:@"易信朋友圈" forState:UIControlStateNormal];
        _yiXinFriendCircleBtn.tintColor = [UIColor lightGrayColor];
        [_yiXinFriendCircleBtn setImage:[[UIImage imageNamed:@"player_share_yxfriend_55x55_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [_yiXinFriendCircleBtn upImageAndDownTitle];
    }

    return _yiXinFriendCircleBtn;
}

- (UIButton *)yiXinFriendBtn
{
    if (!_yiXinFriendBtn) {
        _yiXinFriendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _yiXinFriendBtn.frame = CGRectMake(0, 0, 60, 66);
        _yiXinFriendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_yiXinFriendBtn setTitle:@"易信好友" forState:UIControlStateNormal];
        _yiXinFriendBtn.tintColor = [UIColor lightGrayColor];
        [_yiXinFriendBtn setImage:[[UIImage imageNamed:@"player_share_yxmoments_55x55_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [_yiXinFriendBtn upImageAndDownTitle];
    }

    return _yiXinFriendBtn;
}
@end
