//
//  RowCollectionViewCell.m
//  CrudApiConsumerApp
//
//  Created by Nia Mutiara on 5/10/14.
//  Copyright (c) 2014 CatCyborg. All rights reserved.
//

#import "ColumnCollectionViewCell.h"
#import "RowCollectionViewCell.h"

@interface RowCollectionViewCell () <
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RowCollectionViewCell

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColumnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColumnCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){119, collectionView.frame.size.height};
}

@end
