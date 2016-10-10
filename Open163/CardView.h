//
//  CardView.h
//  Open163
//
//  Created by Frank on 10/8/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView
/*
@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailsLabel;
@property (strong, nonatomic) UIButton *joinButton;
@property (strong, nonatomic) UILabel *joinCountLabel;
 */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) NSInteger joinCount;
@property (strong, nonatomic) Card *card;

- (instancetype)initWithFrame:(CGRect)frame andCard:(Card *)card;

@end
