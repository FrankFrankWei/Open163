//
//  CourseItemForCategory.h
//  Open163
//
//  Created by Frank on 10/3/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseItemForCategory : NSObject
@property (strong, nonatomic) NSString *plid;
@property (strong, nonatomic) NSString *rid;
@property (assign, nonatomic) NSInteger rtype;
@property (strong, nonatomic) NSString *courseType;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc; // map to description
@property (assign, nonatomic) NSInteger viewcount;
@property (strong, nonatomic) NSString *picUrl;
@property (assign, nonatomic) NSInteger publishTime;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *tagBgColor;
@property (assign, nonatomic) NSInteger flag;
@property (assign, nonatomic) NSInteger playcount;
@property (strong, nonatomic) NSString *pageUrl;
@end
