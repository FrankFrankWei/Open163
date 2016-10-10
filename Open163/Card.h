//
//  Card.h
//  Open163
//
//  Created by Frank on 10/8/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (assign, nonatomic) NSInteger identifier; // map to id
@property (assign, nonatomic) NSInteger targetId;
@property (assign, nonatomic) NSInteger weight;
@property (assign, nonatomic) NSInteger dbCreateTime;
@property (assign, nonatomic) NSInteger dbUpdateTime;
@property (assign, nonatomic) NSInteger viewCount;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc; // map to description
@property (strong, nonatomic) NSString *shareDescription;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) NSInteger publishTime;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *typeName;
@property (assign, nonatomic) NSInteger classBreakType;
@end
