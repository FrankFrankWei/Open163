//
//  ArticleViewController.m
//  Open163
//
//  Created by Frank on 9/25/16.
//  Copyright © 2016 Frank. All rights reserved.
//

// 加载时候 屏幕中央的刷新动画设置
// 添加转场动画

#import "KRVideoPlayerController.h"
#import "VKVideoPlayerViewController.h"
#import "VideoViewController.h"
#import "WMPlayer.h"
@import WebKit;
@import AVKit;

@interface VideoViewController () <WKNavigationDelegate, WMPlayerDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WMPlayer *player;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *statusBarView;
@end

@implementation VideoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.statusBarView];
    [self.view addSubview:self.player];

    //    [self.view addSubview:self.webView];
    //    [self loadRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self playVideo:@""];
}
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
            initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 170)];
        _player.delegate = self;
    }

    return _player;
}

- (void)loadRequest
{
    NSURLRequest *req = [NSURLRequest
        requestWithURL:[NSURL URLWithString:@"http://mov.bn.netease.com/mobilev/2013/1/J/1/S8KVRSCJ1.mp4"]];
    [self.webView loadRequest:req];
}

- (void)playVideo:(NSString *)videoUrl
{
    //    self.player.URLString = @"http://mov.bn.netease.com/mobilev/2013/1/J/1/S8KVRSCJ1.mp4";
    self.player.URLString = @"http: //mov.bn.netease.com/movie/2013/1/J/1/S8KVRSCJ1-list.m3u";

    [self.player play];
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn
{
    //    NSLog(@"clickedCloseButton");
    [self releaseWMPlayer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoViewDidClickBackButton:)]) {
        [self.delegate videoViewDidClickBackButton:self];
    }
}

- (void)releaseWMPlayer
{
    //堵塞主线程
    //    [wmPlayer.player.currentItem cancelPendingSeeks];
    //    [wmPlayer.player.currentItem.asset cancelLoading];
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
#pragma mark - wkwebview navigation delegate

//- (void)webView:(WKWebView *)webView
// decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
// decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//}

@end
