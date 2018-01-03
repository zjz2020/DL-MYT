//
//  DLTransferMessage.h
//  Dlt
//
//  Created by USER on 2017/11/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#define RCTransferMessageTypeIdentifier @"DLT:WtMsg"
@interface DLTransferMessage : RCMessageContent<NSCoding>
/*!
 消息的内容
 */
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *extra;
@end
