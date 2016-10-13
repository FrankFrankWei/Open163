//
//  LoadingHeader.m
//  Open163
//
//  Created by Frank on 9/23/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "LoadingHeader.h"

@implementation LoadingHeader

- (void)prepare
{
    [super prepare];
    NSMutableArray* idleImages = [NSMutableArray array];
    [idleImages addObject:[UIImage imageNamed:@"pull_00032_120x85_@2x.png"]];

    NSMutableArray* refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 33; i < 59; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"pull_000%zd_120x85_@2x.png", i]];
        [refreshingImages addObject:image];
    }

    [self setImages:idleImages forState:MJRefreshStateIdle];
    [self setImages:idleImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end
