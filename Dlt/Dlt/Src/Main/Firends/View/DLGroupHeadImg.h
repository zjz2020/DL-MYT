//
//  DLGroupHeadImg.h
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGroupImageCell,DLGroupHeadImg;

@protocol DLGroupHeadImgDelegate <NSObject>
@optional
- (void)groupHeadImg:(DLGroupHeadImg *)headImgCell deleteOrSetImage:(NSInteger)index;
- (void)addMoreHeadImage;
@end
@interface DLGroupHeadImg : UITableViewCell

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) id<DLGroupHeadImgDelegate>delegate;
@end




@protocol DLGroupImageCellDelegate <NSObject>
@optional
- (void)groupImageCell:(DLGroupImageCell *)cell longPressImageView:(NSInteger)index;
@end

@interface DLGroupImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id<DLGroupImageCellDelegate>delegate;

@end

