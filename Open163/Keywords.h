//
//  HotKeywords.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keywords : NSObject // map to : hotKeywords
@property (assign, nonatomic) NSInteger identifier; // map to : id
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *value1;
@property (strong, nonatomic) NSString *value2;
@property (strong, nonatomic) NSString *value3;
@property (strong, nonatomic) NSString *value4;
@property (assign, nonatomic) NSInteger weight;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *desc; // map to : description
@end
