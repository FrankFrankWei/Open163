//
//  MJExtensionConfig.m
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "Course.h"
#import "CourseResponse.h"
#import "MJExtension.h"
#import "CourseItem.h"
#import "ClassifyConfig.h"
#import "Keywords.h"
#import "Config.h"
#import "ConfigResponse.h"
#import "CourseItemForCategory.h"
#import "CourseResponseForCategory.h"
#import "Card.h"
#import "CardData.h"
#import "CardResponse.h"

@implementation MJExtensionConfig

+ (void)load
{
    [Course mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{
            @"identifier" : @"id",
            @"desc" : @"description",
            @"viewCount" : @"viewcount"
        };
    }];

    [CourseResponse mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{ @"courses" : @"data" };
    }];

    [CourseResponse mj_setupObjectClassInArray:^NSDictionary * {
        return @{ @"courses" : @"Course" };
    }];

    [ConfigResponse mj_setupObjectClassInArray:^NSDictionary * {
        return @{ @"data" : @"Config" };
    }];

    [ClassifyConfig mj_setupObjectClassInArray:^NSDictionary * {
        return @{ @"source" : @"CourseItem",
            @"base" : @"CourseItem",
            @"special" : @"CourseItem" };
    }];

    [Config mj_setupObjectClassInArray:^NSDictionary * {
        return @{ @"searchKeyword" : @"Keywords",
            @"hotKeywords" : @"Keywords" };
    }];

    [CourseItem mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{ @"identifier" : @"id" };
    }];

    [Keywords mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{ @"identifier" : @"id",
            @"description" : @"desc" };
    }];

    [CourseResponseForCategory mj_setupObjectClassInArray:^NSDictionary * {
        return @{ @"data" : @"CourseItemForCategory" };
    }];

    [CardData mj_setupObjectClassInArray:^NSDictionary * {
        return @{ @"list" : @"Card" };
    }];

    [Card mj_setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{ @"identifier" : @"id",
            @"desc" : @"description" };
    }];
}

@end
