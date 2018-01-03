//
//  DLTCircleoffriendDetailCommentCell.m
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTCircleoffriendDetailCommentCell.h"
#import "DltUICommon.h"
#import <DateTools/NSDate+DateTools.h>
#import <RongIMKit/RCKitUtility.h>

@interface DLTCircleoffriendDetailCommentCell () {
  UIImageView *_iconView;
  UILabel *_nameLable;
  UILabel *_genderLable;
  UILabel *_timeLable;
}

@property (nonatomic, strong) M80AttributedLabel *contentLabel;

@end

@implementation DLTCircleoffriendDetailCommentCell

- (void)didTapAvatarView{
  if (self.dltCommentDelegate && [self.dltCommentDelegate respondsToSelector:@selector(circleoffriendDetailCommentCell:didTapAvatarView:)]) {
    [self.dltCommentDelegate circleoffriendDetailCommentCell:self didTapAvatarView:self.model];
  }
}

- (void)didCellView{
  if (self.dltCommentDelegate && [self.dltCommentDelegate respondsToSelector:@selector(circleoffriendDetailCommentCell:didClickCell:)]) {
    [self.dltCommentDelegate circleoffriendDetailCommentCell:self didClickCell:self.model];
  }
}

-(void)ba_setupCell{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundColor = [UIColor whiteColor];
}

- (void)ba_buildSubview{
  CGFloat margin = 15;
  
  @weakify(self);
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
    @strongify(self);
    [self didCellView];
  }];
  [self addGestureRecognizer:tap];
  
  _iconView = [UIImageView new];
  _iconView.image = [UIImage imageNamed:@"dlt_avatar_default_icon_old"];
    [_iconView ui_imageViewAddGestureRecognizerTarget:self action:@selector(didTapAvatarView)];
  
  _nameLable = [UILabel new];
  _nameLable.font = [UIFont boldSystemFontOfSize:16];
  _nameLable.textColor = SDColor(44, 44, 44, 1);
  
  _genderLable = [UILabel new];
  _genderLable.font = [UIFont boldSystemFontOfSize:12];
  _genderLable.textAlignment = NSTextAlignmentCenter;
  _genderLable.textColor = [UIColor whiteColor];
  _genderLable.backgroundColor = [UIColor clearColor];
  
  _timeLable = [UILabel new];
  _timeLable.font = [UIFont systemFontOfSize:14];
  _timeLable.textAlignment = NSTextAlignmentRight;
  _timeLable.textColor = SDColor(156, 156, 156, 1);
  
  M80AttributedLabel *attributedLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
  attributedLabel.lineSpacing = 3;
  attributedLabel.font =  [UIFont systemFontOfSize:14];
  attributedLabel.numberOfLines = 6;
  self.contentLabel = attributedLabel;
  
  
  NSArray *views = @[_iconView, _nameLable,_genderLable,_timeLable, _contentLabel];
  [self.contentView sd_addSubviews:views];
  
  UIView *contentView = self.contentView;

  // layout
  _iconView.sd_layout
  .leftSpaceToView(contentView, margin)
  .topSpaceToView(contentView, 10)
  .widthIs(40)
  .heightIs(40);
  
  _nameLable.sd_layout
  .leftSpaceToView(_iconView, margin)
  .topEqualToView(_iconView)
  .heightIs(24);
  [_nameLable setSingleLineAutoResizeWithMaxWidth:150];
  
  _genderLable.sd_layout
  .widthIs(38)
  .heightIs(16)
  .leftSpaceToView(_nameLable,margin)
  .centerYEqualToView(_nameLable);
  
  _timeLable.sd_layout
  .leftSpaceToView(_genderLable,margin)
  .rightSpaceToView(contentView,10)
  .centerYEqualToView(_nameLable)
  .heightIs(24);
  
  
  _contentLabel.sd_layout
  .leftEqualToView(_nameLable)
  .topSpaceToView(_nameLable, 0)
  .rightEqualToView(_timeLable);
}

#pragma makr -

- (void)setModel:(DLTCircleofFriendDynamicCommentModel *)model{
  _model = model;
  
  NSString *headURL = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.userImg];
  if (!ISNULLSTR(headURL)) {
    [_iconView sd_setImageWithURL:DLT_URL(headURL)
                 placeholderImage:[UIImage imageNamed:@"dlt_avatar_default_icon_old"]];
  }
  
  _nameLable.text = model.userName;
  // 防止单行文本label在重用时宽度计算不准的问题
  [_nameLable sizeToFit];
  
  _genderLable.hidden = YES;
//  _genderLable.text = [NSString stringWithFormat:@"%@ %@",model.sex,model.age];
//  _genderLable.backgroundColor = model.isBoy? rgb(248, 181, 194) :rgb(54,131,200);
  _timeLable.text =  [RCKitUtility ConvertMessageTime:[model.createTimeStamp longLongValue]];

  [DltEmoUtils drawM80Label:_contentLabel withSourceString:model.text];
  _contentLabel.fixedHeight = @(model.commentDetailsSize.CGSizeValue.height);

  [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:0];
}

+ (CGFloat)CalculateCellHeight:(DLTCircleofFriendDynamicCommentModel *)model{
  CGFloat height = 15;
  height += 40*.6;
  height += model.commentDetailsSize.CGSizeValue.height;
  
  return height;
}

@end
