//
//  DLGroupsModel.h
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLGroupsModel : DLTModel
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSMutableArray *data;
@end


@interface DLGroupsInfo : DLTModel
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *name;       // 搜索群组里面用
@property (nonatomic, strong) NSString *groupName;  // 群组里面用
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, assign) BOOL isMember;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *imgs;
@property (nonatomic, strong) NSString *count;
@end
