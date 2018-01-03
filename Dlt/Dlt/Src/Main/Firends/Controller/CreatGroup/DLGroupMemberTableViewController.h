//
//  DLGroupMemberTableViewController.h
//  Dlt
//
//  Created by Liuquan on 17/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BaseTableViewController.h"

@interface DLGroupMemberTableViewController : BaseTableViewController

@property (nonatomic, strong) NSString *groupId;

@property (nonatomic, assign) BOOL isManager;

@property (nonatomic , assign)BOOL isAdmin;//管理

@property (nonatomic , assign)BOOL isMainGrouper;//群主

@end
