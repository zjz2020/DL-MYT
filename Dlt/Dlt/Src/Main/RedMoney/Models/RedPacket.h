//
//  RedPacket.h
//  Dlt
//
//  Created by Fang on 2018/1/16.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPacket : NSObject
//钱数
@property(nonatomic, assign)NSInteger amount;
//维度
@property(nonatomic, copy)NSString *lat;
//经度
@property(nonatomic, copy)NSString *lon;
//红包ID
@property(nonatomic, assign)NSInteger rpid;
//用户ID
@property(nonatomic, assign)NSInteger uid;
//是否是红包
@property(nonatomic, assign,getter=redPacket)BOOL isRedPacket;
+ (RedPacket *)showRedPacket;
@end
