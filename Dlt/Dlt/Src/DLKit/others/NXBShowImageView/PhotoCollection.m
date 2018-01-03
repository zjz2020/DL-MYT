//
//  PhotoCollection.m
//  PhotoDemo
//
//  Created by mac on 15/8/31.
//  Copyright (c) 2015年 xiaowei project. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoCollection.h"

static NSString *identy = @"cell";
@implementation PhotoCollection

- (id)initWithFrame:(CGRect)frame
    collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  if (self) {
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[PhotoCell class] forCellWithReuseIdentifier:identy];
  }
  return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  //    NSLog(@"array = %@",_imgArray);
  //    NSLog(@"imgArray = %ld",(unsigned long)_imgArray.count);
  return _imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PhotoCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:identy
                                                forIndexPath:indexPath];
  cell.imgName = _imgArray[indexPath.row];
  cell.backgroundColor = [UIColor blackColor];
  return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

  return UIEdgeInsetsMake(0, 0, 0, 10);
}

@end
