//
//  DLRedpackerDetailTableViewVC.h
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLRedpackerInfo,DLFriendPacketModel;


@interface DLRedpackerDetailTableViewVC : UITableViewController

@property (nonatomic, strong) DLRedpackerInfo *redpackerInfo;

@property (nonatomic, strong) DLFriendPacketModel *model;

@end
