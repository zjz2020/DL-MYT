//
//  DLRedpackerDetailCel.h
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLRedpackerRecord;


@interface DLRedpackerDetailCell : UITableViewCell

@property (nonatomic, strong) DLRedpackerRecord *recordModel;


+ (instancetype)creatRedpackerCellWithTableView:(UITableView *)tableView;

@end
