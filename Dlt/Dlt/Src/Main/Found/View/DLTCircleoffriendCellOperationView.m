//
//  DLTCircleoffriendCellOperationView.m
//  Dlt
//
//  Created by Gavin on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTCircleoffriendCellOperationView.h"
#import "DltUICommon.h"

@implementation DLTCircleoffriendCellOperationView


- (instancetype)init
{
  self = [super init];
  if (self) {
    
    _thumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_thumbButton setImage:[UIImage imageNamed:@"dlt_found_thumb_no"] forState:UIControlStateNormal];
    [_thumbButton setImage:[UIImage imageNamed:@"dlt_found_thumb_yes"] forState:UIControlStateSelected];

    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setImage:[UIImage imageNamed:@"dlt_found_more_yes"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"dlt_found_more_yes"] forState:UIControlStateSelected];
    _moreButton.tag = 10088;
    [_moreButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setImage:[UIImage imageNamed:@"dlt_found_comments_icon"] forState:UIControlStateNormal];
    
    _thumbLabel = [[UILabel alloc] init];
    _thumbLabel.font = [UIFont systemFontOfSize:14];
    _thumbLabel.textColor = rgb(44, 44, 44);
    
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:14];
    _commentLabel.textColor = rgb(44, 44, 44);
    
    _lineLabel = [UILabel new];
    _lineLabel.backgroundColor = rgb(211, 211, 211);
    
    [self addSubview:_thumbButton];
    [self addSubview:_moreButton];
    [self addSubview:_commentButton];
    [self addSubview:_thumbLabel];
    [self addSubview:_commentLabel];
    [self addSubview:_lineLabel];
    
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.and.height.mas_equalTo(50);
      make.right.equalTo(self.mas_right).offset(-15);
      make.centerY.equalTo(self);
    }];
    
    [_thumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.and.height.mas_equalTo(50);
      make.leftMargin.mas_equalTo(5);
      make.centerY.equalTo(self);
    }];
    
    [_thumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(10);
      make.height.mas_equalTo(25);
      make.centerY.equalTo(_thumbButton);
      make.left.equalTo(_thumbButton.mas_right).offset(0);
    }];
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.and.height.mas_equalTo(50);
      make.centerY.equalTo(self);
      make.left.equalTo(_thumbLabel.mas_right).offset(20);
    }];
    
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(100);
      make.height.mas_equalTo(25);
      make.centerY.equalTo(self);
      make.left.equalTo(_commentButton.mas_right).offset(0);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(.6f);  ;
      make.left.equalTo(self);
      make.rightMargin.equalTo(self);
      make.bottom.equalTo(self.mas_bottom);
    }];
    
    // tap
    UIButton *likeTap = [[UIButton alloc] init];
    likeTap.tag = 10086; 
    [likeTap addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeTap];
    
    UIButton *commentTap = [[UIButton alloc] init];
    commentTap.tag = 10087;
    [commentTap addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:commentTap];
    
    [likeTap mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(50);
      make.width.mas_equalTo(100);
      make.left.equalTo(self);
      make.centerY.equalTo(self);
    }];
    
    [commentTap mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(50);
      make.width.mas_equalTo(100);
      make.left.mas_equalTo(likeTap.mas_right);
      make.centerY.equalTo(self);
    }];
    
    
  //
    self.hiddenLine = YES;
    self.comments = 0;
    self.likeds = 0;
    self.hiddenMoreBtn = YES;
  }
  
  return self;
}

- (void)setHiddenMoreBtn:(BOOL)hiddenMoreBtn{
  _hiddenMoreBtn = hiddenMoreBtn;
  self.moreButton.hidden = hiddenMoreBtn;
}

- (void)setLiked:(BOOL)liked{
  _liked = liked;
  
  self.thumbButton.selected = liked;
}

- (void)setHiddenLine:(BOOL)hiddenLine{
  _hiddenLine = hiddenLine;
  
  self.lineLabel.hidden = hiddenLine;
}

- (void)setComments:(CGFloat)comments{
  _comments = comments;
  
  _commentLabel.text = [NSString stringWithFormat:@"%d 评论",(int)comments];
}

- (void)setLikeds:(CGFloat)likeds{
  _likeds = likeds;
  
  _thumbLabel.text = [NSString stringWithFormat:@"%d 赞",(int)likeds];
  
  CGSize size = [_thumbLabel sizeThatFits:CGSizeMake(300, 25)];
  [_thumbLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(size.width);
  }];
}

- (void)clicked:(UIButton *)button{
  if (self.OperationViewButtonClickedBlock) {
    self.OperationViewButtonClickedBlock(button.tag);
  }
}

@end
