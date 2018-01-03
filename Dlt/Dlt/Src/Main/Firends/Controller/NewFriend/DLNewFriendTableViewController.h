//
//  DLNewFriendTableViewController.h
//  Dlt
//
//  Created by Liuquan on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BaseTableViewController.h"

@interface DLNewFriendTableViewController : BaseTableViewController

// 记录id 用来同意拒绝
@property (nonatomic, strong) NSString *recordId;

// 用户id 用来获取用户信息
@property (nonatomic, strong) NSString *requestUserId;

@property (nonatomic, assign) BOOL isGroupRequest;
@property (nonatomic , strong)NSString *groupName;

@end
