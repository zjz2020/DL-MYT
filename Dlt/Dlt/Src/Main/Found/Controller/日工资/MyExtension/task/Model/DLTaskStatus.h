//
//  DLTaskStatus.h
//  Dlt
//
//  Created by USER on 2017/9/23.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLTaskStatus : NSObject

@property (nonatomic , strong)NSString *status;
@property (nonatomic , strong)NSString *uid;
@property (nonatomic , strong)NSString *ID;
@property (nonatomic , strong)NSString *totalMoney;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *remainMonery;
@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)NSString *type;
@property (nonatomic , strong)NSString *pubTime;
@property (nonatomic , strong)NSString *tap_count;
@property (nonatomic , strong)NSString *promote_count;

@property (nonatomic , strong)NSString *promoteId;
@property (nonatomic , strong)NSString *time;
@property (nonatomic , strong)NSString *userHeadImg;
@property (nonatomic , strong)NSString *adid;
@property (nonatomic , strong)NSString *adStatus;
@property (nonatomic , strong)NSString *userName;
@property (nonatomic , strong)NSString *coverImg;
@end
