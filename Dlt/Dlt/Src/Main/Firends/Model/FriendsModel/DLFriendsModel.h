//
//  DLFriendsModel.h
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLFriendsModel : DLTModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;

@end

@interface DLFriendsInfo : DLTModel
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *note;

/// 在没在那个群里面
@property (nonatomic, assign) BOOL isJoined;

/// 选中的好友
@property (nonatomic, assign) BOOL isSelectedMember;
@end
