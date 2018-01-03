//
//  DLTGreatgodTableViewCell.m
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTGreatgodTableViewCell.h"
#import "DltUICommon.h"
#import "DLTGreatgodPhotoContainerView.h"

static  CGFloat margin = 15;
#define kGreatgodHeaderPhotoViewHeight 190*kScreenScale

@interface DLTGreatgodHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel     *nicknameLabel;
@property (nonatomic, strong) UILabel     *genderLable;
@property (nonatomic, strong) UILabel     *desLabel;
@property (nonatomic, strong) UIButton    *addFriendButton;
@property (nonatomic, strong) UILabel     *lineLabel;

@end

@implementation DLTGreatgodHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, kScreenWidth, 70);
    
    CGFloat avatar_w = 40;
    _avatarImageView = [UIImageView new];
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.image = [UIImage imageNamed:@"dlt_avatar_default_icon_old"];
    [_avatarImageView ui_setCornerRadius:5];
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nicknameLabel.backgroundColor = [UIColor clearColor];
    _nicknameLabel.textColor = rgb(44, 44, 44);
    _nicknameLabel.font = [UIFont systemFontOfSize:17];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    
    _genderLable = [UILabel new];
    _genderLable.font = [UIFont boldSystemFontOfSize:12];
    _genderLable.textAlignment = NSTextAlignmentCenter;
    _genderLable.textColor = [UIColor whiteColor];
    _genderLable.backgroundColor = [UIColor clearColor];
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _desLabel.backgroundColor = [UIColor clearColor];
    _desLabel.textColor = rgb(156, 156, 156);
    _desLabel.font = [UIFont systemFontOfSize:13];
    _desLabel.textAlignment = NSTextAlignmentLeft;
    
    _addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
    [_addFriendButton setTitle:@"发消息" forState:UIControlStateSelected];
    [_addFriendButton setTitleColor:rgb(0, 137, 241) forState:UIControlStateNormal];
    [_addFriendButton setTitleColor:rgb(0, 137, 241) forState:UIControlStateSelected];
    [_addFriendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_addFriendButton ui_setPathRadius:15 withRoundedRect:(CGRect){CGPointZero,85,30}];

    
     _lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
     _lineLabel.backgroundColor = rgb(211, 211, 211);
    
    [self sd_addSubviews:@[_avatarImageView,_nicknameLabel,_genderLable,_desLabel,_addFriendButton,_lineLabel]];
    
    
    _avatarImageView.sd_layout
    .widthIs(avatar_w)
    .heightIs(avatar_w)
    .leftSpaceToView(self,margin)
    .topSpaceToView(self,margin);
    
    _addFriendButton.sd_layout
    .rightSpaceToView(self,margin)
    .heightIs(30)
    .widthIs(85)
    .centerYEqualToView(self);
    
    _nicknameLabel.sd_layout
    .leftSpaceToView(_avatarImageView,margin)
    .heightRatioToView(_avatarImageView, .5)
    .topEqualToView(_avatarImageView);
     [_nicknameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _genderLable.sd_layout
    .widthIs(35)
    .heightIs(16)
    .leftSpaceToView(_nicknameLabel,margin)
    .centerYEqualToView(_nicknameLabel);
    
    _desLabel.sd_layout
    .leftEqualToView(_nicknameLabel)
    .heightRatioToView(_avatarImageView, .5)
    .rightSpaceToView(_addFriendButton,2*margin)
    .topSpaceToView(_nicknameLabel,3.f);
    
 
    _lineLabel.sd_layout
    .leftEqualToView(_avatarImageView)
    .heightIs(.6)
    .rightEqualToView(_addFriendButton)
    .bottomSpaceToView(self,0);
    
  }
  
  return self;
}


@end


@interface DLTGreatgodCellOperationViews : UIView

//@property (nonatomic, strong) UIImageView *userIconView;
@property (nonatomic, strong) UIImageView *antsIconView;

//@property (nonatomic, strong) UILabel     *friendsLabel;
@property (nonatomic, strong) UILabel     *antsBLable;


//@property (nonatomic, assign) CGFloat friends;
@property (nonatomic, assign) CGFloat antsCurrency;

@end

@implementation DLTGreatgodCellOperationViews

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initVies];
  }
  return self;
}


- (void)initVies{
  
//  _userIconView = [UIImageView new];
//  _userIconView.userInteractionEnabled = YES;
//  _userIconView.image = [UIImage imageNamed:@"dlt_avatar_default_icon_old"];

  _antsIconView = [UIImageView new];
  _antsIconView.userInteractionEnabled = YES;
    
  
  
//  _friendsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//  _friendsLabel.textColor = rgb(44, 44, 44);
//  _friendsLabel.font = [UIFont systemFontOfSize:17];
//  _friendsLabel.textAlignment = NSTextAlignmentLeft;
  
  _antsBLable = [[UILabel alloc] initWithFrame:CGRectZero];
  _antsBLable.font = [UIFont systemFontOfSize:14];
  _antsBLable.textAlignment = NSTextAlignmentLeft;
  
  [self sd_addSubviews:@[_antsIconView,_antsBLable]];
  
//  self.friends = 0;
  self.antsCurrency = 0;
  
  
  [_antsIconView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.and.height.mas_equalTo(25);
    make.left.equalTo(self);
    make.centerY.equalTo(self);
  }];
  
  [_antsBLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(200);
    make.height.mas_equalTo(25);
    make.centerY.equalTo(self);
    make.left.equalTo(_antsIconView.mas_right).offset(10);
  }];

  
//  [_userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.and.height.mas_equalTo(25);
//    make.left.equalTo(self);
//    make.centerY.equalTo(self);
//  }];
//  
//  [_friendsLabel sizeToFit];
//  [_friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.mas_equalTo(_friendsLabel.width);
//    make.height.mas_equalTo(25);
//    make.centerY.equalTo(self);
//    make.left.equalTo(_userIconView.mas_right).offset(10);
//  }];
//
//  
//  [_antsIconView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.and.height.mas_equalTo(25);
//    make.left.equalTo(_friendsLabel.mas_right).offset(20);
//    make.centerY.equalTo(self);
//  }];
//  
//  [_antsBLable mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.mas_equalTo(100);
//    make.height.mas_equalTo(25);
//    make.centerY.equalTo(self);
//    make.left.equalTo(_antsIconView.mas_right).offset(10);
//  }];
//  
  

}

//- (void)setFriends:(CGFloat)friends{
//  _friends = friends;
//  
//  _friendsLabel.text = [NSString stringWithFormat:@"好友 (%d)",(int)friends];
//}

- (void)setAntsCurrency:(CGFloat)antsCurrency{
  _antsCurrency = antsCurrency;
  
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    if ([user.uid isEqualToString:@"286"] || [user.uid isEqualToString:@"3422"]) {
        
    }else{
        _antsBLable.text = [NSString stringWithFormat:@"余额 (%.2f)",antsCurrency/100];
        _antsIconView.image = [UIImage imageNamed:@"dlt_greatgod_ants_icon"];
    }
    
      
 
  
}


@end

// -----------------

@interface DLTGreatgodTableViewCell ()

@property (nonatomic, strong) DLTGreatgodHeaderView *headViews;
@property (nonatomic, strong) DLTGreatgodPhotoContainerView *photoViews;
@property (nonatomic, strong) DLTGreatgodCellOperationViews *operationViews;
@end

@implementation DLTGreatgodTableViewCell

-(void)ba_setupCell{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundColor = [UIColor whiteColor];
}

- (void)addButtonEvent:(UIButton *)button{
  if (self.greatgodDelegate && [self.greatgodDelegate respondsToSelector:@selector(greatgodTableViewCell:didClickButton:)]) {
    DLTGreatgodEventType event = button.isSelected? DLTGreatgodEventTypeSendMessage :DLTGreatgodEventTypeAddFriends;
    [self.greatgodDelegate greatgodTableViewCell:self didClickButton:event];
  }
}

- (void)didTapAvatarViewEvent{
  if (self.greatgodDelegate && [self.greatgodDelegate respondsToSelector:@selector(greatgodTableViewCell:didTapAvatarView:)]) {
    [self.greatgodDelegate greatgodTableViewCell:self didTapAvatarView:self.model];
  }
}

- (void)ba_buildSubview{
  CGFloat margin = 15;
  
  
  _headViews = [[DLTGreatgodHeaderView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 70)];
  [_headViews.addFriendButton addTarget:self
                                 action:@selector(addButtonEvent:)
                       forControlEvents:UIControlEventTouchUpInside];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatarViewEvent)];
  [self addGestureRecognizer:tap];
  
  _photoViews = [[DLTGreatgodPhotoContainerView alloc] initWithFrame:CGRectMake(margin, _headViews.bottom + 15, kScreenWidth - 2*margin, kGreatgodHeaderPhotoViewHeight)];
  
  @weakify(self);
  [_photoViews setDLTGreatgodPhotoContainerBlock:^(NSArray<NSString *> *photos, NSArray<UIImageView *> *image, NSInteger index) {
    @strongify(self);
    if (self.greatgodDelegate && [self.greatgodDelegate respondsToSelector:@selector(greatgodTableViewCell:cellForPhotos:cellForImageViews:didClickIndex:)]) {
      [self.greatgodDelegate greatgodTableViewCell:self cellForPhotos:photos cellForImageViews:image didClickIndex:index];
    }
  }];
  
  _operationViews = [[DLTGreatgodCellOperationViews alloc] initWithFrame:CGRectMake(margin, _photoViews.bottom + 5, _photoViews.width, 60)];

  UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(0, _operationViews.bottom, kScreenWidth, 10)];
  placeholder.backgroundColor = rgb(246, 246, 246);
  
  [self sd_addSubviews:@[_headViews,_photoViews,_operationViews,placeholder]];
}

- (void)configureCellWithGreatgodModel:(DLTGreatgodModel *)model{
  _model = model;
  
  NSString *headURL = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg];
  if (!ISNULLSTR(headURL)) {
    [_headViews.avatarImageView sd_setImageWithURL:DLT_URL(headURL)
                 placeholderImage:[UIImage imageNamed:@"dlt_avatar_default_icon_old"]];
  }
  
  _headViews.nicknameLabel.text = model.name;
  _headViews.desLabel.text =  model.note;
  _headViews.genderLable.hidden = YES;
//  _headViews.genderLable.text = [NSString stringWithFormat:@"%@ %@",model.sexStr,model.age];
//  _headViews.genderLable.backgroundColor = model.sex? rgb(54,131,200) :rgb(248, 181, 194);
  _headViews.addFriendButton.selected = model.isFriend;
  
  _photoViews.picPathStringsArray = model.photoNames;
  _operationViews.antsCurrency = [model.blance floatValue];;
}

- (void)prepareForReuse{
  [super prepareForReuse];
  
  [_photoViews prepareForReuse];
}

+ (CGFloat)sizeThatFits{
  CGFloat changeHeight = 0;
  changeHeight += 70;
  changeHeight += 15;
  changeHeight += kGreatgodHeaderPhotoViewHeight;
  changeHeight += 5;
  changeHeight += 60;
  changeHeight += 10;
  
  return changeHeight;
}

@end
