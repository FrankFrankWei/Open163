//
//  HomeViewController.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "ArrayDataSource.h"
#import "Course.h"
#import "CourseCell.h"
#import "CourseResponse.h"
#import "CustomEnums.h"
#import "HeaderView.h"
#import "HeaderView.h"
#import "HomeViewController.h"
#import "LoadingFooter.h"
#import "LoadingHeader.h"
#import "MJExtension.h"
#import "UIViewController+HUD.h"
#import "VideoAnimation.h"
#import "VideoViewController.h"
#import "NormalDismissAnimation.h"

static NSString *const CourseCellIdentifer = @"CourseCell";
//static NSString* const CoursesUrl = @"http://c.open.163.com/mob/home/homelist.do?cursor=&rtypes=2%2C3%2C8%2C9";

@interface HomeViewController () <UITableViewDelegate, UISearchBarDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, VideoViewControllerDelegate>
@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ArrayDataSource *courseDataSource;
@property (strong, nonatomic) CourseResponse *courseResponse;
@property (strong, nonatomic) NSMutableArray *courseArrayCache;
@property (strong, nonatomic) NSString *originUrlForCourses;
@property (strong, nonatomic) VideoAnimation *videoAnimation;
@property (strong, nonatomic) NormalDismissAnimation *dismissAnimation;
@end

@implementation HomeViewController
//@synthesize courseArrayCache = _courseArrayCache;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"主页";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_home_24x24_@2x.png"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_HL_24x24_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.header];
    [self.view addSubview:self.tableView];
    [self configMJRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //    [self.navigationController setNavigationBarHidden:NO];

    /*
    [UIView animateWithDuration:0.5 animations:^{
        [self.header setCenter:CGPointMake(0, self.header.frame.size.height)];
    }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mjrefresh config
- (void)configMJRefresh
{
    LoadingHeader *loadingHeader = [LoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    LoadingFooter *loadingFooter = [LoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

    _tableView.mj_header = loadingHeader;
    _tableView.mj_footer = loadingFooter;
}

#pragma mark - lazy initialize

- (NormalDismissAnimation *)dismissAnimation
{
    if (!_dismissAnimation) {
        _dismissAnimation = [NormalDismissAnimation new];
    }

    return _dismissAnimation;
}
- (VideoAnimation *)videoAnimation
{
    if (!_videoAnimation) {
        _videoAnimation = [[VideoAnimation alloc] init];
    }

    return _videoAnimation;
}

- (UIView *)header
{
    if (!_header) {
        _header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    }

    return _header;
}

- (CourseResponse *)courseResponse
{
    if (!_courseResponse) {
        _courseResponse = [[CourseResponse alloc] init];
    }

    return _courseResponse;
}

/*
- (void)setCourseArrayCache:(NSMutableArray *)courseArrayCache{
    _courseArrayCache = courseArrayCache;
    self.courseDataSource.courses = _courseArrayCache;
}
 */

- (NSMutableArray *)courseArrayCache
{
    if (!_courseArrayCache) {
        _courseArrayCache = [[NSMutableArray alloc] init];
    }

    return _courseArrayCache;
}

- (ArrayDataSource *)courseDataSource
{
    if (!_courseDataSource) {
        _courseDataSource = [[ArrayDataSource alloc] init];
        _courseDataSource.courses = self.courseArrayCache;
        _courseDataSource.cellIdentifier = CourseCellIdentifer;
        _courseDataSource.cellClass = [CourseCell class];

        TableViewCellConfigureBlock configureBlock = ^(CourseCell *cell, Course *course) {
            [cell configureForCourse:course];
        };

        _courseDataSource.configureCellBlock = configureBlock;
    }

    return _courseDataSource;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 112)];
        _tableView.dataSource = self.courseDataSource;
        //        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 350;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _tableView;
}

#pragma mark - private

- (void)loadMore
{
    [self getTableDataWithUrl:[NSString stringWithFormat:self.originUrlForCourses, self.courseResponse.cursor] type:Refresh];
}

- (void)refresh
{
    [self.courseArrayCache removeAllObjects];
    [self getTableDataWithUrl:[NSString stringWithFormat:self.originUrlForCourses, @""] type:Refresh];
}

- (void)getTableDataWithUrl:(NSString *)url type:(RefreshType)refreshType
{
    //    [self showProgressView];
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    /*
    [httpManager GET:url parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
        self.progressView.progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
     */
    [httpManager GET:url parameters:nil progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            weakSelf.courseResponse = [CourseResponse mj_objectWithKeyValues:responseObject];
            [weakSelf.courseArrayCache addObjectsFromArray:weakSelf.courseResponse.courses];
            weakSelf.courseDataSource.courses = weakSelf.courseArrayCache;
            [weakSelf.tableView reloadData];
            //            [weakSelf hideProgressView];

            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            /*
            weakSelf.progressView.label.text = @"获取数据异常";
            [NSThread sleepForTimeInterval:1.0];
            [weakSelf.progressView hideAnimated:YES afterDelay:1.0];
             */
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
}

- (NSString *)originUrlForCourses
{
    if (!_originUrlForCourses) {
        //        _originUrlForCourses = @"http://c.open.163.com/mob/home/homelist.do?cursor=%@&rtypes=2,3,4,5,8,9,10,11,12";
        _originUrlForCourses = @"http://c.open.163.com/mob/home/homelist.do?cursor=%@&rtypes=2";
    }

    return _originUrlForCourses;
}

#pragma mark - searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    self.header.searchBar.showsCancelButton = YES;
    //TODO: jump to search view controller
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //TODO: back to home
}

- (void)videoViewDidClickBackButton:(VideoViewController *)viewController
{
    self.videoAnimation.isPush = NO;
    [self dismissViewControllerAnimated:viewController completion:nil];
}
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.transitioningDelegate = self;
    //    self.navigationController.delegate = self;
    Course *course = self.courseArrayCache[indexPath.row];
    // TODO: 分析这里卡顿的原因, 下级菜单返回时 搜索栏的动画效果
    if (2 == course.rtype) { // is video
        VideoViewController *videoViewController = [[VideoViewController alloc] init];
        videoViewController.transitioningDelegate = self;
        videoViewController.delegate = self;
        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectInScrollView = [tableView convertRect:rectInTableView toView:[tableView superview]];
        self.videoAnimation.originRectOfposterImageViewInScrollView = rectInScrollView;

        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        self.videoAnimation.posterImageView = ((CourseCell *)selectedCell).posterImageView;
        self.videoAnimation.isPush = YES;
        [NSThread sleepForTimeInterval:0.2];
        [self presentViewController:videoViewController animated:YES completion:nil];
        //        [self.navigationController pushViewController:videoViewController animated:YES];
    }
}

#pragma mark - cell delegate
- (void)didShareButtonClick:(Course *)course
{
    NSLog(@"%@", course.title);
}

#pragma mark - uitransitioning delegate
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    return self.videoAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    //    return self.dismissAnimation;
    return self.videoAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        self.videoAnimation.isPush = YES;
    }
    else
        self.videoAnimation.isPush = NO;
    return self.videoAnimation;
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseArrayCache.count;
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 这个方法会调用cell的initWithStyle:reuseIdentifier:方法，所以在cell的此方法中进行自定义
    CourseCell* cell = [tableView dequeueReusableCellWithIdentifier:CourseCellIdentifer];
    if (!cell) {
        cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CourseCellIdentifer];
    }
    Course* item = self.courseArrayCache[indexPath.row];
    [cell configureForCourse:item];

    return cell;
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
