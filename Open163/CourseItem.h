//
//  CourseItem.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseItem : NSObject
@property (assign, nonatomic) NSInteger identifier; // map to : id
@property (strong, nonatomic) NSString *templateType;
@property BOOL notUseName;
@property (strong, nonatomic) NSString *name;

@end
