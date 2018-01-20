//
//  SDTimeLineCellCommentView.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 17/2/7.
//  Copyright © 2017年 GSD. All rights reserved.

#import "SDTimeLineCellCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "DLTCircleofFriendDynamicModel.h"
#import "DltEmoUtils.h"
#import "DltUICommon.h"

@interface SDTimeLineCellCommentView ()

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;


@end

@implementation SDTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setupViews];
  }
  return self;
}

- (void)setupViews
{
  _bgImageView = [UIImageView new];
  UIImage *bgImage = [[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
  _bgImageView.image = bgImage;
  [self addSubview:_bgImageView];
  
  _likeLabel = [UILabel new];
  [self addSubview:_likeLabel];
  
  _likeLableBottomLine = [UIView new];
  _likeLableBottomLine.backgroundColor = [UIColor lightGrayColor];
  [self addSubview:_likeLableBottomLine];
  
  _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
  _commentItemsArray = commentItemsArray;
  
  long originalLabelsCount = self.commentLabelsArray.count;
  long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
  for (int i = 0; i < needsToAddCount; i++) {
    M80AttributedLabel *label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
    label.lineSpacing = 3;
    label.font = [UIFont systemFontOfSize:14];
  
    [self addSubview:label];
    [self.commentLabelsArray addObject:label];
  }
  
  for (int i = 0; i < commentItemsArray.count; i++) {
    DLTCircleofFriendDynamicCommentModel *model = commentItemsArray[i];
    M80AttributedLabel *label = self.commentLabelsArray[i];
     [DltEmoUtils drawCommoneM80Label:label withTimeLineCellCommentItemModel:model];
  }
} 

- (NSMutableArray *)commentLabelsArray
{
  if (!_commentLabelsArray) {
    _commentLabelsArray = [NSMutableArray new];
  }
  return _commentLabelsArray;
}

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
  self.likeItemsArray = likeItemsArray;
  self.commentItemsArray = commentItemsArray;
  
  [_likeLabel sd_clearAutoLayoutSettings];
  _likeLabel.frame = CGRectZero;
  
  
  if (self.commentLabelsArray.count) {
    [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
      [label sd_clearAutoLayoutSettings];
      label.frame = CGRectZero;
    }];
  }
  
  CGFloat margin = 5;
  
  if (likeItemsArray.count) {
    _likeLabel.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, margin)
    .autoHeightRatio(0);
    
    _likeLabel.isAttributedContent = YES;
  }
  
  UIView *lastTopView = _likeLabel;

  for (int i = 0; i < self.commentItemsArray.count; i++) {
    M80AttributedLabel *label = (M80AttributedLabel *)self.commentLabelsArray[i];
    CGFloat topMargin = i == 0 ? 10 : 5;
    
    DLTCircleofFriendDynamicCommentModel *model = commentItemsArray[i];
  
    label.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 5)
    .topSpaceToView(lastTopView, topMargin)
    .heightIs(model.commentSize.CGSizeValue.height);

    lastTopView = label;
    
  }

  [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
  
}


@end

