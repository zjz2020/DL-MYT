//
//  DLGroupMemberCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGroupMemberInfo;

typedef void(^DLGroupMemberHeadImgBlock)(DLGroupMemberInfo *info);
@interface DLGroupMemberCell : UITableViewCell

@property (nonatomic, strong) DLGroupMemberInfo *infoModel;

@property (nonatomic, copy) DLGroupMemberHeadImgBlock headImgBlock;

+ (instancetype)creatGroupMemberCellWith:(UITableView *)tableView;

@end
