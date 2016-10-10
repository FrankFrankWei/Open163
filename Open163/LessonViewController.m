//
//  BetweenClassViewController.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "LessonViewController.h"
#import "CardView.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "CardResponse.h"
#import "CardData.h"
#import "Card.h"
#import "ZLSwipeableView.h"
#import "MyZLSwipeableView.h"

@interface LessonViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, ZLSwipeableViewSwipingDeterminator>

@property (strong, nonatomic) NSMutableArray *cardDataCache;
@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property (assign, nonatomic) NSInteger cardIndex;
@property (strong, nonatomic) CardResponse *response;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSUInteger DirectionFlag; // 0 -left; 1 - right
@property (strong, nonatomic) UILabel *currentIndexLabel;
@property (strong, nonatomic) UILabel *totalCountOfLessonLabel;
@end

@implementation LessonViewController

- (BOOL)shouldSwipeView:(UIView *)view movement:(ZLSwipeableViewMovement *)movement swipeableView:(ZLSwipeableView *)swipeableView
{
    //    NSLog(@"%f", movement.translation.x);
    if (movement.translation.x > 0) {
        self.DirectionFlag = 1;
        [swipeableView rewind];
        return NO;
    }
    else {
        //        NSLog(@"left %ld", (long)self.currentIndex);
        self.DirectionFlag = 0;
        return YES;
    }
}

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

#pragma mark - get network data

- (void)getCardsInfo
{
    static NSString *url = @"http://c.open.163.com/mob/classBreak/homeList.do?queryType=1,2,3";
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        self.response = [CardResponse mj_objectWithKeyValues:responseObject];
        [weakSelf.cardDataCache addObjectsFromArray:_response.data.list];
    }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){

        }];
}

#pragma mark - zlswipeable data source delegate

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    if (self.cardIndex >= self.cardDataCache.count) {
        return nil;
    }
    if (0 == self.cardDataCache.count)
        return [[CardView alloc] initWithFrame:swipeableView.bounds];

    /*
    if (self.cardIndex >= self.cardDataCache.count) {
        self.cardIndex = 0;
    }
     */

    //    swipeableView.numberOfActiveViews = self.cardDataCache.count - swipeableView.history.count >= 3 ? 3 : self.cardDataCache.count - swipeableView.history.count;

    //    NSLog(@"%ld", (long)swipeableView.history.count);
    //    NSLog(@"%ld", (long)self.cardIndex);
    Card *card = self.cardDataCache[self.cardIndex];
    CardView *cardView = [[CardView alloc] initWithFrame:swipeableView.bounds andCard:card];

    self.cardIndex++;
    NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache[0]).imageUrl];
    self.backgroundImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];

    return cardView;
}

#pragma zlswipeable delegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction
{
}
/*
- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view{
    
    int a = 0;
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location{
    int a = 0;
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation{
    int a = 0;
}
 */

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location
{
    if (self.DirectionFlag == 0) {
        if (self.cardDataCache.count - 1 == self.currentIndex) {

            [UIView animateWithDuration:0.4 animations:^{
                self.swipeableView.alpha = 0;
                self.visualEffectView.alpha = 0;
            }
                completion:^(BOOL finished) {
                    self.swipeableView.hidden = YES;
                    self.visualEffectView.hidden = YES;
                }];
            return;
        }
        self.currentIndex++;
        NSInteger imageIndex = (self.currentIndex) % self.cardDataCache.count;
        NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache[imageIndex]).imageUrl];
        self.backgroundImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    }
    else if (self.DirectionFlag == 1) {
        if (self.currentIndex > 0) {
            self.currentIndex--;
            NSInteger imageIndex = (self.currentIndex) % self.cardDataCache.count;
            NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache[imageIndex]).imageUrl];
            self.backgroundImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        }
    }
}
#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardIndex = 0;
    self.currentIndex = 0;
    [self.view addSubview:self.backgroundImageView];
    [_backgroundImageView addSubview:self.visualEffectView];
    [self getCardsInfo];
    [self.view addSubview:self.swipeableView];

    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToRight:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;

    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:swipeRightGesture];
}

- (void)swipeToRight:(UISwipeGestureRecognizer *)gesture
{
    if (self.swipeableView.hidden) {
        self.swipeableView.hidden = NO;
        self.visualEffectView.hidden = NO;

        [UIView animateWithDuration:0.4 animations:^{
            self.swipeableView.alpha = 1;
            self.visualEffectView.alpha = 1;
        }
            completion:^(BOOL finished){

            }];
    }

    [self.swipeableView rewind];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillLayoutSubviews
{
    //    _swipeableView.numberOfActiveViews = self.cardDataCache.count;
    [self.swipeableView loadViewsIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy init

- (ZLSwipeableView *)swipeableView
{
    if (!_swipeableView) {
        _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(20, 50, 280, self.view.frame.size.height - 160)];
        _swipeableView.dataSource = self;
        _swipeableView.delegate = self;
        _swipeableView.swipingDeterminator = self;
        _swipeableView.numberOfHistoryItem = 30;
        //        _swipeableView.numberOfActiveViews = 10;
    }

    return _swipeableView;
}
- (NSMutableArray *)cardDataCache
{
    if (!_cardDataCache) {
        _cardDataCache = [[NSMutableArray alloc] init];
    }

    return _cardDataCache;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }

    return _backgroundImageView;
}

- (UIVisualEffectView *)visualEffectView
{
    if (!_visualEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }

    return _visualEffectView;
}

- (CardResponse *)response
{
    if (!_response) {
        _response = [[CardResponse alloc] init];
    }

    return _response;
}

//- (UILabel *)currentIndexLabel{
//    if (!_currentIndexLabel) {
//        _currentIndexLabel = [UILabel ]
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
