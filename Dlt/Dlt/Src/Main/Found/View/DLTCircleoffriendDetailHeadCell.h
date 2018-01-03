//
//  DLTCircleoffriendDetailHeadCell.h
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h" 
#import "DLTCircleofFriendDynamicModel.h"
#import "DLTCircleoffriendCellOperationView.h"

@class DLTCircleoffriendDetailHeadCell;
@protocol DLTCircleoffriendDetailHeadCellDelegate <NSObject>

@required
- (void)circleoffriendDetailHeadCell:(DLTCircleoffriendDetailHeadCell *)cell didClickIndex:(CGFloat)index;

@optional
/**
 点用户头像
 
 @param cell    self
 @param model  DLTGreatgodModel
 */
- (void)circleoffriendDetailHeadCell:(DLTCircleoffriendDetailHeadCell *)cell didTapAvatarView:(DLTCircleofFriendDynamicModel *)model;
@end

@interface DLTCircleoffriendDetailHeadCell : BABaseCell

@property (nonatomic, weak) id<DLTCircleoffriendDetailHeadCellDelegate> dltDelegate;

@property (nonatomic, strong) DLTCircleofFriendDynamicModel  *model;

@end
