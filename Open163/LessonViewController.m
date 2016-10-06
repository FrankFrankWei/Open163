//
//  BetweenClassViewController.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "LessonViewController.h"

@interface LessonViewController ()

@end

@implementation LessonViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"课间";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_lesson_24x24_@2x.png"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_lesson_HL_24x24_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
