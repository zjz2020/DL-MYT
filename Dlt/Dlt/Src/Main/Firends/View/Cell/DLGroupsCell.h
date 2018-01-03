//
//  DLGroupsCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGroupsInfo;


@interface DLGroupsCell : UITableViewCell

@property (nonatomic, strong) DLGroupsInfo *groupInfo;

+ (instancetype)creatGroupCellWithTableView:(UITableView *)tableView;

@end
