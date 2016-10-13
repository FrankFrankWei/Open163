//
//  LoadingFooter.m
//  Open163
//
//  Created by Frank on 9/23/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "LoadingFooter.h"

@implementation LoadingFooter

- (void)prepare
{
    [super prepare];

    NSMutableArray* refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 31; i < 46; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"loading4_000%zd_70x30_@2x.png", i]];
        [refreshingImages addObject:image];
    }

    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.refreshingTitleHidden = YES;
    self.stateLabel.hidden = YES;
}

@end
