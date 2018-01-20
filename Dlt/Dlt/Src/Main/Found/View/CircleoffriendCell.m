//
//  CircleoffriendCell.m
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "CircleoffriendCell.h"
#import "DLTCircleoffriendCellOperationView.h"
#import "DltUICommon.h"
#import <RongIMKit/RCKitUtility.h>

#define contentLabelFontSize 14

@interface CircleoffriendCell (){
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_genderLable;
    UILabel *_timeLable;
    DLTCircleoffriendCellOperationView *_operationView;
    SDWeiXinPhotoContainerView *_picContainerView;
    SDTimeLineCellCommentView *_commentView;
    UIButton *_moreButton;
    UILabel *_placeholderLabel;
}

@property (nonatomic, strong) M80AttributedLabel *contentLabel;

@end

@implementation CircleoffriendCell

-(void)ba_setupCell{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundColor = [UIColor whiteColor];
}

-(void)ba_buildSubview{
   CGFloat margin = 15;
  
  _iconView = [UIImageView new];
  _iconView.image = [UIImage imageNamed:@"dlt_avatar_default_icon_old"];
  
  _nameLable = [UILabel new];
  _nameLable.font = [UIFont boldSystemFontOfSize:16];
  _nameLable.textColor = rgba(44, 44, 44, 1);
  
  _genderLable = [UILabel new];
  _genderLable.font = [UIFont boldSystemFontOfSize:12];
  _genderLable.textAlignment = NSTextAlignmentCenter;
  _genderLable.textColor = [UIColor whiteColor];
  _genderLable.backgroundColor = [UIColor clearColor];
  
   _timeLable = [UILabel new];
   _timeLable.font = [UIFont systemFontOfSize:14];
  _timeLable.textAlignment = NSTextAlignmentLeft;
   _timeLable.textColor = rgba(156, 156, 156, 1);
  
  M80AttributedLabel *attributedLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
  attributedLabel.lineSpacing = 3;
  attributedLabel.font =  [UIFont systemFontOfSize:contentLabelFontSize];
  self.contentLabel = attributedLabel;
  
  _operationView = [[DLTCircleoffriendCellOperationView alloc] init];
  @weakify(self);
   _operationView.OperationViewButtonClickedBlock = ^(NSInteger index){
     @strongify(self);
     if (self.circleFriendsDelegate && [self.circleFriendsDelegate respondsToSelector:@selector(circleoffriendCell:didClickIndex:)]) {
       [self.circleFriendsDelegate circleoffriendCell:self didClickIndex:index];
     }
   };
  
   _picContainerView = [[SDWeiXinPhotoContainerView alloc] initWithPhotoContainerView:SDWeiXinPhotoContainerViewTypeDefault];

  _commentView = [SDTimeLineCellCommentView new];
  
  _moreButton = [UIButton new];
  [_moreButton setTitle:@"查看更多的评论" forState:UIControlStateNormal];
  [_moreButton setTitleColor:rgb(0, 136, 241) forState:UIControlStateNormal];
   _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
  _moreButton.titleLabel.textAlignment = NSTextAlignmentLeft;
  [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  
  _placeholderLabel = [UILabel new];
  _placeholderLabel.backgroundColor = rgba(246, 246, 246, 1);
  
    NSArray *views = @[_iconView, _nameLable,_genderLable,_timeLable, _contentLabel,_picContainerView,_operationView,_commentView, _moreButton,_placeholderLabel];
    [self.contentView sd_addSubviews:views];
  
   CGFloat content_width = kScreenWidth - 2*margin;
    UIView *contentView = self.contentView;
  
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, 10)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(25);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:150];
  
    _genderLable.sd_layout
    .widthIs(35)
    .heightRatioToView(_nameLable,.6)
    .leftSpaceToView(_nameLable,margin)
    .centerYEqualToView(_nameLable);
  
    _timeLable.sd_layout
    .leftEqualToView(_nameLable)
    .bottomEqualToView(_iconView)
    .widthIs(200)
    .heightIs(15);
  
  _contentLabel.sd_layout
  .leftEqualToView(_iconView)
  .topSpaceToView(_iconView, margin)
  .widthIs(content_width);
  
  _contentLabel.numberOfLines = 12;
//    [_contentLabel setMaxNumberOfLinesToShow:12];
  
    _picContainerView.sd_layout
   .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
  
  _operationView.sd_layout
  .leftEqualToView(_contentLabel)
  .topSpaceToView(_picContainerView,margin)
  .rightEqualToView(_contentLabel)
  .heightIs(40);
  

//  _commentView.sd_layout
//  .leftEqualToView(_contentLabel)
//  .rightSpaceToView(contentView, margin);// 已经在内部实现高度自适应所以不需要再设置高度
  _commentView.sd_layout
  .leftEqualToView(_contentLabel)
  .widthIs(content_width);
  
  [_moreButton sizeToFit];
  _moreButton.sd_layout
  .topSpaceToView(_commentView,0)
  .leftEqualToView(_commentView)
  .widthIs(_moreButton.width);
  
  _placeholderLabel.sd_layout
  .leftEqualToView(contentView)
  .topSpaceToView(_moreButton,0.f)
  .rightEqualToView(contentView)
  .heightIs(10);  
}

#pragma makr - 

- (void)prepareForReuse{
  [super prepareForReuse];
  
  [_iconView cancelCurrentImageRequest];
  [_picContainerView prepareForReuse];
}

- (void)setModel:(DLTCircleofFriendDynamicModel *)model{
    _model = model;
  
  NSString *headURL = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg];
  if (!ISNULLSTR(model.headImg)) {
    [_iconView sd_setImageWithURL:DLT_URL(headURL)
                 placeholderImage:[UIImage imageNamed:@"dlt_avatar_default_icon_old"]];
  }
  
  _nameLable.text = model.remark;
  [_nameLable sizeToFit];   // 防止单行文本label在重用时宽度计算不准的问题
  _timeLable.text = [RCKitUtility ConvertMessageTime:[model.timeStamp longLongValue]];
  
  CGFloat contentHeight = model.contentSize.CGSizeValue.height;
  [DltEmoUtils drawM80Label:_contentLabel withSourceString:model.text];
  _contentLabel.fixedHeight = @(contentHeight);
  
  
  CGFloat picContainerTopMargin = model.picNames.count? 10 : 0;
  _picContainerView.picPathStringsArray = model.picNames;
  _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
  
  _operationView.liked = model.liked;
  _operationView.comments = model.comments.count;
  _operationView.likeds = model.likes.count;
  _operationView.hiddenLine = (model.comments.count)? NO: YES;
  _operationView.hiddenMoreBtn = model.hiddenOperationMoreButton;

   NSArray *displayComments = nil;
   if (model.shouldShowMoreButton) { // 评论超过3
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    displayComments = [model.comments objectsAtIndexes:set];
   }else{
     displayComments = model.comments;
   }
    _commentView.frame = CGRectZero;
    [_commentView setupWithLikeItemsArray:model.likes commentItemsArray:displayComments];
   _commentView.sd_layout.topSpaceToView(_operationView, 0);

    if (!model.comments.count && !model.likes.count) {
        _commentView.fixedWidth = @0; // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        _commentView.fixedHeight = @0; // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
    } else {
        _commentView.fixedHeight = nil; // 取消固定宽度约束
        _commentView.fixedWidth = nil; // 取消固定高度约束
    }
  
  if (model.shouldShowMoreButton){
     _moreButton.sd_layout.heightIs(25);
      _moreButton.hidden = NO;
  }else{
    _moreButton.sd_layout.heightIs(0);
    _moreButton.hidden = YES;
  }
  
    [self setupAutoHeightWithBottomView:_placeholderLabel bottomMargin:0];
}

#pragma mark - private actions

- (void)moreButtonClicked{
  if (self.circleFriendsDelegate && [self.circleFriendsDelegate respondsToSelector:@selector(circleoffriendCell:didMoreClick:)]) {
    [self.circleFriendsDelegate circleoffriendCell:self didMoreClick:self.indexPath];
  }
}



@end
