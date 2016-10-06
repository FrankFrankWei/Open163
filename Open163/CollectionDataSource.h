//
//  CollectionDataSource.h
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CollectionViewCellConfigureBlock)(id cell, id item);

@interface CollectionDataSource : NSObject <UICollectionViewDataSource>
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) CollectionViewCellConfigureBlock configureBlock;
@property (strong, nonatomic) Class cellClass; 
@end
