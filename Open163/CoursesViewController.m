//
//  CoursesViewController.m
//  Open163
//
//  Created by Frank on 9/30/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CoursesViewController.h"
#import "UIViewController+Hint.h"
#import "CourseTableViewCell.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "ConfigResponse.h"
#import "MJExtension.h"
#import "SourceCollectionViewCell.h"
#import "CourseResponseForCategory.h"
#import "CourseItemForCategory.h"
#import "CustomEnums.h"
#import "MJRefresh.h"
#import "LoadingHeader.h"
#import "LoadingFooter.h"

static NSString *const TableViewCellIdentifier = @"tableViewCellIdentifier";
static NSString *const SourceCollectionViewCellIdentifier = @"SourceCollectionViewCellIdentifier";

@interface CoursesViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *courseSource;
@property (strong, nonatomic) UIView *menu;
@property (strong, nonatomic) UIButton *latestButton;
@property (strong, nonatomic) UIButton *hottestButton;
@property (strong, nonatomic) UIButton *filterButton;
@property (strong, nonatomic) UIView *tableViewContainer;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) ConfigResponse *configResponse;
@property (strong, nonatomic) NSMutableArray *hotCoursesArray;
@property (strong, nonatomic) NSMutableArray *specialCoursesArray;
@property (strong, nonatomic) NSMutableArray *allCoursesArray;

@property (strong, nonatomic) UIView *sourceContainerView;
@property (strong, nonatomic) UILabel *sourceTitleLabel;
@property (strong, nonatomic) UICollectionView *sourceCollectionView;
@property BOOL isLatestButtonSelected;
@property BOOL isFilterButtonSelected;

@property (strong, nonatomic) NSMutableArray *tableDataCache;
@property (strong, nonatomic) NSString *originUrlForCourses;
@property (strong, nonatomic) CourseResponseForCategory *courseResponseForCategory;
@property (assign, nonatomic) NSInteger currentCourseFlag;

@end

@implementation CoursesViewController

#pragma mark - networking

- (void)getConfig
{
    static NSString *const url = @"http://c.open.163.com/mob/home/config.do";
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        weakSelf.configResponse = [ConfigResponse mj_objectWithKeyValues:responseObject];
        [weakSelf.hotCoursesArray addObjectsFromArray:_configResponse.data.classifyConfig.source];
        [weakSelf.allCoursesArray addObjectsFromArray:_configResponse.data.classifyConfig.base];
        [weakSelf.sourceCollectionView reloadData];
    }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
            // TODO: failed notify
        }];
}

//- (void)getTableDataWithUrl:(NSString *)url
//- (void)getTableDataWithType:(RefreshType)refreshType
- (void)getTableData
{
    self.courseResponseForCategory.cursor = self.courseResponseForCategory.cursor == nil ? @"" : self.courseResponseForCategory.cursor;
    NSString *url = [NSString stringWithFormat:self.originUrlForCourses, self.courseResponseForCategory.cursor, self.currentCourseFlag, self.courseId];
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        weakSelf.courseResponseForCategory = [CourseResponseForCategory mj_objectWithKeyValues:responseObject];
        [weakSelf.tableDataCache addObjectsFromArray:weakSelf.courseResponseForCategory.data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            // TODO:
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf showHintWithMessage:@"网络不给力，请稍后再试"];
        }];
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.courseType;
    self.currentCourseFlag = 1; // 1 - 最新； 2 - 最热
    [self setNavigationBar];
    [self buttonsStateInit];
    self.view.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
    [self.view addSubview:self.menu];
    [self.menu addSubview:self.latestButton];
    [self.menu addSubview:self.hottestButton];
    [self.menu addSubview:self.arrowView];
    [self.menu addSubview:self.filterButton];
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.sourceContainerView];
    [self.sourceContainerView addSubview:self.sourceTitleLabel];
    [self.sourceContainerView addSubview:self.sourceCollectionView];

    [self setConstraints];
    [self getConfig];
    [self configMJRefresh];
    [self getTableData];
    //    [self hideFilterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - private methods

- (void)configMJRefresh
{
    LoadingFooter *loadingFooter = [LoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer = loadingFooter;

    LoadingHeader *loadingHeader = [LoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_header = loadingHeader;
}

- (void)loadMore
{
    [self getTableData];
    //    [self getTableDataWithUrl:[NSString stringWithFormat:self.originUrlForCourses, self.CurrentCourseFlag, self.courseResponseForCategory.cursor, self.courseId]];
}

- (void)refresh
{
    [self.tableDataCache removeAllObjects];
    self.courseResponseForCategory.cursor = @"";
    [self getTableData];
}

- (NSString *)originUrlForCourses
{
    if (!_originUrlForCourses) {
        _originUrlForCourses = @"http://c.open.163.com/mob/classify/newplaylist.do?cursor=%@&flag=%d&id=%@&type=5";
    }

    return _originUrlForCourses;
}

- (void)clickLatestButton:(id)sender
{
    if (!_isLatestButtonSelected) {
        _isLatestButtonSelected = YES;
        _latestButton.tintColor = [UIColor colorWithRed:60 / 255.0 green:132 / 255.0 blue:79 / 255.0 alpha:1];
        _latestButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _hottestButton.tintColor = [UIColor blackColor];
        _hottestButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.currentCourseFlag = 1;
        //        [self refresh];
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)clickHottestButton:(id)sender
{
    if (_isLatestButtonSelected) {
        _isLatestButtonSelected = NO;
        _hottestButton.tintColor = [UIColor colorWithRed:60 / 255.0 green:132 / 255.0 blue:79 / 255.0 alpha:1];
        _hottestButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _latestButton.tintColor = [UIColor blackColor];
        _latestButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.currentCourseFlag = 2;
        //        [self refresh];
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)clickFilterButton:(id)sender
{
    _isFilterButtonSelected = !_isFilterButtonSelected;
    if (_isFilterButtonSelected) {
        _arrowView.image = [UIImage imageNamed:@"arrow_to_hidden_7x7_@2x.png"];
        _filterButton.tintColor = [UIColor colorWithRed:60 / 255.0 green:132 / 255.0 blue:79 / 255.0 alpha:1];
        _filterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        //show filter view
        [self showFilterView];
    }
    else {
        _arrowView.image = [UIImage imageNamed:@"arrow_to_show_7x7_@2x.png"];
        _filterButton.tintColor = [UIColor blackColor];
        _filterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        [self hideFilterView];
    }
}

- (void)showFilterView
{
    [UIView animateWithDuration:0.2 animations:^{
        _sourceContainerView.center = CGPointMake(160, 142);
    }
        completion:^(BOOL finished) {
            [self.view bringSubviewToFront:_sourceContainerView];

        }];
}

- (void)hideFilterView
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view sendSubviewToBack:_sourceContainerView];
        _sourceContainerView.center = CGPointMake(160, -self.view.bounds.size.height);
    }
        completion:^(BOOL finished){

        }];
}

- (void)buttonsStateInit
{
    _isLatestButtonSelected = YES;
    _isFilterButtonSelected = NO;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationBar
{
    UIBarButtonItem *customLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backBarButtonItem_40x30_@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = customLeft;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - lazy initialize

- (UIView *)menu
{
    if (!_menu) {
        _menu = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
        _menu.backgroundColor = [UIColor whiteColor];
    }

    return _menu;
}

- (UIButton *)latestButton
{
    if (!_latestButton) {
        _latestButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _latestButton.frame = CGRectMake(0, 0, 46, 40);
        //        _latestButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _latestButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _latestButton.tintColor = [UIColor colorWithRed:60 / 255.0 green:132 / 255.0 blue:79 / 255.0 alpha:1];
        [_latestButton setTitle:@"最新" forState:UIControlStateNormal];
        [_latestButton addTarget:self action:@selector(clickLatestButton:) forControlEvents:UIControlEventTouchDown];
    }

    return _latestButton;
}

- (UIButton *)hottestButton
{
    if (!_hottestButton) {
        _hottestButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _hottestButton.frame = CGRectMake(0, 0, 46, 40);
        //        _hottestButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _hottestButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        _hottestButton.tintColor = [UIColor blackColor];
        [_hottestButton setTitle:@"最热" forState:UIControlStateNormal];
        [_hottestButton addTarget:self action:@selector(clickHottestButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _hottestButton;
}

- (UIButton *)filterButton
{
    if (!_filterButton) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _filterButton.frame = CGRectMake(0, 0, 46, 40);
        _filterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        _filterButton.tintColor = [UIColor blackColor];
        [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
        /*
        [_filterButton setImage:[UIImage imageNamed:@"arrow_to_hidden_7x7_@2x.png"] forState:UIControlStateNormal];
        [_filterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_filterButton.imageView.frame.size.width, 0, _filterButton.imageView.frame.size.width)];
        [_filterButton setImageEdgeInsets:UIEdgeInsetsMake(0, _filterButton.titleLabel.bounds.size.width + 5, 0, -_filterButton.titleLabel.bounds.size.width)];
         */
        [_filterButton addTarget:self action:@selector(clickFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _filterButton;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        _arrowView.image = [UIImage imageNamed:@"arrow_to_show_7x7_@2x.png"];
    }

    return _arrowView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, self.view.frame.size.width, self.view.frame.size.height - 104)];
        _tableView.rowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }

    return _tableView;
}

- (CourseResponseForCategory *)courseResponseForCategory
{
    if (!_courseResponseForCategory) {
        _courseResponseForCategory = [[CourseResponseForCategory alloc] init];
    }

    return _courseResponseForCategory;
}

- (NSMutableArray *)hotCoursesArray
{
    if (!_hotCoursesArray) {
        _hotCoursesArray = [[NSMutableArray alloc] init];
        CourseItem *defaultItem = [[CourseItem alloc] init];
        defaultItem.identifier = 0;
        defaultItem.name = @"全部";
        [_hotCoursesArray addObject:defaultItem];
    }

    return _hotCoursesArray;
}

- (ConfigResponse *)configResponse
{
    if (!_configResponse) {
        _configResponse = [[ConfigResponse alloc] init];
    }

    return _configResponse;
}

- (NSMutableArray *)allCoursesArray
{
    if (!_allCoursesArray) {
        _allCoursesArray = [[NSMutableArray alloc] init];
        CourseItem *defaultItem = [[CourseItem alloc] init];
        defaultItem.identifier = 0;
        defaultItem.name = @"全部";
        [_allCoursesArray addObject:defaultItem];
    }

    return _allCoursesArray;
}

- (UIView *)sourceContainerView
{
    if (!_sourceContainerView) {
        //        _sourceContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 106, self.view.frame.size.width, 72)];
        _sourceContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, 72)];
        _sourceContainerView.backgroundColor = [UIColor whiteColor];
        _sourceContainerView.alpha = 0.95;
    }

    return _sourceContainerView;
}

- (UILabel *)sourceTitleLabel
{
    if (!_sourceTitleLabel) {
        _sourceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 40)];
        _sourceTitleLabel.textColor = [UIColor lightGrayColor];
        _sourceTitleLabel.text = @"来源:";
        _sourceTitleLabel.font = [UIFont systemFontOfSize:11];
    }

    return _sourceTitleLabel;
}

- (UICollectionView *)sourceCollectionView
{
    if (!_sourceCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0.5;
        _sourceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) collectionViewLayout:layout];
        _sourceCollectionView.dataSource = self;
        _sourceCollectionView.delegate = self;
        _sourceCollectionView.backgroundColor = [UIColor whiteColor];
        [_sourceCollectionView registerClass:[SourceCollectionViewCell class] forCellWithReuseIdentifier:SourceCollectionViewCellIdentifier];
    }

    return _sourceCollectionView;
}

- (NSMutableArray *)tableDataCache
{
    if (!_tableDataCache) {
        _tableDataCache = [[NSMutableArray alloc] init];
    }

    return _tableDataCache;
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataCache.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (!cell) {
        cell = [[CourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }

    CourseItemForCategory *item = self.tableDataCache[indexPath.row];
    [cell configWithCourseItem:item];
    return cell;
}

#pragma mark - collection layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseItem *item = self.hotCoursesArray[indexPath.row];
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:11.5],
    };

    CGSize textSize = [item.name boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    CGSize paddingSize = CGSizeMake(textSize.width + 27, textSize.height + 10);
    return paddingSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - uicollection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // reset all items background color and font style
    for (int i = 0; i < _hotCoursesArray.count; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        SourceCollectionViewCell *viewCell = (SourceCollectionViewCell *)[collectionView cellForItemAtIndexPath:path];
        viewCell.titleLabel.backgroundColor = [UIColor whiteColor];
        viewCell.titleLabel.textColor = [UIColor blackColor];
    }

    SourceCollectionViewCell *cell = (SourceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.backgroundColor = [UIColor colorWithRed:60 / 255.0 green:132 / 255.0 blue:79 / 255.0 alpha:1];
    cell.titleLabel.textColor = [UIColor whiteColor];
    CourseItem *item = _hotCoursesArray[indexPath.row];
    self.courseId = [NSString stringWithFormat:@"%ld", (long)item.identifier];
    self.courseId = [self.courseId isEqualToString:@"0"] ? @"" : self.courseId;
    self.navigationItem.title = item.name;

    [self refresh];
}

#pragma mark - uicollection view datasource delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.hotCoursesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SourceCollectionViewCellIdentifier forIndexPath:indexPath];
    CourseItem *item = _hotCoursesArray[indexPath.row];
    cell.title = item.name;

    if (self.courseId == [NSString stringWithFormat:@"%ld", (long)item.identifier]) {
        cell.titleLabel.backgroundColor = [UIColor colorWithRed:60 / 255.0 green:132 / 255.0 blue:79 / 255.0 alpha:1];
        cell.titleLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark - set constrains

- (void)setConstraints
{
    [_latestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_menu.mas_centerY);
        make.left.equalTo(_menu.mas_left).offset(10);
    }];

    [_hottestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_menu.mas_centerY);
        make.left.equalTo(_latestButton.mas_right).offset(30);
    }];

    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_menu.mas_centerY);
        make.right.equalTo(_menu.mas_right).offset(-10);
    }];

    [_filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_menu.mas_centerY);
        make.right.equalTo(_arrowView.mas_left).offset(-10);
    }];

    // TODO: 这里添加约束的话隐藏的动画效果结束会回到原位
    //    [_sourceContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        //        make.centerY.equalTo(self.view.mas_centerY);
    //        make.top.equalTo(_tableView.mas_top);
    //        make.width.equalTo(self.view.mas_width);
    //        make.height.mas_equalTo(72);
    //    }];

    [_sourceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.latestButton.mas_left);
        make.top.equalTo(_sourceContainerView.mas_top).offset(15);
        make.width.mas_equalTo(26);
    }];

    [_sourceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.view.frame.size.width - 46));
        make.height.equalTo(_sourceContainerView.mas_height);
        make.left.equalTo(_sourceTitleLabel.mas_right);
        make.top.equalTo(_sourceContainerView.mas_top);
    }];
}

@end
