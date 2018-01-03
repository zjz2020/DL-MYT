//
//  DLContactCardView.h
//  Dlt
//
//  Created by Liuquan on 17/6/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLFriendsInfo;

@protocol DLContactCardViewDelegate <NSObject>
@optional
- (void)contactCardView:(UIView *)cardView sendFriendCardToOtherWithUserInfo:(DLFriendsInfo *)userInfo andTheNote:(NSString *)note;

@end


@interface DLContactCardView : UIView

@property (nonatomic, weak) id<DLContactCardViewDelegate>delegate;

@property (nonatomic, strong) DLFriendsInfo *userInfo;

@property (nonatomic, copy) NSString *senderName;


+ (instancetype)shareInstance;

- (void)popAnimationView:(UIView *)supView;

@end
