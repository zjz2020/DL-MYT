//
//  DLMyFriendsListViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSendContactCardMessageNotificationName;

@interface DLMyFriendsListViewController : UITableViewController

@property (nonatomic, strong) DLTUserProfile *model;

@property (nonatomic, copy) NSString *otherUserId;

@end
