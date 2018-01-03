//
//  DLTCircleoffriendDetailCommentCell.h
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"
#import "DLTCircleofFriendDynamicModel.h"

@class DLTCircleoffriendDetailCommentCell;
@protocol DLTCircleoffriendDetailCommentDelegate <NSObject>

@optional
/**
 点击 cell
 
 @param cell    self
 @param model  DLTGreatgodModel
 */
- (void)circleoffriendDetailCommentCell:(DLTCircleoffriendDetailCommentCell *)cell didClickCell:(DLTCircleofFriendDynamicCommentModel *)model;

/**
 点用户头像
 
 @param cell    self
 @param model  DLTGreatgodModel
 */
- (void)circleoffriendDetailCommentCell:(DLTCircleoffriendDetailCommentCell *)cell didTapAvatarView:(DLTCircleofFriendDynamicCommentModel *)model;

@end

@interface DLTCircleoffriendDetailCommentCell : BABaseCell

@property (nonatomic, weak) id<DLTCircleoffriendDetailCommentDelegate> dltCommentDelegate;

@property (nonatomic, strong) DLTCircleofFriendDynamicModel  *fModel;
@property (nonatomic, strong) DLTCircleofFriendDynamicCommentModel  *model;

+ (CGFloat)CalculateCellHeight:(DLTCircleofFriendDynamicCommentModel *)model;

@end
