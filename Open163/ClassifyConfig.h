//
//  ClassifyConfig.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseItem.h"

@interface ClassifyConfig : NSObject
@property (strong, nonatomic) NSArray *source;
@property (strong, nonatomic) NSArray *base;
@property (strong, nonatomic) NSArray *special;
@end
