//
//  DLOtherUserModel.h
//  Dlt
//
//  Created by Liuquan on 17/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"
@class DLOtherUserInfo;

@interface DLOtherUserModel : DLTModel
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) DLOtherUserInfo*data;
@end

@interface DLOtherUserInfo : DLTModel
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *userName;
@end
