//
//  ArrayDataSource.h
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) TableViewCellConfigureBlock configureCellBlock;
@property (copy, nonatomic) NSString *cellIdentifier;
@property (strong, nonatomic) NSMutableArray *courses;
@property (strong, nonatomic) Class cellClass;

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

//- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
