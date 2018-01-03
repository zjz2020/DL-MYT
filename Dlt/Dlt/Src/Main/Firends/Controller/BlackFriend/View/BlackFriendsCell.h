//
//  BlackFriendsCell.h
//  Dlt
//
//  Created by USER on 2017/8/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BlackFriendStatus.h"
@class BlackFriendStatus;
@interface BlackFriendsCell : UITableViewCell
@property(nonatomic , strong)BlackFriendStatus *status;
@end
