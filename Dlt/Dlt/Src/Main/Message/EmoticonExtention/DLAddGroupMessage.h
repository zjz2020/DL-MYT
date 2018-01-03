//
//  DLAddGroupMessage.h
//  Dlt
//
//  Created by USER on 2017/11/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
/*!
 类型名
 */
#define RCDaddGroupMessageTypeIdentifier @"DLT:GROUP_ADD"

@interface DLAddGroupMessage : RCMessageContent<NSCoding>
/*!
 消息的内容
 */
@property(nonatomic ,strong)NSString *content;
@property(nonatomic ,strong)NSString *extra;
@property(nonatomic, strong) NSString *gqId;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *groupName;
@property (nonatomic , strong)NSString *fromName;

@end
