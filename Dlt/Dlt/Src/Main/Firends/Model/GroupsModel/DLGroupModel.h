//
//  DLGroupModel.h
//  Dlt
//
//  Created by Liuquan on 17/6/5.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"
@class DLGroupInfo;

@interface DLGroupModel : DLTModel
@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) DLGroupInfo *data;
@end

@interface DLGroupInfo : DLTModel
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgs;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *remark;
@end
