//
//  DLUserInfoSectionView.h
//  Dlt
//
//  Created by Liuquan on 17/6/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLUserInfoSectionView;

@protocol DLUserInfoSectionViewDelegate <NSObject>
@optional
- (void)userInfoSectionView:(DLUserInfoSectionView *)sectionView clickButtonWithIndex:(NSInteger)index;

@end

@interface DLUserInfoSectionView : UIView

@property (nonatomic, strong) UIView *underLine;
@property (nonatomic, strong) UIButton *filesBtn;
@property (nonatomic, strong) UIButton *dynamicBtn;

@property (nonatomic, weak) id<DLUserInfoSectionViewDelegate>delegate;

@end
