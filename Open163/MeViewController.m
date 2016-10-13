//
//  MeViewController.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation MeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_me_24x24_"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_me_HL_24x24_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        //        _mainScrollView.backgroundColor = [UIColor blueColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 200)];
        view.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:view];
    }

    return _mainScrollView;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
