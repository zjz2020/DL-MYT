//
//  TransactionrecordsModel.h
//  Dlt
//
//  Created by USER on 2017/6/12.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"
@interface TransactionrecordsModel : DLTModel
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@end
@interface TransactionrecordsinfoModel : DLTModel
@property(nonatomic,strong)NSString * tranName;
@property(nonatomic,strong)NSString * tranNum;
@property(nonatomic,strong)NSString * tranBalance;
@property(nonatomic,strong)NSString * tranTime;
@property(nonatomic,strong)NSString * tranType;

@end
