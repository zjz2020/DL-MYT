//
//  DLTitleTableViewCell.h
//  Dlt
//
//  Created by Liuquan on 17/6/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *underLine;

+ (instancetype)creatTitleCellWithTableView:(UITableView *)tableView;
@end
