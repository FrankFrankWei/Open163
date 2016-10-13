//
//  SourceCollectionViewCell.m
//  Open163
//
//  Created by Frank on 10/2/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "SourceCollectionViewCell.h"

@interface SourceCollectionViewCell ()
@end

@implementation SourceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }

    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:11.5];
        _titleLabel.layer.cornerRadius = 12;
        _titleLabel.layer.masksToBounds = YES;
    }

    return _titleLabel;
}

@end
