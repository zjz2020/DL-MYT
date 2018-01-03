//
//  DLFriendPacketModel.h
//  Dlt
//
//  Created by Liuquan on 17/6/16.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLFriendPacketModel : DLTModel
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, assign) BOOL isGet;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *rpId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userHead;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic ,assign)NSInteger expired;

@end

@interface DLFriendPacketStateModel : DLTModel
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *isGet;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *rpId;
@end

