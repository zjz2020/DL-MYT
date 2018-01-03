//
//  ConversationViewController.h
//  Dlt
//
//  Created by USER on 2017/5/24.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ConversationViewController : RCConversationViewController

/**
 *  会话数据模型
 */
@property(strong, nonatomic) RCConversationModel *conversation;

@end
