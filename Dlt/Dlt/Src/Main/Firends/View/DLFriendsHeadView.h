//
//  DLFriendsHeadView.h
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLFriendsHeadView;

@protocol DLFriendsHeadViewDelegate <NSObject>
@optional
// 搜索好友
- (void)seachYourSelfFriendsWithNickName:(NSString *)nickName;

// 查看新朋友
- (void)checkYourSelfNewFriends;
// 取消搜索
- (void)cancleSearchFriends;
@end


@interface DLFriendsHeadView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, weak) id<DLFriendsHeadViewDelegate>delegate;

@end
