//
//  DLTGreatgodTableViewCell.h
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BABaseCell.h"
#import "DLTGreatgodModel.h"

typedef NS_ENUM(NSInteger, DLTGreatgodEventType){
  DLTGreatgodEventTypeAddFriends,   // 添加好友
  DLTGreatgodEventTypeSendMessage   // 发送消息
};

@class DLTGreatgodTableViewCell;
@protocol DLTGreatgodTableViewCellDelegate <NSObject>

@required
/**
 点击Cell Button 事件

 @param cell self
 @param eventType 事件类型
 */
- (void)greatgodTableViewCell:(DLTGreatgodTableViewCell *)cell didClickButton:(DLTGreatgodEventType)eventType;


@optional
/**
 点击Photo 浏览视图 放大图片
 
 @param cell       self
 @param photos     photos图片数据模型
 @param imageViews 使用Pic生成的UIImageView数据
 @param index      当前点击的下标
 */
- (void)greatgodTableViewCell:(DLTGreatgodTableViewCell *)cell
           cellForPhotos:(NSArray <NSString *>*)photos
      cellForImageViews:(NSArray <UIImageView *>*)imageViews
didClickIndex:(NSInteger )index;


/**
 点用户头像

 @param cell    self
 @param model  DLTGreatgodModel
 */
- (void)greatgodTableViewCell:(DLTGreatgodTableViewCell *)cell didTapAvatarView:(DLTGreatgodModel *)model;

@end

@interface DLTGreatgodTableViewCell : BABaseCell

@property (nonatomic, weak)  id<DLTGreatgodTableViewCellDelegate>greatgodDelegate;

@property (nonatomic,strong, readonly) DLTGreatgodModel *model;

- (void)configureCellWithGreatgodModel:(DLTGreatgodModel *)model;

+ (CGFloat)sizeThatFits;

@end
