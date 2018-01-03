//
//  CircleoffriendCell.h
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"
#import "DLTCircleofFriendDynamicModel.h"
#import "SDTimeLineCellCommentView.h"
#import "SDWeiXinPhotoContainerView.h"

@class CircleoffriendCell;
@protocol DLTCircleoffriendCellDelegate <NSObject>

@required
 - (void)circleoffriendCell:(CircleoffriendCell *)cell didClickIndex:(CGFloat)index;

@optional
 - (void)circleoffriendCell:(CircleoffriendCell *)cell didMoreClick:(NSIndexPath *)indexPath;

@end

@interface CircleoffriendCell : BABaseCell

@property (nonatomic, weak) id<DLTCircleoffriendCellDelegate> circleFriendsDelegate;

@property (nonatomic, strong) DLTCircleofFriendDynamicModel  *model;

@end
