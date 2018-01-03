//
//  DLGroupNotifyMessage.h
//  Dlt
//
//  Created by Liuquan on 17/6/6.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface DLGroupNotifyMessage : RCTextMessage

@property (nonatomic, strong) NSString *pushData;
@property (nonatomic, strong) NSString *pushContent;

@end
