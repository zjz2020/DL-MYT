//
//  DLUserInfoHeadView.h
//  Dlt
//
//  Created by Liuquan on 17/6/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLUserInfoHeadView;

@protocol DLUserInfoHeadViewDelegate <NSObject>
@optional
- (void)userInfoHeadView:(DLUserInfoHeadView *)headView clickButtonWithIndex:(NSInteger)index;
- (void)setFriendsPermissions;
-(void)ReportUser;
@end

@interface DLUserInfoHeadView : UIView

@property (nonatomic, strong) UIView *underLine;
@property (nonatomic, strong) UIButton *filesBtn;
@property (nonatomic, strong) UIButton *dynamicBtn;


@property (nonatomic, weak) id<DLUserInfoHeadViewDelegate>delegate;

@property (nonatomic, strong) DLTUserProfile *model;

@end
