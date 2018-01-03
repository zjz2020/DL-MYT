//
//  DLTitleTableViewCell.m
//  Dlt
//
//  Created by Liuquan on 17/6/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTitleTableViewCell.h"


static NSString * const kTitleTableViewCellId = @"TitleTableViewCellId";

@implementation DLTitleTableViewCell

+ (instancetype)creatTitleCellWithTableView:(UITableView *)tableView {
    DLTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleTableViewCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLTitleTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
