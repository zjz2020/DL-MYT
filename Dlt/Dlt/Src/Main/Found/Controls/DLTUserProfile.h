//
//  DLTUserProfile.h
//  Dlt
//
//  Created by Gavin on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLTUserProfile : DLTModel

@property (nonatomic, copy  ) NSString  *account;
@property (nonatomic, copy  ) NSString  *phone;
@property (nonatomic, copy  ) NSString  *area;
@property (nonatomic, copy  ) NSString  *userName;
@property (nonatomic, copy  ) NSString  *note;
@property (nonatomic, copy  ) NSString  *emotion;
@property (nonatomic, copy  ) NSString  *profession;
@property (nonatomic, copy  ) NSString  *birthday;
@property (nonatomic, copy  ) NSString  *bgImg;
@property (nonatomic, copy  ) NSString  *photos;
@property (nonatomic, copy  ) NSString  *userHeadImg;
@property (nonatomic, copy  ) NSString  *balance;// 余额
@property (nonatomic, copy  ) NSString  *uid;
@property (nonatomic, copy  ) NSString  *token;
@property (nonatomic, assign) BOOL    sex;
@property (nonatomic, assign) BOOL isFriend;

@property (nonatomic, strong) NSArray<NSString *> *photoNames;

@end
