//
//  DLTPersonalProfileHeaderView.m
//  Dlt
//
//  Created by Gavin on 2017/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTPersonalProfileHeaderView.h"
#import "DltUICommon.h"

@implementation DLTPersonalProfileHeaderView {
  UILabel *_nameLabel;
  UILabel *_signature;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initSubViews];
  }
  return self;
}

- (void)initSubViews{
  
  self.backgroundColor = [UIColor whiteColor];
  
  _userBackgroundImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,155)];
  _userBackgroundImageview.backgroundColor = [UIColor lightGrayColor];
  _userBackgroundImageview.contentMode = UIViewContentModeScaleAspectFill;
  _userBackgroundImageview.clipsToBounds = YES;
  [self addSubview:_userBackgroundImageview];
  
  _backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 10, 25, 25)];
  [_backBtn setImage:[UIImage imageNamed:@"personal_16"] forState:UIControlStateNormal];
  [self addSubview:_backBtn];
  
  _editorBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 40,_userBackgroundImageview.bottom + 10, 25, 25)];
  [_editorBtn setImage:[UIImage imageNamed:@"personal_editor_icon"] forState:UIControlStateNormal];
  [self addSubview:_editorBtn];
  
  
  _userAvatarImageView = [[UIImageView alloc]initWithFrame:(CGRect){CGPointZero,100,100}];
  [_userAvatarImageView ui_setCornerRadius:50
                      withBackgroundColor:[UIColor grayColor]
                              borderColor:[UIColor whiteColor]
                              borderWidth:2];
  [self addSubview:_userAvatarImageView];
  
  // name
  _nameLabel = [[UILabel alloc]init];
  _nameLabel.font = AdaptedFontSize(17);
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_nameLabel];
  
//  UIButton *edidBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
//  edidBtn.left_sd = WIDTH - 30;
//  edidBtn.top_sd = backImage.bottom_sd + 15;
//  [edidBtn setImage:[UIImage imageNamed:@"personal_17"] forState:UIControlStateNormal];
//  [edidBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
//  edidBtn.hidden = YES;
//  [self addSubview:edidBtn];
  
  _signature = [[UILabel alloc]init];
  _signature.textAlignment = NSTextAlignmentCenter;
  _signature.font = AdaptedFontSize(14);
  _signature.textColor = [UIColor colorWithHexString:@"a0a0a0"];
  [self addSubview:_signature];
  
  [_userAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.and.height.mas_equalTo(100);
    make.centerX.equalTo(self);
    make.centerY.equalTo(_userBackgroundImageview.mas_bottom);
  }];
  
  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(_userAvatarImageView.mas_bottom).mas_offset(5);
    make.width.mas_equalTo(200);
    make.height.mas_equalTo(25);
    make.centerX.equalTo(self);
  }];
  
  [_signature mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    make.width.mas_equalTo(200);
    make.height.mas_equalTo(25);
    make.centerX.equalTo(self);
  }];
}

- (void)updatePersonalProfile:(DLTUserProfile *)userProfile{
   NSURL *avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,userProfile.userHeadImg]];
   NSURL *backgroundURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,userProfile.bgImg]];
  
//   [avatarURL ui_removeImageCache];
//   [backgroundURL ui_removeImageCache];
  [_userBackgroundImageview sd_setImageWithURL:backgroundURL placeholderImage:nil];
  [_userAvatarImageView sd_setImageWithURL:avatarURL placeholderImage:nil];
  
  _nameLabel.text = userProfile.userName;
  _signature.text = userProfile.note;
}



@end


@implementation DLTPersonalProfileHeaderSectionView {
  YYLabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initSubViews];
  }
  return self;
}


- (void)initSubViews{
  
  self.backgroundColor = [UIColor whiteColor];
  
  YYLabel *placeholder = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
  placeholder.backgroundColor = rgb(246, 246, 246);
  [self addSubview:placeholder];
  
  _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(15, placeholder.bottom, 200, 40)];
  _titleLabel.textAlignment = NSTextAlignmentLeft;
  _titleLabel.font = [UIFont systemFontOfSize:14];
  _titleLabel.textColor = [UIColor colorWithHexString:@"444444"];
  [self addSubview:_titleLabel];
  
  
  _enterAlbumBtn = [[UIButton alloc]init];
  [_enterAlbumBtn setImage:[UIImage imageNamed:@"personal_enter_album"] forState:UIControlStateNormal];
  [self addSubview:_enterAlbumBtn];
  
  [_enterAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.height.mas_equalTo(25);
    make.centerY.equalTo(_titleLabel);
    make.right.equalTo(self.mas_right).mas_offset(-15);
  }];
  
}

- (void)setTitle:(NSString *)title{
  _title = title;
  
  if (title.length == 0) {
    return;
  }
  
  _titleLabel.text = title;
}

@end
