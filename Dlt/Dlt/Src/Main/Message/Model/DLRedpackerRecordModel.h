//
//  DLRedpackerRecordModel.h
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLRedpackerRecordModel : DLTModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSArray *data;
@end

@interface DLRedpackerRecord : DLTModel
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *rpId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userHeadImg;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, assign) BOOL isBest;
@property (nonatomic, strong) NSString *userHead;
@property (nonatomic, assign) BOOL isFriendPacket;
@end
