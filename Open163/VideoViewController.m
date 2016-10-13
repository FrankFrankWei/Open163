//
//  ArticleViewController.m
//  Open163
//
//  Created by Frank on 9/25/16.
//  Copyright © 2016 Frank. All rights reserved.
//

// 加载时候 屏幕中央的刷新动画设置
// 添加转场动画

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight 49

#import "KRVideoPlayerController.h"
#import "UIViewController+Hint.h"
#import "VKVideoPlayerViewController.h"
#import "VideoViewController.h"
#import "WMPlayer.h"
#import "AFNetworking.h"
@import WebKit;
@import AVKit;

@interface VideoViewController () <WKNavigationDelegate, WMPlayerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WMPlayer *player;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *statusBarView;
@property (assign, nonatomic) BOOL isSmallScreen;
@property (assign, nonatomic) CGRect playerFrame;

@end

@implementation VideoViewController

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

/*
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationStateChange:) name:@"UIApplicationWillResignActiveNotification" object:nil];
}

- (void)applicationStateChange:(NSNotification *)notification
{
    //    NSLog(@"%@", notification.name);
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    _playerFrame = CGRectMake(0, 20, kScreenWidth, (kScreenWidth) * (0.75));
    [self.view addSubview:self.statusBarView];
    [self.view addSubview:self.player];

    //    [self.view addSubview:self.webView];
    //    [self loadRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self playVideo:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.player pause];
}

/*
- (void)loadRequest
{
    NSURLRequest *req = [NSURLRequest
        requestWithURL:[NSURL URLWithString:@"http://mov.bn.netease.com/mobilev/2013/1/J/1/S8KVRSCJ1.mp4"]];
    [self.webView loadRequest:req];
}
 */

- (void)playVideo:(NSString *)videoUrl
{
    [self doPlay:@""];
    /*
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self showHintWithMessage:@"无网络连接"];
            NSLog(@"no");
        }
        else if (status != AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"haha");

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前非wifi网络，确定继续观看？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertView show];
        }
        else {
            [self doPlay:@""];
            NSLog(@"play");
        }
        NSLog(@"play11");
    }];
     */
}

- (void)doPlay:(NSString *)videoUrl
{
    self.player.URLString
        = @"http://mov.bn.netease.com/mobilev/2013/1/J/1/S8KVRSCJ1.mp4";
    self.player.titleLabel.text = @"斯坦福大学公开课";
    [self.player play];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [self doPlay:@""];
    }
}

#pragma mark - wmplayer delegate

- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn
{
    //    NSLog(@"clickedCloseButton");
    [self releaseWMPlayer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoViewDidClickBackButton:)]) {
        [self.delegate videoViewDidClickBackButton:self];
    }
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn
{
    if (fullScreenBtn.isSelected) { //全屏显示
        self.player.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    else {
        [self toNormal];
    }
}

- (void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state
{
    [self showHintWithMessage:@"网络不给力，播放失败"];
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange
{
    if (self.player == nil || self.player.superview == nil) {
        return;
    }

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
    case UIInterfaceOrientationPortraitUpsideDown: {
        //        NSLog(@"第3个旋转方向---电池栏在下");
    } break;
    case UIInterfaceOrientationPortrait: {
        //        NSLog(@"第0个旋转方向---电池栏在上");
        if (self.player.isFullscreen) {
            [self toNormal];
        }
    } break;
    case UIInterfaceOrientationLandscapeLeft: {
        NSLog(@"第2个旋转方向---电池栏在左");
        self.player.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
    } break;
    case UIInterfaceOrientationLandscapeRight: {
        NSLog(@"第1个旋转方向---电池栏在右");
        self.player.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
    } break;
    default:
        break;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma wmplayer helper

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.player removeFromSuperview];
    self.player.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.player.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.player.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    NSLog(@"%f %f", kScreenWidth, kScreenHeight);
    self.player.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.player.playerLayer.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);

    [self.player.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth - 40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.player).with.offset(0);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.player.topView).with.offset(5);
        make.width.mas_equalTo(30);
    }];
    [self.player.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.player.topView).with.offset(45);
        make.right.equalTo(self.player.topView).with.offset(-45);
        make.center.equalTo(self.player.topView);
        make.top.equalTo(self.player.topView).with.offset(0);

    }];
    [self.player.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth / 2 - 36, -(kScreenWidth / 2) + 36));
        make.height.equalTo(@30);
    }];
    [self.player.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth / 2 - 37, -(kScreenWidth / 2 - 37)));
    }];
    [self.view addSubview:self.player];
    self.player.fullScreenBtn.selected = YES;
    [self.player bringSubviewToFront:self.player.bottomView];
}

- (void)toNormal
{
    [self.player removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        self.player.transform = CGAffineTransformIdentity;
        self.player.frame = CGRectMake(_playerFrame.origin.x, _playerFrame.origin.y, _playerFrame.size.width, _playerFrame.size.height);
        self.player.playerLayer.frame = self.player.bounds;
        [self.view addSubview:self.player];
        [self.player.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(0);
            make.right.equalTo(self.player).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.player).with.offset(0);
        }];

        [self.player.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).with.offset(0);
            make.right.equalTo(self.player).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.player).with.offset(0);
        }];

        [self.player.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player.topView).with.offset(5);
            make.height.mas_equalTo(30);
            make.top.equalTo(self.player.topView).with.offset(5);
            make.width.mas_equalTo(30);
        }];

        [self.player.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player.topView).with.offset(45);
            make.right.equalTo(self.player.topView).with.offset(-45);
            make.center.equalTo(self.player.topView);
            make.top.equalTo(self.player.topView).with.offset(0);
        }];

        [self.player.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.player);
            make.width.equalTo(self.player);
            make.height.equalTo(@30);
        }];

    }
        completion:^(BOOL finished) {
            self.player.isFullscreen = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            self.player.fullScreenBtn.selected = NO;

        }];
}

- (void)releaseWMPlayer
{
    //堵塞主线程
    //    [self.player.player.currentItem cancelPendingSeeks];
    //    [self.player.player.currentItem.asset cancelLoading];
    [self.player pause];
    [self.player removeFromSuperview];
    [self.player.playerLayer removeFromSuperlayer];
    [self.player.player replaceCurrentItemWithPlayerItem:nil];
    self.player.player = nil;
    self.player.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.player.autoDismissTimer invalidate];
    self.player.autoDismissTimer = nil;

    self.player.playOrPauseBtn = nil;
    self.player.playerLayer = nil;
    self.player = nil;
}

- (void)dealloc
{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"VideoViewController dealloc");
}

#pragma mark - lazy init

- (UIView *)statusBarView
{
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc]
            initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        //        _statusBarView.backgroundColor = [UIColor blackColor];
        _statusBarView.backgroundColor = [UIColor whiteColor];
    }

    return _statusBarView;
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc]
            initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 170)];
        //        _webView.navigationDelegate = self;
    }

    return _webView;
}

- (WMPlayer *)player
{
    if (!_player) {
        _player = [[WMPlayer alloc]
            initWithFrame:_playerFrame];
        _player.delegate = self;
    }

    return _player;
}

#pragma mark - wkwebview navigation delegate

//- (void)webView:(WKWebView *)webView
// decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
// decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//}

@end
