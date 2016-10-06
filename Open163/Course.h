//
//  Lesson.h
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>

@interface Course : NSObject <NSCopying>
@property (assign, nonatomic) NSInteger identifier;
@property (strong, nonatomic) NSString *rid;
@property (assign, nonatomic) NSInteger rtype;
@property (strong, nonatomic) NSString *plid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *picUrl;
@property (strong, nonatomic) NSString *courseType;
@property (strong, nonatomic) NSString *pageUrl;
@property (strong, nonatomic) NSString *quantity;
@property (assign, nonatomic) NSInteger weight;
@property (assign, nonatomic) NSInteger viewCount;
@property (assign, nonatomic) NSInteger dbCreateTime;
@property (nonatomic) BOOL userStore;
@property (strong, nonatomic) NSString *tagBgColor;
@property (strong, nonatomic) NSString *weiboUrl;
@property (strong, nonatomic) NSString *weiboName;
@property (strong, nonatomic) NSString *liveStatus;
@property (strong, nonatomic) NSString *startTime;

@end
