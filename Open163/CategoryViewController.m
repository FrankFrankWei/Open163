//
//  CategoryViewController.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CategoryViewController.h"
#import "CoursesViewController.h"
#import "CourseCollectionCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "CollectionDataSource.h"
#import "HeaderView.h"
#import "ConfigResponse.h"

static NSString *const HotCollectionViewCellIdentifier = @"hotCell";
static NSString *const SpecialCollectionViewCellIdentifier = @"specialCell";
static NSString *const AllCollectionViewCellIdentifier = @"AllCell";

@interface CategoryViewController () <UICollectionViewDelegate>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) HeaderView *headerView;
@property (strong, nonatomic) UIView *hotContainerView;
@property (strong, nonatomic) UIImageView *hotLogoImageView;
@property (strong, nonatomic) UILabel *hotNameLabel;
@property (strong, nonatomic) UILabel *hotWatchAllLabel;
@property (strong, nonatomic) UICollectionView *hotCoursesCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *coursesFlowLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *specialFlowLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *allKindsFlowLayout;

@property (strong, nonatomic) UIView *specialContainerView;
@property (strong, nonatomic) UIImageView *specialLogoImageView;
@property (strong, nonatomic) UILabel *specialNameLabel;
@property (strong, nonatomic) UILabel *specialWatchAllLabel;
@property (strong, nonatomic) UICollectionView *specialCoursesCollectionView;
@property (strong, nonatomic) UICollectionView *wholeCourses;

@property (strong, nonatomic) NSMutableArray *hotCoursesArray;
@property (strong, nonatomic) NSMutableArray *specialCoursesArray;
@property (strong, nonatomic) ConfigResponse *configResponse;

@property (strong, nonatomic) CollectionDataSource *hotCollectionViewDataSource;
@property (strong, nonatomic) CollectionDataSource *specialCollectionViewDataSource;

@property (strong, nonatomic) UICollectionView *allKindsOfCoursesCollectionView;
@property (strong, nonatomic) CollectionDataSource *allKindsOfCoursesCollectionViewDataSource;
@property (strong, nonatomic) NSMutableArray *allCoursesArray;
@end

@implementation CategoryViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"分类";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_category_24x24_@2x.png"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_category_HL_24x24_@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.containerView];

    [self.containerView addSubview:self.hotContainerView];
    [self.containerView addSubview:self.hotLogoImageView];
    [self.containerView addSubview:self.hotNameLabel];
    [self.containerView addSubview:self.hotWatchAllLabel];
    [self.containerView addSubview:self.hotCoursesCollectionView];

    [self.containerView addSubview:self.specialContainerView];
    [self.specialContainerView addSubview:self.specialLogoImageView];
    [self.specialContainerView addSubview:self.specialNameLabel];
    [self.specialContainerView addSubview:self.specialWatchAllLabel];
    [self.specialContainerView addSubview:self.specialCoursesCollectionView];

    [self.containerView addSubview:self.allKindsOfCoursesCollectionView];

    [self setConstrains];
    [self getConfig];
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

#pragma mark - uiviewcollection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseItem *item = self.hotCoursesArray[indexPath.row];
    CoursesViewController *coursesVC = [[CoursesViewController alloc] init];
    coursesVC.courseId = [NSString stringWithFormat:@"%ld", item.identifier];
    coursesVC.courseType = item.name;
    [self.navigationController pushViewController:coursesVC animated:YES];
}

#pragma mark - private methods
- (void)getConfig
{
    static NSString *const url = @"http://c.open.163.com/mob/home/config.do";
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        weakSelf.configResponse = [ConfigResponse mj_objectWithKeyValues:responseObject];
        [weakSelf.hotCoursesArray addObjectsFromArray:_configResponse.data.classifyConfig.source];
        [weakSelf.specialCoursesArray addObjectsFromArray:_configResponse.data.classifyConfig.special];
        if (weakSelf.specialCoursesArray.count < 6) {
            CourseItem *supplementItem = [[CourseItem alloc] init];
            [weakSelf.specialCoursesArray addObject:supplementItem];
        }
        [weakSelf.allCoursesArray addObjectsFromArray:_configResponse.data.classifyConfig.base];
        [weakSelf.hotCoursesCollectionView reloadData];
        [weakSelf.specialCoursesCollectionView reloadData];
        [weakSelf.allKindsOfCoursesCollectionView reloadData];
        weakSelf.headerView.recommendedPlaceHolder = _configResponse.data.searchKeyword.value;
    }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
            // TODO: failed notify
        }];
}

#pragma mark - lazy initialize

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 65)];
        _containerView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
    }

    return _containerView;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50);
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        //        _mainScrollView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
    }

    return _mainScrollView;
}

- (HeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    }

    return _headerView;
}

- (UIView *)hotContainerView
{
    if (!_hotContainerView) {
        _hotContainerView = [[UIView alloc] init];
        _hotContainerView.backgroundColor = [UIColor whiteColor];
    }

    return _hotContainerView;
}

- (UIImageView *)hotLogoImageView
{
    if (!_hotLogoImageView) {
        _hotLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3, self.view.frame.size.width / 3)];
        _hotLogoImageView.image = [UIImage imageNamed:@"fenlei_hot_124x134_@2x.png"];
    }

    return _hotLogoImageView;
}

- (UILabel *)hotNameLabel
{
    if (!_hotNameLabel) {
        _hotNameLabel = [[UILabel alloc] init];
        _hotNameLabel.text = @"热门课程";
        _hotNameLabel.textColor = [UIColor whiteColor];
        _hotNameLabel.font = [UIFont systemFontOfSize:13];
        [_hotNameLabel sizeToFit];
    }

    return _hotNameLabel;
}

- (UILabel *)hotWatchAllLabel
{
    if (!_hotWatchAllLabel) {
        _hotWatchAllLabel = [[UILabel alloc] init];
        _hotWatchAllLabel.text = @"查看全部";
        _hotWatchAllLabel.textColor = [UIColor whiteColor];
        _hotWatchAllLabel.font = [UIFont systemFontOfSize:10];
        _hotWatchAllLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _hotWatchAllLabel.layer.borderWidth = 0.5;
        _hotWatchAllLabel.textAlignment = NSTextAlignmentCenter;
        [_hotWatchAllLabel sizeToFit];
    }

    return _hotWatchAllLabel;
}

- (CollectionDataSource *)hotCollectionViewDataSource
{
    if (!_hotCollectionViewDataSource) {
        _hotCollectionViewDataSource = [[CollectionDataSource alloc] init];
        CollectionViewCellConfigureBlock cellConfigBlock = ^(CourseCollectionCell *cell, CourseItem *item) {
            cell = (CourseCollectionCell *)cell;
            [cell configCell:item];
        };
        _hotCollectionViewDataSource.datas = self.hotCoursesArray;
        _hotCollectionViewDataSource.identifier = HotCollectionViewCellIdentifier;
        _hotCollectionViewDataSource.configureBlock = cellConfigBlock;
    }

    return _hotCollectionViewDataSource;
}

- (UICollectionView *)hotCoursesCollectionView
{
    if (!_hotCoursesCollectionView) {
        _hotCoursesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.coursesFlowLayout];
        _hotCoursesCollectionView.delegate = self;
        _hotCoursesCollectionView.dataSource = self.hotCollectionViewDataSource;
        _hotCoursesCollectionView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
        [_hotCoursesCollectionView registerClass:[CourseCollectionCell class] forCellWithReuseIdentifier:HotCollectionViewCellIdentifier];
    }

    return _hotCoursesCollectionView;
}

- (CollectionDataSource *)allKindsOfCoursesCollectionViewDataSource
{
    if (!_allKindsOfCoursesCollectionViewDataSource) {
        _allKindsOfCoursesCollectionViewDataSource = [[CollectionDataSource alloc] init];
        CollectionViewCellConfigureBlock cellConfigBlock = ^(CourseCollectionCell *cell, CourseItem *item) {
            cell = (CourseCollectionCell *)cell;
            [cell configCell:item];
        };
        _allKindsOfCoursesCollectionViewDataSource.datas = self.allCoursesArray;
        _allKindsOfCoursesCollectionViewDataSource.identifier = AllCollectionViewCellIdentifier;
        _allKindsOfCoursesCollectionViewDataSource.configureBlock = cellConfigBlock;
    }

    return _allKindsOfCoursesCollectionViewDataSource;
}

- (NSMutableArray *)allCoursesArray
{
    if (!_allCoursesArray) {
        _allCoursesArray = [[NSMutableArray alloc] init];
        CourseItem *defaultItem = [[CourseItem alloc] init];
        defaultItem.identifier = 0;
        defaultItem.name = @"我最爱看";
        [_allCoursesArray addObject:defaultItem];
    }

    return _allCoursesArray;
}

- (UICollectionView *)allKindsOfCoursesCollectionView
{
    if (!_allKindsOfCoursesCollectionView) {
        _allKindsOfCoursesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.allKindsFlowLayout];
        _allKindsOfCoursesCollectionView.dataSource = self.allKindsOfCoursesCollectionViewDataSource;
        _allKindsOfCoursesCollectionView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
        [_allKindsOfCoursesCollectionView registerClass:[CourseCollectionCell class] forCellWithReuseIdentifier:AllCollectionViewCellIdentifier];
    }

    return _allKindsOfCoursesCollectionView;
}

- (NSMutableArray *)hotCoursesArray
{
    if (!_hotCoursesArray) {
        _hotCoursesArray = [NSMutableArray array];
    }

    return _hotCoursesArray;
}

- (NSMutableArray *)specialCoursesArray
{
    if (!_specialCoursesArray) {
        _specialCoursesArray = [[NSMutableArray alloc] init];
    }

    return _specialCoursesArray;
}
- (ConfigResponse *)configResponse
{
    if (!_configResponse) {
        _configResponse = [[ConfigResponse alloc] init];
    }

    return _configResponse;
}

- (UICollectionViewFlowLayout *)specialFlowLayout
{
    if (!_specialFlowLayout) {
        _specialFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _specialFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3 - 1, self.view.frame.size.width / 9 - 0.5);
        _specialFlowLayout.minimumLineSpacing = 1;
        _specialFlowLayout.minimumInteritemSpacing = 0.5;
    }

    return _specialFlowLayout;
}

- (UICollectionViewFlowLayout *)allKindsFlowLayout
{
    if (!_allKindsFlowLayout) {
        _allKindsFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _allKindsFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3 - 1, self.view.frame.size.width / 9 - 0.5);
        _allKindsFlowLayout.minimumLineSpacing = 1;
        _allKindsFlowLayout.minimumInteritemSpacing = 0.5;
    }

    return _allKindsFlowLayout;
}
- (UICollectionViewFlowLayout *)coursesFlowLayout
{
    if (!_coursesFlowLayout) {
        _coursesFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _coursesFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3 - 1, self.view.frame.size.width / 9 - 0.5);
        _coursesFlowLayout.minimumLineSpacing = 1;
        _coursesFlowLayout.minimumInteritemSpacing = 0.5;
    }

    return _coursesFlowLayout;
}

- (UIView *)specialContainerView
{
    if (!_specialContainerView) {
        _specialContainerView = [[UIView alloc] init];
        _specialContainerView.backgroundColor = [UIColor whiteColor];
    }

    return _specialContainerView;
}

- (UIImageView *)specialLogoImageView
{
    if (!_specialLogoImageView) {
        _specialLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3, self.view.frame.size.width / 3)];
        _specialLogoImageView.image = [UIImage imageNamed:@"fenlei_gkkch_125x135_@2x.png"];
    }

    return _specialLogoImageView;
}

- (UILabel *)specialNameLabel
{
    if (!_specialNameLabel) {
        _specialNameLabel = [[UILabel alloc] init];
        _specialNameLabel.text = @"公开课策划";
        _specialNameLabel.textColor = [UIColor whiteColor];
        _specialNameLabel.font = [UIFont systemFontOfSize:13];
        [_specialNameLabel sizeToFit];
    }

    return _specialNameLabel;
}

- (UILabel *)specialWatchAllLabel
{
    if (!_specialWatchAllLabel) {
        _specialWatchAllLabel = [[UILabel alloc] init];
        _specialWatchAllLabel.text = @"查看全部";
        _specialWatchAllLabel.textColor = [UIColor whiteColor];
        _specialWatchAllLabel.font = [UIFont systemFontOfSize:10];
        _specialWatchAllLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _specialWatchAllLabel.layer.borderWidth = 0.5;
        _specialWatchAllLabel.textAlignment = NSTextAlignmentCenter;
        [_specialWatchAllLabel sizeToFit];
    }

    return _specialWatchAllLabel;
}

- (CollectionDataSource *)specialCollectionViewDataSource
{
    if (!_specialCollectionViewDataSource) {
        _specialCollectionViewDataSource = [[CollectionDataSource alloc] init];
        CollectionViewCellConfigureBlock cellConfigBlock = ^(CourseCollectionCell *cell, CourseItem *item) {
            cell = (CourseCollectionCell *)cell;
            [cell configCell:item];
        };

        _specialCollectionViewDataSource.datas = self.specialCoursesArray;
        _specialCollectionViewDataSource.identifier = SpecialCollectionViewCellIdentifier;
        _specialCollectionViewDataSource.configureBlock = cellConfigBlock;
    }

    return _specialCollectionViewDataSource;
}

- (UICollectionView *)specialCoursesCollectionView
{
    if (!_specialCoursesCollectionView) {
        _specialCoursesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.specialFlowLayout];
        _specialCoursesCollectionView.delegate = self;
        _specialCoursesCollectionView.dataSource = self.specialCollectionViewDataSource;
        _specialCoursesCollectionView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
        [_specialCoursesCollectionView registerClass:[CourseCollectionCell class] forCellWithReuseIdentifier:SpecialCollectionViewCellIdentifier];
    }

    return _specialCoursesCollectionView;
}

#pragma mark - set constrains
- (void)setConstrains
{
    [_hotContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top);
        make.left.equalTo(_containerView.mas_left);
        make.width.equalTo(_containerView.mas_width);
        make.height.equalTo(@(self.view.frame.size.width / 3));
    }];

    [_hotLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top);
        make.left.equalTo(_containerView.mas_left);
        make.width.equalTo(_hotContainerView.mas_height);
        make.height.equalTo(_hotContainerView.mas_height);
    }];

    [_hotNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hotLogoImageView.mas_top).offset(28);
        make.centerX.equalTo(_hotLogoImageView.mas_centerX);
        make.height.equalTo(@14);
    }];

    [_hotWatchAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(60);
        make.centerX.equalTo(_hotLogoImageView.mas_centerX);
        make.width.equalTo(@(_hotNameLabel.frame.size.width + 13));
        make.height.equalTo(@14);
    }];

    [_hotCoursesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.view.frame.size.width * 2 / 3));
        make.height.equalTo(_hotContainerView.mas_height);
        make.top.equalTo(_hotContainerView.mas_top);
        make.left.equalTo(_hotLogoImageView.mas_right);
    }];

    [_specialContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hotContainerView.mas_bottom).offset(10);
        make.left.equalTo(_hotContainerView.mas_left);
        make.width.equalTo(_hotContainerView.mas_width);
        make.height.equalTo(@(self.view.frame.size.width / 3));
    }];

    [_specialLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_specialContainerView.mas_top);
        make.left.equalTo(_specialContainerView.mas_left);
        make.width.equalTo(_hotLogoImageView.mas_width);
        make.height.equalTo(_hotLogoImageView.mas_height);
    }];

    [_specialNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_specialLogoImageView.mas_top).offset(28);
        make.centerX.equalTo(_specialLogoImageView.mas_centerX);
        make.height.equalTo(@14);
    }];

    [_specialWatchAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_specialLogoImageView.mas_top).offset(60);
        make.centerX.equalTo(_specialLogoImageView.mas_centerX);
        make.width.equalTo(@(_specialNameLabel.frame.size.width));
        make.height.equalTo(@14);
    }];

    [_specialCoursesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.view.frame.size.width * 2 / 3));
        make.height.equalTo(_specialContainerView.mas_height);
        make.top.equalTo(_specialContainerView.mas_top);
        make.left.equalTo(_specialLogoImageView.mas_right);
    }];

    [_allKindsOfCoursesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.view.frame.size.width));
        make.height.equalTo(@(self.view.frame.size.height - 273));
        make.top.equalTo(_specialContainerView.mas_bottom).offset(10);
        make.left.equalTo(_specialContainerView.mas_left);
    }];
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
