//
//  DLTGreatgodPhotoContainerView.h
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTGreatgodPhotoContainerView : UIView

@property (nonatomic, strong) NSArray  *picPathStringsArray;

@property (nonatomic, copy) void (^DLTGreatgodPhotoContainerBlock)(NSArray <NSString *>*photos,NSArray <UIImageView *>*ImageViews,NSInteger index);

- (void)prepareForReuse;

@end
