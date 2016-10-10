//
//  CardView.m
//  Open163
//
//  Created by Frank on 10/8/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CardView.h"
#import "Masonry.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CardView ()
@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailsLabel;
@property (strong, nonatomic) UIButton *joinButton;
@property (strong, nonatomic) UILabel *joinCountLabel;
@property (strong, nonatomic) UILabel *typeNameLabel;
@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame andCard:(Card *)card
{
    self = [super initWithFrame:frame];
    if (self) {
        self.card = card;
        [self addSubview:self.cardImageView];
        [self addSubview:self.typeNameLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailsLabel];
        [self addSubview:self.joinButton];
        [self addSubview:self.joinCountLabel];
        [self setup];
        // TODO: 这里使用自动布局，卡牌执行动画的时候会错位
        //        [self setConstraints];
    }

    return self;
}

- (void)setup
{
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    // Corner Radius
    self.layer.cornerRadius = 10.0;

    self.backgroundColor = [UIColor whiteColor];
}
#pragma mark - constraints

- (void)setConstraints
{
    //    [_cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.
    //    }]

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_cardImageView).offset(20);

    }];

    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel.mas_left).offset(5);
    }];

    [_joinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(_joinCountLabel.mas_top).offset(-20);
    }];
}

#pragma mark - lazy init

- (UIImageView *)cardImageView
{
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2 - 40)];
        [_cardImageView sd_setImageWithURL:[NSURL URLWithString:_card.imageUrl] placeholderImage:[UIImage imageNamed:@"pic_default1@2x.png"]];
    }

    return _cardImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGSize textSize = [self calTextSize:_card.title fontSize:14];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        _titleLabel.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2 + 10);
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14]; //[UIFont systemFontOfSize:14];
        _titleLabel.text = _card.title;
    }

    return _titleLabel;
}

- (UILabel *)detailsLabel
{
    if (!_detailsLabel) {
        CGSize textSize = [self calTextSize:_card.shareDescription fontSize:10];
        _detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        _detailsLabel.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2 + 40);
        _detailsLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        _detailsLabel.tintColor = [UIColor lightGrayColor];
        _detailsLabel.text = _card.shareDescription;
    }

    return _detailsLabel;
}

- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _joinButton.frame = CGRectMake(0, 0, self.frame.size.width / 2.0 - 15, 30);
        _joinButton.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height * 3.0 / 4 + 20);
        [_joinButton setTitle:@"立即参与" forState:UIControlStateNormal];
        _joinButton.tintColor = [UIColor whiteColor];
        _joinButton.backgroundColor = [UIColor blackColor];
        _joinButton.layer.cornerRadius = 5;
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }

    return _joinButton;
}

- (UILabel *)joinCountLabel
{
    if (!_joinCountLabel) {
        NSUInteger countLength = [NSString stringWithFormat:@"%ld", (long)_card.viewCount].length;
        NSString *str = [NSString stringWithFormat:@"已有%ld人参与", (long)_card.viewCount];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str];

        UIColor *attrColor = [UIColor colorWithRed:60.0 / 255.0 green:136.0 / 255.0 blue:87.0 / 255.0 alpha:1];
        [attributedText addAttribute:NSForegroundColorAttributeName value:attrColor range:NSMakeRange(2, countLength)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:12] range:NSMakeRange(2, countLength)];

        CGSize textSize = [self calAttributedTextSize:attributedText];
        _joinCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        _joinCountLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 3.0 / 4 + 68);
        _joinCountLabel.font = [UIFont systemFontOfSize:10];
        [_joinCountLabel setAttributedText:attributedText];
    }

    return _joinCountLabel;
}

- (UILabel *)typeNameLabel
{
    if (!_typeNameLabel) {
        CGFloat margin = 12;
        CGSize textSize = [self calTextSize:_card.typeName fontSize:11];
        CGSize labelSize = CGSizeMake(textSize.width + 3 * margin, textSize.height + margin);
        _typeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - labelSize.width, 10, labelSize.width, labelSize.height)];
        _typeNameLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8];
        _typeNameLabel.textColor = [UIColor whiteColor];
        _typeNameLabel.font = [UIFont systemFontOfSize:11];
        _typeNameLabel.text = _card.typeName;
        _typeNameLabel.textAlignment = NSTextAlignmentCenter;

        // draw rounded corner
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_typeNameLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10.0, 10.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _typeNameLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _typeNameLabel.layer.mask = maskLayer;
    }

    return _typeNameLabel;
}

#pragma mark - private methods

- (CGSize)calTextSize:(NSString *)text fontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] };
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize;
}

- (CGSize)calAttributedTextSize:(NSMutableAttributedString *)text
{
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    return textSize;
}
/*
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setDetails:(NSString *)details
{
    self.detailsLabel.text = details;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pic_default1@2x.png"]];
}

- (void)setJoinCount:(NSInteger)joinCount
{
    self.joinCountLabel.text = [NSString stringWithFormat:@"已有%ld人参与", (long)joinCount];
}
 */
@end
