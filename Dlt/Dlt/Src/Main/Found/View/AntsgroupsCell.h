//
//  AntsgroupsCell.h
//  Dlt
//
//  Created by USER on 2017/5/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
#import "DLGroupsModel.h"

@interface AntsgroupsCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t applyToGroup_block_t;
@property (nonatomic, copy) dispatch_block_t clickGroupAvatar_block_t;

- (void)configurationCellForModel:(DLGroupsInfo *)model;

@end
