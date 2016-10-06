//
//  CourseCollectionCell.m
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CourseCollectionCell.h"

@interface CourseCollectionCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation CourseCollectionCell

- (void)configCell:(CourseItem *)courseItem
{
    self.titleLabel.text = courseItem.name;
    [self.contentView addSubview:self.titleLabel];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width / 3 - 1, screenBounds.size.width / 9 - 0.5)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:11.5];
        //        [_titleLabel sizeToFit];
    }

    return _titleLabel;
}
@end
