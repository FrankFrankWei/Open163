//
//  CourseTableViewCell.h
//  Open163
//
//  Created by Frank on 10/2/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseItemForCategory.h"

@interface CourseTableViewCell : UITableViewCell
- (void)configWithCourseItem:(CourseItemForCategory *)item;
@end
