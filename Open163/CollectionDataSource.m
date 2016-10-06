//
//  CollectionDataSource.m
//  Open163
//
//  Created by Frank on 9/29/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "CollectionDataSource.h"
#import "CourseCollectionCell.h"

@implementation CollectionDataSource

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.datas[indexPath.item];
}

#pragma mark - datasource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    _configureBlock(cell, item);
    return cell;
}
@end
