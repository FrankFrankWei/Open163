//
//  HeaderView.m
//  Open163
//
//  Created by Frank on 9/21/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (strong, nonatomic) UIImageView *logoImageView;

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:60.0 / 255.0 green:136.0 / 255.0 blue:87.0 / 255.0 alpha:1];
        [self addSubview:self.logoImageView];
        [self addSubview:self.searchBar];
    }

    return self;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 26.5, 29, 29)];
        _logoImageView.image = [UIImage imageNamed:@"home_logo_31x31_@2x.png"];
    }

    return _logoImageView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(55, 20, self.frame.size.width * 0.8, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;

        _searchBar.placeholder = _recommendedPlaceHolder ? _recommendedPlaceHolder : @"搜索";
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    }

    return _searchBar;
}

- (void)setRecommendedPlaceHolder:(NSString *)recommendedPlaceHolder
{
    _searchBar.placeholder = recommendedPlaceHolder;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
