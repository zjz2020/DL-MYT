//
//  DLTransferAccountsTableViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLFriendsInfo;

@interface DLTransferAccountsTableViewController : UITableViewController

@property (nonatomic, strong) DLFriendsInfo *friendsInfo;
@property (nonatomic , strong)NSString *toID;
@end
