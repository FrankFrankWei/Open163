//
//  CourseCellTableViewCell.m
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CourseCell.h"
#import "Masonry.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+Hex.h"

@interface CourseCell ()

//@property (strong, nonatomic) UIImageView* posterImageView;
//@property (strong, nonatomic) UIImageView* durationImageView;
//@property (strong, nonatomic) UIImageView* videoIconImageView;
//@property (strong, nonatomic) UILabel* quantityLabel;
//@property (strong, nonatomic) UIImageView* documentIconImageView;
//@property (strong, nonatomic) UIImageView* courseTypeIconImageView;
//@property (strong, nonatomic) UILabel* courseTypeLabel;
//@property (strong, nonatomic) UILabel* createTimeLabel;
//@property (strong, nonatomic) UILabel* titleLabel;
//@property (strong, nonatomic) UILabel* detailsLabel;
//@property (strong, nonatomic) UILabel* viewCountLabel;
//@property (strong, nonatomic) UIButton* shareButton;
//@property (strong, nonatomic) UIButton* storeButton;
//@property (strong, nonatomic) UIImageView* seperatorImageView;
//@property (strong, nonatomic) Course* course;
@property (strong, nonatomic) Course *currentCourse;
@end

@implementation CourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawUI];
    }

    return self;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)drawUI
{
    [self addPosterImageView];
    [self addDurationImageView];
    [self addVideoIconImageView];
    [self addQuantityLabel];
    [self addDocumentIconImageView];
    [self addCourseTypeLabel];
    [self addCreateTimeLabel];
    [self addTitleLabel];
    [self addDetailsLabel];
    [self addViewCountLabel];
    [self addShareButton];
    [self addStoreButton];
    [self addSeperatorImageView];
}

- (void)shareButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShareButtonClick:)]) {
        [self.delegate didShareButtonClick:_currentCourse];
    }
}

- (void)configureForCourse:(Course *)course
{
    _currentCourse = course;
    [_posterImageView sd_setImageWithURL:[NSURL URLWithString:course.picUrl] placeholderImage:[UIImage imageNamed:@"pic_default1@2x.png"]];

    _quantityLabel.text = course.quantity;

    _courseTypeLabel.text = course.courseType;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:13] };
    CGSize textSize = [course.courseType boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    _courseTypeLabel.frame = CGRectMake(14, 184, textSize.width + 20, textSize.height + 4);
    _courseTypeLabel.backgroundColor = [UIColor colorWithHexString:course.tagBgColor];

    if (nil == course.quantity) {
        _durationImageView.hidden = YES;
        _videoIconImageView.hidden = YES;
        _quantityLabel.hidden = YES;
    }
    else {
        _documentIconImageView.hidden = YES;
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:course.dbCreateTime / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    _createTimeLabel.text = [formatter stringFromDate:date];

    _titleLabel.text = course.title;
    _detailsLabel.text = course.desc;
    NSString *viewCountText = course.viewCount >= 10000 ? [NSString stringWithFormat:@"%ld万人观看", course.viewCount / 10000] : [NSString stringWithFormat:@"%ld人观看", (long)course.viewCount];
    _viewCountLabel.text = viewCountText;

    [self setConstraints:course];
}

#pragma mark - add ui

- (void)addPosterImageView
{
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 170)];
    }

    [self.contentView addSubview:_posterImageView];
}

- (void)addDurationImageView
{
    //    if (!_durationImageView) {
    _durationImageView = [[UIImageView alloc] init];
    //    }
    _durationImageView.image = [UIImage imageNamed:@"home_video_b_66x20_@2x.png"];

    [self.contentView addSubview:_durationImageView];
}

- (void)addVideoIconImageView
{
    if (!_videoIconImageView) {
        _videoIconImageView = [[UIImageView alloc] init];
    }
    _videoIconImageView.image = [UIImage imageNamed:@"home_video_14x12_@2x.png"];

    [_durationImageView addSubview:_videoIconImageView];
}

- (void)addQuantityLabel
{
    if (!_quantityLabel) {
        _quantityLabel = [[UILabel alloc] init];
    }
    _quantityLabel.font = [UIFont systemFontOfSize:10.0];
    _quantityLabel.textColor = [UIColor whiteColor];
    [_quantityLabel sizeToFit];

    [_durationImageView addSubview:_quantityLabel];
}

- (void)addDocumentIconImageView
{
    if (!_documentIconImageView) {
        _documentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 15, 15, 15)];
    }
    _documentIconImageView.image = [UIImage imageNamed:@"home_h5_15x15_@2x.png"];

    [self.contentView addSubview:_documentIconImageView];
}

- (void)addCourseTypeLabel
{
    if (!_courseTypeLabel) {
        _courseTypeLabel = [[UILabel alloc] init];
        _courseTypeLabel.textColor = [UIColor whiteColor];
        _courseTypeLabel.font = [UIFont systemFontOfSize:11.5];
        _courseTypeLabel.textAlignment = NSTextAlignmentCenter;
        _courseTypeLabel.layer.cornerRadius = 3.5;
        _courseTypeLabel.layer.masksToBounds = YES;
    }

    [self.contentView addSubview:_courseTypeLabel];
}

- (void)addCreateTimeLabel
{
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] init];
    }

    _createTimeLabel.font = [UIFont systemFontOfSize:11];
    _createTimeLabel.textColor = [UIColor lightGrayColor];
    [_createTimeLabel sizeToFit];

    [self.contentView addSubview:_createTimeLabel];
}

- (void)addTitleLabel
{
    if (!_titleLabel) {

        _titleLabel = [[UILabel alloc] init];
    }
    _titleLabel.font = [UIFont systemFontOfSize:16];
    //    [_titleLabel sizeToFit];

    [self.contentView addSubview:_titleLabel];
}

- (void)addDetailsLabel
{
    if (!_detailsLabel) {
        _detailsLabel = [[UILabel alloc] init];
    }
    _detailsLabel.font = [UIFont systemFontOfSize:12.5];
    _detailsLabel.textColor = [UIColor lightGrayColor];
    _detailsLabel.numberOfLines = 2;
    [_detailsLabel sizeToFit];

    [self.contentView addSubview:_detailsLabel];
}

- (void)addViewCountLabel
{
    if (!_viewCountLabel) {
        _viewCountLabel = [[UILabel alloc] init];
    }
    _viewCountLabel.font = [UIFont systemFontOfSize:11.0];
    _viewCountLabel.textColor = [UIColor lightGrayColor];

    [_viewCountLabel sizeToFit];

    [self.contentView addSubview:_viewCountLabel];
}

- (void)addShareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
    }
    [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"home_shared_18x18_@2x.png"] forState:UIControlStateNormal];

    [self.contentView addSubview:_shareButton];
}

- (void)addStoreButton
{
    if (!_storeButton) {
        _storeButton = [[UIButton alloc] init];
    }
    [_storeButton setBackgroundImage:[UIImage imageNamed:@"home_tolike_18x18_@2x"] forState:UIControlStateNormal];

    [self.contentView addSubview:_storeButton];
}

- (void)addSeperatorImageView
{
    if (!_seperatorImageView) {
        _seperatorImageView = [[UIImageView alloc] init];
    }
    _seperatorImageView.image = [UIImage imageNamed:@"list_bg_middle_pressed_440x50_@2x.png"];

    [self.contentView addSubview:_seperatorImageView];
}

#pragma mark - constraints

- (void)setConstraints:(Course *)course
{
    if (nil != course.quantity) {
        [_durationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.posterImageView.mas_top).offset(13);
            make.right.equalTo(self.posterImageView.mas_right).offset(-13);
            make.width.equalTo(@66);
            make.height.equalTo(@20);
        }];

        [_videoIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.durationImageView.mas_left).offset(6);
            make.top.equalTo(self.durationImageView.mas_top).offset(3);
            make.width.equalTo(@14);
            make.height.equalTo(@14);
        }];

        [_quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.durationImageView.mas_top).offset(5);
            make.left.equalTo(_videoIconImageView.mas_right).offset(6);
        }];
    }
    else {
        [_documentIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.posterImageView.mas_top).offset(18);
            make.right.equalTo(self.posterImageView.mas_right).offset(-18);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
    }

    /*
    [_courseTypeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.posterImageView.mas_bottom).offset(14);
        make.left.equalTo(self.posterImageView.mas_left).offset(14);
        NSLog(@"%f", labelWidth);
        NSLog(@"%f", labelHeight);
        make.size.equalTo(_courseTypeLabel).insets(UIEdgeInsetsMake(-4, 10, 4, 10));
        //        make.width.equalTo(@100);
        //        make.height.equalTo(@50);
    }];
     */

    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.courseTypeLabel.mas_centerY);
        make.left.equalTo(self.courseTypeLabel.mas_right).offset(10);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseTypeLabel.mas_left);
        make.top.equalTo(self.courseTypeLabel.mas_bottom).offset(16);
    }];

    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImageView.mas_left).offset(14);
        // TODO: 这里用这个会报错
        //        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.top.equalTo(self.courseTypeLabel.mas_bottom).offset(44);
        make.height.equalTo(@30);
        make.right.equalTo(self.mas_right).offset(-14);
    }];

    [_viewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImageView.mas_left).offset(14);
        make.top.equalTo(self.detailsLabel.mas_bottom).offset(24);
    }];

    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailsLabel.mas_bottom).offset(26);
        make.right.equalTo(self.mas_right).offset(-50);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];

    [_storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareButton.mas_centerY);
        make.left.equalTo(self.shareButton.mas_right).offset(20);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];

    [_seperatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(self.mas_bottom).offset(-10);
    }];
}

#pragma mark - default code

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
