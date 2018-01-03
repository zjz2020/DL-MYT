//
//  TranscationCell.h
//  Dlt
//
//  Created by USER on 2017/6/12.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"
@class TransactionrecordsinfoModel;

@interface TranscationCell : BABaseCell

@property (nonatomic, strong) TransactionrecordsinfoModel *model;


+ (instancetype)creatRecordCellWithTableView:(UITableView *)tableView;

@end
