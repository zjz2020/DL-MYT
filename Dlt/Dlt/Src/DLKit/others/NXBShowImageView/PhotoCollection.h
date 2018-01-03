//
//  PhotoCollection.h
//  PhotoDemo
//
//  Created by mac on 15/8/31.
//  Copyright (c) 2015年 xiaowei project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollection
    : UICollectionView <UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout>

@property(nonatomic, copy) NSArray *imgArray;

@end
