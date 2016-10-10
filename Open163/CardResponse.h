//
//  CardResponse.h
//  Open163
//
//  Created by Frank on 10/8/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardData.h"

@interface CardResponse : NSObject

@property (strong, nonatomic) CardData *data;
@property (assign, nonatomic) NSInteger code;

@end
