//
//  ArrayDataSource.m
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "ArrayDataSource.h"
#import "CourseCell.h"
@interface ArrayDataSource () 
@end

@implementation ArrayDataSource

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

- (id)initWithItems:(NSMutableArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.courses = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = aConfigureCellBlock;
    }

    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.courses[indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 这个方法会调用cell的initWithStyle:reuseIdentifier:方法，所以在cell的此方法中进行自定义
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell)
        cell = [[[self.cellClass class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];

    id item = [self itemAtIndexPath:indexPath];
    _configureCellBlock(cell, item);
    return cell;
}
@end
