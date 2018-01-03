//
//  DLSeachGroupsCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGroupsInfo;


@interface DLSeachGroupsCell : UITableViewCell

@property (nonatomic, strong) DLGroupsInfo *infoModel;

+ (instancetype)creatSeachGroupCellWithTableView:(UITableView *)tableView;

@end
