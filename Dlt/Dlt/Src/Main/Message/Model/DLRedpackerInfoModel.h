//
//  DLRedpackerInfoModel.h
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"
@class DLRedpackerInfo;

@interface DLRedpackerInfoModel : DLTModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) DLRedpackerInfo *data;

@end

@interface DLRedpackerInfo : DLTModel

@property (nonatomic, assign) BOOL isGet;
@property (nonatomic, assign) NSInteger myGetAmount;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *userHeadImg;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger remainCount;
@property (nonatomic, assign) NSInteger rpId;
@property (nonatomic, assign) NSInteger totalAmount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic ,assign) NSInteger expired;

@end
