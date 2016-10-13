//
//  BetweenClassViewController.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "LessonViewController.h"
#import "UIViewController+Hint.h"
#import "CardView.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "CardResponse.h"
#import "CardData.h"
#import "Card.h"
#import "ZLSwipeableView.h"
#import "Masonry.h"
#import <QuartzCore/QuartzCore.h>

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
@property (strong, nonatomic) CALayer *backgroundImageLayer;

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
        weakSelf.totalCountOfLessonLabel.text = [NSString stringWithFormat:@"/%ld", (long)weakSelf.cardDataCache.count];
    }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [weakSelf showHintWithMessage:@"网络不给力，请稍后再试"];
        }];
}

#pragma mark - zlswipeable data source delegate

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    if (self.cardIndex >= self.cardDataCache.count) {
        return nil;
    }
    if (0 == self.cardDataCache.count)
        return nil;

    Card *card = self.cardDataCache[self.cardIndex];
    CardView *cardView = [[CardView alloc] initWithFrame:swipeableView.bounds andCard:card];

    self.cardIndex++;
    if (0 == self.currentIndex) {
        NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache[0]).imageUrl];
        self.backgroundImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    }

    return cardView;
}

#pragma mark - private methods

- (void)showBackGroundImageView
{
    UIImage *image = [UIImage imageNamed:@"lessonBreak_lastBackground_375x667_@2x.png"];
    CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    contentsAnimation.fromValue = _backgroundImageView.layer.contents;
    contentsAnimation.toValue = (__bridge id)(image.CGImage);
    contentsAnimation.duration = 0.5f;

    self.backgroundImageView.layer.contents = (__bridge id)(image.CGImage);
    [_backgroundImageView.layer addAnimation:contentsAnimation forKey:nil];
}

- (void)hideBackGroudImageView
{
    NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache.lastObject).imageUrl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    contentsAnimation.fromValue = _backgroundImageView.layer.contents;
    contentsAnimation.toValue = (__bridge id)(image.CGImage);
    contentsAnimation.duration = 0.2f;

    self.backgroundImageView.layer.contents = (__bridge id)(image.CGImage);
    [_backgroundImageView.layer addAnimation:contentsAnimation forKey:nil];
}

#pragma zlswipeable delegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location
{
    if (self.DirectionFlag == 0) { // left
        //last card
        if (self.cardDataCache.count - 1 == self.currentIndex) {

            [UIView animateWithDuration:0.2 animations:^{
                self.swipeableView.alpha = 0;
            }
                completion:^(BOOL finished) {
                    self.swipeableView.hidden = YES;
                    [UIView animateWithDuration:0.2 animations:^{
                        [self showBackGroundImageView];
                    }
                        completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.visualEffectView.alpha = 0;
                            }
                                completion:^(BOOL finished) {
                                    self.visualEffectView.hidden = YES;
                                }];
                        }];
                }];

            return;
        }
        self.currentIndex++;
        NSInteger imageIndex = (self.currentIndex) % self.cardDataCache.count;
        NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache[imageIndex]).imageUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];

        CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
        contentsAnimation.fromValue = _backgroundImageView.layer.contents;
        contentsAnimation.toValue = (__bridge id)(image.CGImage);
        contentsAnimation.duration = 0.6f;

        self.backgroundImageView.layer.contents = (__bridge id)(image.CGImage);
        [_backgroundImageView.layer addAnimation:contentsAnimation forKey:nil];
    }
    else if (self.DirectionFlag == 1) { //right
        if (self.currentIndex > 0) {
            self.currentIndex--;
            // 本来是做成循环的，所以使用了取余
            NSInteger imageIndex = (self.currentIndex) % self.cardDataCache.count;
            NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache[imageIndex]).imageUrl];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];

            CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
            contentsAnimation.fromValue = _backgroundImageView.layer.contents;
            contentsAnimation.toValue = (__bridge id)(image.CGImage);
            contentsAnimation.duration = 0.6f;

            self.backgroundImageView.layer.contents = (__bridge id)(image.CGImage);
            [_backgroundImageView.layer addAnimation:contentsAnimation forKey:nil];
        }
    }
}

#pragma makr - constraints

- (void)setConstraints
{
    [_currentIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-8);
        make.top.equalTo(self.swipeableView.mas_bottom).offset(20);
    }];

    [_totalCountOfLessonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.swipeableView.mas_bottom).offset(20);
    }];
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
    [self.view addSubview:self.currentIndexLabel];
    [self.view addSubview:self.totalCountOfLessonLabel];
    [self getCardsInfo];
    [self.view addSubview:self.swipeableView];

    [self setConstraints];

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
        //        self.swipeableView.alpha = 1;
        //        self.visualEffectView.alpha = 1;
        [UIView animateWithDuration:0.1 animations:^{
            self.swipeableView.alpha = 0.5;
            self.visualEffectView.alpha = 0.5;
        }
            completion:^(BOOL finished) {
                [self hideBackGroudImageView];
                [UIView animateWithDuration:0.2 animations:^{
                    self.swipeableView.alpha = 1;
                    self.visualEffectView.alpha = 1;
                }
                    completion:^(BOOL finished){
                    }];
            }];

        /*
        NSURL *imageUrl = [NSURL URLWithString:((Card *)_cardDataCache.lastObject).imageUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
        contentsAnimation.fromValue = _backgroundImageView.layer.contents;
        contentsAnimation.toValue = (__bridge id)(image.CGImage);
        contentsAnimation.duration = 0.3f;
        
        self.backgroundImageView.layer.contents = (__bridge id)(image.CGImage);
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
        alphaAnimation.fromValue = @0;
        alphaAnimation.toValue = @1;
        alphaAnimation.duration = 0.3;
        
        [_backgroundImageView.layer addAnimation:contentsAnimation forKey:nil];
         */
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

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    self.currentIndexLabel.text = [NSString stringWithFormat:@"%ld", (long)(_currentIndex + 1)];
}

- (UILabel *)currentIndexLabel
{
    if (!_currentIndexLabel) {
        _currentIndexLabel = [[UILabel alloc] init];
        _currentIndexLabel.font = [UIFont systemFontOfSize:20];
        _currentIndexLabel.textColor = [UIColor whiteColor];
        NSString *textForCurrentIndex = [NSString stringWithFormat:@"%ld", (long)(_currentIndex + 1)];
        CGSize textSize = [self calTextSize:textForCurrentIndex fontSize:16];
        _currentIndexLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
        _currentIndexLabel.text = textForCurrentIndex;
    }

    return _currentIndexLabel;
}

- (UILabel *)totalCountOfLessonLabel
{
    if (!_totalCountOfLessonLabel) {
        _totalCountOfLessonLabel = [[UILabel alloc] init];
        _totalCountOfLessonLabel.font = [UIFont systemFontOfSize:12];
        _totalCountOfLessonLabel.textColor = [UIColor whiteColor];
        NSString *text = [NSString stringWithFormat:@"%ld", (long)(_cardDataCache.count)];
        CGSize textSize = [self calTextSize:text fontSize:12];
        _totalCountOfLessonLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
        _totalCountOfLessonLabel.text = text;
    }

    return _totalCountOfLessonLabel;
}

- (CGSize)calTextSize:(NSString *)text
             fontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] };
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize;
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
