//
//  DLTGreatgodModel.h
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTSaveModel.h"

@interface DLTGreatgodModel : DLTSaveModel

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *blance;
@property (nonatomic, copy) NSString *photos;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL   sex;      // true 男 false 女
@property (nonatomic, assign) BOOL   isFriend; // true 是好友 false 不是好友
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *sexStr; 

@property (nonatomic, strong) NSArray<NSString *> *photoNames;

@end
