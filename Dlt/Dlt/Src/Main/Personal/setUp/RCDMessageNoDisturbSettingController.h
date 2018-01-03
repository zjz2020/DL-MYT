//
//  RCDMessageNoDisturbSettingController.h
//  RCloudMessage
//
//  Created by 张改红 on 15/7/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DLMessageSetBlock)(NSString *msg);
@interface RCDMessageNoDisturbSettingController : UITableViewController
@property(nonatomic, strong) UISwitch *swch;
@property (nonatomic, copy) DLMessageSetBlock msgSetBlock;
@end
