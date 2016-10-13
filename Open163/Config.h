//
//  Config.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassifyConfig.h"
#import "Keywords.h"
#import "CourseItem.h"

@interface Config : NSObject // map to : data

@property (strong, nonatomic) ClassifyConfig *classifyConfig;
@property (strong, nonatomic) Keywords *searchKeyword;
@property (strong, nonatomic) NSString *articlePhotoEntranceImage;
@property (strong, nonatomic) NSString *refreshIco;
@property BOOL hideArticlePhoto;
@property (strong, nonatomic) NSArray *hotKeywords;
@property (strong, nonatomic) NSString *articlePhotoEntranceText;

@end
