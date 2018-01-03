//
//  RCDataManager.m
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
// 融云数据管理类

#import "RCDataManager.h"
#import "AppDelegate.h"
#import "MainTabbarViewController.h"

@interface RCDataManager ()


@end


@implementation RCDataManager
+ (RCDataManager *)shareManager {
    static RCDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)refreshBadgeValue {
    dispatch_async(dispatch_get_main_queue(), ^{
       NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
        UINavigationController *navi = [AppDelegate shareAppdelegate].mainViewController.viewControllers[0];
        if (unreadMsgCount == 0) {
            navi.tabBarItem.badgeValue = nil;
        } else {
            navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadMsgCount];
        }
    });
}

@end
