//
//  ConfigResponse.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface ConfigResponse : NSObject
@property (strong, nonatomic) Config *data;
@property (assign, nonatomic) NSInteger code;
@end
