//
//  CourseTableViewCell.m
//  Open163
//
//  Created by Frank on 10/2/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "Masonry.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CourseTableViewCell ()
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailsLabel;
@property (strong, nonatomic) UILabel *quantityLabel;
@property (strong, nonatomic) UILabel *viewCountLabel;
@end

@implementation CourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //    self.contentView.backgroundColor = [UIColor whiteColor];
    [self drawUI];
    [self setConstraints];

    return self;
}
- (void)configWithCourseItem:(CourseItemForCategory *)item
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.picUrl] placeholderImage:[UIImage imageNamed:@"pic_default1@2x.png"]];
    _titleLabel.text = item.title;
    _detailsLabel.text = item.courseType;
    _quantityLabel.text = item.quantity;
    NSString *viewCountText = item.viewcount >= 10000 ? [NSString stringWithFormat:@"%ld万人观看", item.viewcount / 10000] : [NSString stringWithFormat:@"%ld人观看", (long)item.viewcount];
    _viewCountLabel.text = viewCountText;
}

- (void)drawUI
{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailsLabel];
    [self.contentView addSubview:self.quantityLabel];
    [self.contentView addSubview:self.viewCountLabel];
}

#pragma mark - set constraints;

- (void)setConstraints
{
    CGFloat marginLeft = 10;
    CGFloat marginRight = 10;
    CGFloat marginTop = 20;
    CGFloat lineSpacing = 8;

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screenBounds.size.width / 3);
        make.height.mas_equalTo(60);
        make.left.mas_equalTo(marginLeft);
        make.top.mas_equalTo(marginTop);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(screenBounds.size.width - screenBounds.size.width / 3 - marginLeft - marginRight - marginRight));
        make.top.mas_equalTo(marginTop);
        make.left.equalTo(_avatarImageView.mas_right).offset(marginLeft);
    }];

    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(screenBounds.size.width - screenBounds.size.width / 3 - marginLeft - marginRight - marginRight));
        make.top.equalTo(_titleLabel.mas_bottom).offset(lineSpacing);
        make.left.equalTo(_titleLabel.mas_left);
    }];

    [_quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailsLabel.mas_bottom).offset(lineSpacing);
        make.left.equalTo(_detailsLabel.mas_left);
    }];

    [_viewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailsLabel.mas_bottom).offset(lineSpacing);
        make.left.equalTo(_quantityLabel.mas_right).offset(marginLeft);
    }];
}

#pragma mark - lazy property init
- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
    }

    return _avatarImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 0;
        //        [_titleLabel sizeToFit];
    }

    return _titleLabel;
}

- (UILabel *)detailsLabel
{
    if (!_detailsLabel) {
        _detailsLabel = [[UILabel alloc] init];
        _detailsLabel.textColor = [UIColor lightGrayColor];
        _detailsLabel.font = [UIFont systemFontOfSize:9];
        _detailsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        [_detailsLabel sizeToFit];
    }

    return _detailsLabel;
}

- (UILabel *)quantityLabel
{
    if (!_quantityLabel) {
        _quantityLabel = [[UILabel alloc] init];
        _quantityLabel.font = [UIFont systemFontOfSize:9];
        _quantityLabel.textColor = [UIColor lightGrayColor];
    }

    return _quantityLabel;
}

- (UILabel *)viewCountLabel
{
    if (!_viewCountLabel) {
        _viewCountLabel = [[UILabel alloc] init];
        _viewCountLabel.font = [UIFont systemFontOfSize:9];
        _viewCountLabel.textColor = [UIColor lightGrayColor];
    }

    return _viewCountLabel;
}
@end
