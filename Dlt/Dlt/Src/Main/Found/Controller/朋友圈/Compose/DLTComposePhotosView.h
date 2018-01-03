//
//  DLTComposePhotosView.h
//  Dlt
//
//  Created by Gavin on 17/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLTAssets;

@interface DLTComposePhotosView : UIView

@property (nonatomic , retain) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray <DLTAssets *>*assetsArray;
@property (nonatomic , strong, readonly) NSArray <UIImage *>*selectedPhotos; 
@property (nonatomic , strong, readonly) NSArray <DLTAssets *>*selectedVideos;
@property (nonatomic , assign, readonly) NSInteger selecteds;

@property (nonatomic , strong) UIButton *addButton;
@property(nonatomic,getter=isSelectedBeyond,readonly) BOOL selectedBeyond;

- (void)reloadPhotosView;
- (BOOL)isContainPhotoType; // 是否包含Photo类型的Asset
- (BOOL)isContainVideoType; // 是否包含Video类型的Asset

@end
