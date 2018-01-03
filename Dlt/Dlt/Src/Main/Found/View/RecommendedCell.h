//
//  RecommendedCell.h
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTRecommendModel.h"

typedef NS_ENUM(NSInteger, DLTRecommendedEventType){
  DLTRecommendedEventTypeAddFriends,   // 添加好友
  DLTRecommendedEventTypeSendMessage,  // 发送消息
  DLTRecommendedEventTypeClickAvatar,  // 点击头像
};

@class RecommendedCell;
@protocol RecommendedCellDelegate <NSObject>

@required
/**
 点击Cell Button 事件
 
 @param cell self
 @param eventType 事件类型
 */
- (void)recommendedCell:(RecommendedCell *)cell didClickButton:(DLTRecommendedEventType)eventType;

@end

@interface RecommendedCell : UITableViewCell

@property (nonatomic, weak)  id<RecommendedCellDelegate>delegate;

@property (nonatomic, strong, readonly) DLTRecommendModel *model;

- (void)configurationCellForModel:(DLTRecommendModel *)model;

@end
