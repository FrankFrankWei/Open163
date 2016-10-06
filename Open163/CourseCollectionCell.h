//
//  CourseCollectionCell.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseItem.h"

@interface CourseCollectionCell : UICollectionViewCell
- (void)configCell:(CourseItem *)courseItem;
@end
