//
//  DLRedpacketMessage.h
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define DLRedpacketMessageTypeIdentify   @"DLT:RedpacketMsg"


@interface DLRedpacketMessage : RCMessageContent <RCMessageCoding,RCMessageContentView>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *packetId;

+ (instancetype)messageWithContent:(NSString *)content andRedpacketId:(NSString *)packetId;
@end
