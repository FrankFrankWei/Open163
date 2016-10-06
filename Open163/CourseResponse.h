//
//  LessonResponse.h
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseResponse : NSObject
@property (strong, nonatomic) NSString *cursor;
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSArray *courses;
@end
