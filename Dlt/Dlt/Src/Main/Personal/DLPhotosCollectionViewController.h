//
//  DLPhotosCollectionViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLPhotosItem;

@protocol DLPhotosItemDelegate <NSObject>
@required
- (void)photosItem:(DLPhotosItem *)item longPressItemWithItemTag:(NSInteger)tag;

@end


@interface DLPhotosItem : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<DLPhotosItemDelegate>delegate;
@end



@interface DLPhotosCollectionViewController : UICollectionViewController

@end
