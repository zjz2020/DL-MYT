//
//  DLExpressionMessage.h
//  Dlt
//
//  Created by USER on 2017/9/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
/*!
 类型名
 */
#define RCDTestMessageTypeIdentifier @"myt:FaceImg"
@interface DLExpressionMessage : RCMessageContent <NSCoding>

/*!
消息的内容
 */
@property(nonatomic, strong) NSString *content;

@property(nonatomic , strong)NSString *imgUri;

/*!
 初始化
 
 @param content 文本内容
 @return        消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end
