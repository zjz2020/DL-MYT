//
//  DLTCircleoffriendDetailHeadCell.m
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTCircleoffriendDetailHeadCell.h"
#import "SDTimeLineCellCommentView.h"
#import "SDWeiXinPhotoContainerView.h"
#import "DltUICommon.h"
#import <RongIMKit/RCKitUtility.h>

@interface DLTCircleoffriendDetailHeadCell (){
  UIImageView *_iconView;
  UILabel *_nameLable;
  UILabel *_genderLable;
  UILabel *_timeLable;  
  SDWeiXinPhotoContainerView *_picContainerView;

  UILabel *_placeholderLabel;
  UIView  *_commentTitlePlaceholderView;
}

@property (nonatomic, strong) M80AttributedLabel *contentLabel;
@property (nonatomic, strong, readwrite) DLTCircleoffriendCellOperationView *operationView;

@end

@implementation DLTCircleoffriendDetailHeadCell

- (void)didTapAvatarView{
  if (self.dltDelegate && [self.dltDelegate respondsToSelector:@selector(circleoffriendDetailHeadCell:didTapAvatarView:)]) {
    [self.dltDelegate circleoffriendDetailHeadCell:self didTapAvatarView:self.model];
  }
}

-(void)ba_setupCell{ 
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundColor = [UIColor whiteColor];
}

- (void)ba_buildSubview{
  CGFloat margin = 15;
  
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
  _timeLable.textAlignment = NSTextAlignmentLeft;
  _timeLable.textColor = rgba(156, 156, 156, 1);
  
  M80AttributedLabel *attributedLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
  attributedLabel.lineSpacing = 3;
  attributedLabel.font =  [UIFont systemFontOfSize:14];
  attributedLabel.numberOfLines = 6;
  self.contentLabel = attributedLabel;
  
  _picContainerView = [[SDWeiXinPhotoContainerView alloc] initWithPhotoContainerView:SDWeiXinPhotoContainerViewTypeDetails];
  
  _operationView = [[DLTCircleoffriendCellOperationView alloc] init];
  @weakify(self);
  _operationView.OperationViewButtonClickedBlock = ^(NSInteger index){
    @strongify(self);
    if (self.dltDelegate && [self.dltDelegate respondsToSelector:@selector(circleoffriendDetailHeadCell:didClickIndex:)]) {
      [self.dltDelegate circleoffriendDetailHeadCell:self didClickIndex:index];
    }
  };
  
  
  _placeholderLabel = [UILabel new];
  _placeholderLabel.backgroundColor = SDColor(246, 246, 246, 1);
  
  _commentTitlePlaceholderView = [UIView new];
  _commentTitlePlaceholderView.backgroundColor = [UIColor whiteColor];
  UILabel *commentTitleLabel = [UILabel new];
  commentTitleLabel.text = @"评论";
  commentTitleLabel.font = [UIFont systemFontOfSize:14];
  commentTitleLabel.textColor = rgb(44, 44, 44);
  [_commentTitlePlaceholderView addSubview:commentTitleLabel];
  
  [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(margin+ 5);
    make.width.mas_equalTo(100);
    make.height.mas_equalTo(40);
    make.centerY.equalTo(_commentTitlePlaceholderView);
  }];
  
  NSArray *views = @[_iconView, _nameLable,_genderLable,_timeLable, _contentLabel,_picContainerView,_operationView,_placeholderLabel,_commentTitlePlaceholderView];
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
  .heightIs(24);
  [_nameLable setSingleLineAutoResizeWithMaxWidth:150];
  
  _genderLable.sd_layout
  .widthIs(38)
  .heightIs(18)
  .leftSpaceToView(_nameLable,margin)
  .centerYEqualToView(_nameLable);
  
  _timeLable.sd_layout
  .leftEqualToView(_nameLable)
  .heightIs(16)
  .bottomEqualToView(_iconView)
  .widthIs(200);
  
  _contentLabel.sd_layout
  .leftEqualToView(_iconView)
  .topSpaceToView(_iconView, margin)
  .widthIs(content_width);
  _contentLabel.numberOfLines = 12;
  
  _picContainerView.sd_layout
  .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
  
  _operationView.sd_layout
  .leftEqualToView(_contentLabel)
  .topSpaceToView(_picContainerView,margin)
  .rightEqualToView(_contentLabel)
  .heightIs(50);
  
  _placeholderLabel.sd_layout
  .leftEqualToView(contentView)
  .topSpaceToView(_operationView,0.f)
  .rightEqualToView(contentView)
  .heightIs(10);
  
  _commentTitlePlaceholderView.sd_layout
  .leftEqualToView(contentView)
  .topSpaceToView(_placeholderLabel,0.f)
  .rightEqualToView(contentView)
  .heightIs(40);
}


#pragma makr -

- (void)setModel:(DLTCircleofFriendDynamicModel *)model{
  _model = model;
  
  NSString *headURL = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg];
  if (!ISNULLSTR(headURL)) {
    [_iconView sd_setImageWithURL:DLT_URL(headURL)
                 placeholderImage:[UIImage imageNamed:@"dlt_avatar_default_icon_old"]];
  }
  
  _nameLable.text = model.remark;
  // 防止单行文本label在重用时宽度计算不准的问题
  [_nameLable sizeToFit];
  
//  _genderLable.backgroundColor = rgb(248, 181, 194); //54 131 200
//  _genderLable.text = @"女1";
  [_genderLable sizeToFit];
  _timeLable.text = [RCKitUtility ConvertMessageTime:[model.timeStamp longLongValue]];;
  
  _picContainerView.picPathStringsArray = model.picNames;
  _operationView.liked = model.liked;
  _operationView.comments = model.comments.count;
  _operationView.likeds = model.likes.count;
  
  CGFloat contentHeight = model.contentSize.CGSizeValue.height;
  [DltEmoUtils drawM80Label:_contentLabel withSourceString:model.text];
  _contentLabel.fixedHeight = @(contentHeight);
  
  CGFloat picContainerTopMargin = 0;
  if (model.picNames.count) {
    picContainerTopMargin = 10;
  }
  _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
  
  
  [self setupAutoHeightWithBottomView:_commentTitlePlaceholderView bottomMargin:0];
}



@end
