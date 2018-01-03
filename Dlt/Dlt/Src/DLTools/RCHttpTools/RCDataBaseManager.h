//
//  RCDataBaseManager.h
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
///  融云数据存储
#import <Foundation/Foundation.h>


@interface RCDataBaseManager : NSObject

+ (RCDataBaseManager *)shareInstance;

- (void)closeDBForDisconnect;

///存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user;

/// 更新用户信息
//- (void)updateUserInfo:(RCUserInfo *)user;

///存储用户好友列表信息
- (void)insertUserListToDB:(NSMutableArray *)userList;

///从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId;

/// 从表中获取好友列表
- (NSArray *)getFriendsList;

/// 存储用户群组列表
- (void)insertGroupListToDB:(NSMutableArray *)groupList;

/// 获取群信息
- (RCGroup *)getGroupInfoByGroupId:(NSString *)groupId;

/// 从表中获取所有群组
- (NSArray *)getGroupList;

//清空好友缓存数据
- (void)clearFriendsData;


@end
