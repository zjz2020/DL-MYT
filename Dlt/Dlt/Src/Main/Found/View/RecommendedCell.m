//
//  RecommendedCell.m
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RecommendedCell.h"
#import "DltUICommon.h"


@interface RecommendedCell ()

@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *desLabel;
@property(nonatomic, strong) UILabel *genderLabel;
@property(nonatomic, strong) UIButton *addinBtn;

@end

@implementation RecommendedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self setupCell];
    
    [self buildSubview];
  }
  
  return self;
}



-(void)setupCell{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)buildSubview{
  UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, .6)];
  line.backgroundColor = rgb(215, 215, 215);
  
  self.iconImage = [[UIImageView alloc]init];
  [self.iconImage ui_setCornerRadius:8];
  self.iconImage.backgroundColor = rgb(223, 223, 223); 
  [self.iconImage ui_imageViewAddGestureRecognizerTarget:self action:@selector(didClickAvatar)];
  
  self.nameLabel = [[UILabel alloc] init];
  self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
  
  self.desLabel = [[UILabel alloc]init];
  self.desLabel.font = [UIFont boldSystemFontOfSize:14];
  self.desLabel.textColor = [UIColor colorWithHexString:@"9c9c9c"];
  
  self.genderLabel = [[UILabel alloc]init];
  self.genderLabel.font = AdaptedFontSize(8);
  self.genderLabel.textAlignment = NSTextAlignmentCenter;
  self.genderLabel.backgroundColor = [UIColor colorWithHexString:@"3acff6"];
  
  self.addinBtn = [[UIButton alloc]initWithFrame:(CGRect){kScreenWidth - 85 - 15,self.contentView.centerY,85,30}];
  self.addinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
  [self.addinBtn setTitle:@"加为好友" forState:UIControlStateNormal];
  [self.addinBtn setTitle:@"发消息" forState:UIControlStateSelected];
  [self.addinBtn setTitleColor:[UIColor colorWithHexString:@"007bf5"] forState:UIControlStateNormal];
  [self.addinBtn setTitleColor:[UIColor colorWithHexString:@"007bf5"] forState:UIControlStateSelected];
  [ self.addinBtn addTarget:self
                     action:@selector(addButtonEvent:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.addinBtn ui_setPathRadius:15 withRoundedRect:(CGRect){CGPointZero,85,30}];
  
  UIView *contentView = self.contentView;
  [contentView sd_addSubviews:@[line,_iconImage,_nameLabel,_desLabel,_genderLabel,_addinBtn]];
  
  
  _iconImage.sd_layout
  .widthIs(60)
  .heightIs(60)
  .leftSpaceToView(contentView, 15)
  .centerYEqualToView(contentView);
  
  _addinBtn.sd_layout
  .widthIs(85)
  .heightIs(30)
  .centerYEqualToView(contentView);
  
  _nameLabel.sd_layout
  .heightRatioToView(_iconImage, .6f)
  .leftSpaceToView(_iconImage, 15)
  .topEqualToView(_iconImage);
  [_nameLabel setSingleLineAutoResizeWithMaxWidth:130];
  
  _genderLabel.sd_layout
  .heightIs(16)
  .leftSpaceToView(_nameLabel, 15)
  .widthIs(37)
  .centerYEqualToView(_nameLabel);
  
  _desLabel.sd_layout
  .heightRatioToView(_iconImage, .4f)
  .topSpaceToView(_nameLabel, 0)
  .leftEqualToView(_nameLabel)
  .rightSpaceToView(_addinBtn, 15);
  
}

- (void)addButtonEvent:(UIButton *)button{
    DLTRecommendedEventType event = button.isSelected? DLTRecommendedEventTypeSendMessage :DLTRecommendedEventTypeAddFriends;
  [self _respondsToSelector:event];
}

- (void)didClickAvatar{
  [self _respondsToSelector:DLTRecommendedEventTypeClickAvatar];
}

- (void)_respondsToSelector:(DLTRecommendedEventType)type{
  if (self.delegate && [self.delegate respondsToSelector:@selector(recommendedCell:didClickButton:)]) {

    [self.delegate recommendedCell:self didClickButton:type];
  }
}

- (void)configurationCellForModel:(DLTRecommendModel *)model{
  _model = model;
  
  NSString *headURL = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg];
  if (!ISNULLSTR(model.headImg)) {
    @weakify(self);
    [_iconImage sd_setImageWithURL:DLT_URL(headURL)
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           @strongify(self);
                           if (!error) {
                             self->_iconImage.backgroundColor = [UIColor clearColor];
                           }
                           
                         }];
  }
  
  _nameLabel.text = model.name;
  _desLabel.text = model.note;
  
 
//  self.genderLabel.hidden = ISNULLSTR(model.name);
   self.genderLabel.hidden = YES;
//  self.genderLabel.text = [NSString stringWithFormat:@"%@ %@",model.sexStr,model.age];
//  self.genderLabel.backgroundColor = model.sex? rgb(54,131,200) :rgb(248, 181, 194);
//  
  self.addinBtn.selected = model.isFriend;
  
}


@end
