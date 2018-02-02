//
//  DLGroupMemberModel.h
//  Dlt
//
//  Created by Liuquan on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLGroupMemberModel : DLTModel
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSMutableArray *data;
@end

@interface DLGroupMemberInfo : DLTModel
@property (nonatomic, strong) NSString *GroupId;
@property (nonatomic, strong) NSString *Remrk;
@property (nonatomic, strong) NSString *Role;
@property (nonatomic, strong) NSString *Uid;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) BOOL isSetManager;
//添加首字母
@property (nonatomic, copy) NSString *firstLetter;
@end
