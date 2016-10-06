//
//  Lesson.m
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "Course.h"
//#import "CourseResponse.h"
//#import "MJExtension.h"

@implementation Course

- (id)copyWithZone:(NSZone *)zone
{
    Course *copyInstance = [[[self class] allocWithZone:zone] init];
    return copyInstance;
}

@end