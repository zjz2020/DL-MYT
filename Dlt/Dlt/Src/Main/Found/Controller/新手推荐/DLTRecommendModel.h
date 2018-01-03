//
//  DLTRecommendModel.h
//  Dlt
//
//  Created by Gavin on 2017/6/9.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLTRecommendModel : DLTModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *sexStr;
@property (nonatomic, assign) BOOL isFriend;

@end
