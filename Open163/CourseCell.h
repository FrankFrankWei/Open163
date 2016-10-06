//
//  CourseCellTableViewCell.h
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "Course.h"
#import <UIKit/UIKit.h>

@protocol CourseCellDelegate <NSObject>
@optional
- (void)didShareButtonClick:(Course *)course;
//- (void)didShareButtonClick;
@end

@interface CourseCell : UITableViewCell
@property (strong, nonatomic) UIImageView *posterImageView;
@property (strong, nonatomic) UIImageView *durationImageView;
@property (strong, nonatomic) UIImageView *videoIconImageView;
@property (strong, nonatomic) UILabel *quantityLabel;
@property (strong, nonatomic) UIImageView *documentIconImageView;
@property (strong, nonatomic) UIImageView *courseTypeIconImageView;
@property (strong, nonatomic) UILabel *courseTypeLabel;
@property (strong, nonatomic) UILabel *createTimeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailsLabel;
@property (strong, nonatomic) UILabel *viewCountLabel;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *storeButton;
@property (strong, nonatomic) UIImageView *seperatorImageView;
@property (weak, nonatomic) id<CourseCellDelegate> delegate;
//@property (strong, nonatomic) Course* course;

- (void)configureForCourse:(Course *)course;
@end
