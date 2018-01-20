//
//  DLFriendsSetTableViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLFriendsInfo;


extern NSString * const kRefreshFriendsListNoticationName;

@interface DLFriendsSetTableViewController : UIViewController

@property (nonatomic, copy) NSString *otherUserId;

@property (nonatomic, strong) DLTUserProfile *model;

@property (nonatomic , assign)BOOL isBlackFriend;
@property (nonatomic , assign)BOOL isUpButton;
@end
