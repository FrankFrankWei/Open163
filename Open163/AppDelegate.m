//
//  AppDelegate.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
#import "HomeViewController.h"
#import "LessonViewController.h"
#import "MeViewController.h"
#import "WXApi.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    [self launchMainView];
    [self.window makeKeyAndVisible];

    //network monitor
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
            label.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            label.alpha = 0.9;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"网络不给力,请稍后再试";
            [self.window addSubview:label];

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
    }];
    return YES;
}

- (void)launchMainView
{
    self.window.rootViewController = self.navController;
    /*
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navController.navigationBar setTintColor:[UIColor whiteColor]];
     */
    [self.navController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:15.0f] }];

    [self setNavigationBar];
}

- (UITabBarController *)tabBarController
{
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        HomeViewController *home = [[HomeViewController alloc] init];
        CategoryViewController *category = [[CategoryViewController alloc] init];
        LessonViewController *lesson = [[LessonViewController alloc] init];
        MeViewController *me = [[MeViewController alloc] init];

        _tabBarController.tabBar.backgroundImage =
            [UIImage imageNamed:@"picture_detail_bottom_375x35_@2x.png"];
        _tabBarController.tabBar.tintColor = [UIColor colorWithRed:60.0 / 255.0
                                                             green:136.0 / 255.0
                                                              blue:87.0 / 255.0
                                                             alpha:1];
        self.tabBarController.tabBar.translucent = NO;

        self.tabBarController.viewControllers = @[ home, category, lesson, me ];
    }

    return _tabBarController;
}

- (UINavigationController *)navController
{
    if (!_navController) {
        _navController = [[UINavigationController alloc]
            initWithRootViewController:self.tabBarController];
    }

    return _navController;
}

- (void)setNavigationBar
{
    [self.navController.navigationBar
        setBackgroundImage:[UIImage
                               imageNamed:@"top_navbarBg_iphone_375x65_@2x.png"]
            forBarPosition:UIBarPositionTopAttached
                barMetrics:UIBarMetricsDefault];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

@end
