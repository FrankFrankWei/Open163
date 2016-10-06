//
//  CourseResponseForCategory.h
//  Open163
//
//  Created by Frank on 10/3/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseResponseForCategory : NSObject
@property (strong, nonatomic) NSString *cursor;
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSArray *data;
@end
