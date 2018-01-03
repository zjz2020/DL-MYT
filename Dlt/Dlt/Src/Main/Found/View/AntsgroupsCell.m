//
//  AntsgroupsCell.m
//  Dlt
//
//  Created by USER on 2017/5/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "AntsgroupsCell.h"
#import "DltUICommon.h"

@interface AntsgroupsCell ()

@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *desLabel;
@property(nonatomic, strong) UILabel * numberofLabel;
@property(nonatomic, strong) UIButton * addinBtn;
@property(nonatomic, assign) NSInteger groupNumber;

@end

@implementation AntsgroupsCell

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
  [self.iconImage ui_imageViewAddGestureRecognizerTarget:self
                                                  action:@selector(clickGroupAvatar)];
  
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"007bf5"];
  
    self.desLabel = [[UILabel alloc]init];
    self.desLabel.font = [UIFont boldSystemFontOfSize:14];
    self.desLabel.textColor = [UIColor colorWithHexString:@"9c9c9c"];

    self.numberofLabel = [[UILabel alloc]init];
    self.numberofLabel.font = AdaptedFontSize(8);
    self.numberofLabel.textAlignment = NSTextAlignmentCenter;
    self.numberofLabel.backgroundColor = [UIColor colorWithHexString:@"3acff6"];
    self.groupNumber = 0;
 
    self.addinBtn = [[UIButton alloc]initWithFrame:(CGRect){kScreenWidth - 55 - 15,0,55,30}];
    self.addinBtn.centerY = self.contentView.centerY;
    self.addinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.addinBtn setTitle:@"加入" forState:UIControlStateNormal];
    [self.addinBtn setTitle:@"已加入" forState:UIControlStateSelected];
    self.addinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.addinBtn setTitleColor:[UIColor colorWithHexString:@"007bf5"] forState:UIControlStateNormal];
    [self.addinBtn addTarget:self action:@selector(addButtonClickEvent:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.addinBtn ui_setPathRadius:15 withRoundedRect:(CGRect){CGPointZero,55,30}];
  
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[line,_iconImage,_nameLabel,_desLabel,_numberofLabel,_addinBtn]];
  
  _iconImage.sd_layout
  .widthIs(60)
  .heightIs(60)
  .leftSpaceToView(contentView, 15)
  .centerYEqualToView(contentView);
  
  _addinBtn.sd_layout
  .widthIs(55)
  .heightIs(30)
  .centerYEqualToView(contentView);
  
  _nameLabel.sd_layout
  .heightRatioToView(_iconImage, .6f)
  .leftSpaceToView(_iconImage, 15)
  .topEqualToView(_iconImage);
  [_nameLabel setSingleLineAutoResizeWithMaxWidth:130];
  
  _numberofLabel.sd_layout
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

- (void)addButtonClickEvent:(UIButton *)button{
  if (button.isSelected) return; // 已加入  
  if (self.applyToGroup_block_t) {
    self.applyToGroup_block_t();
  }
}

- (void)clickGroupAvatar{
  if (self.clickGroupAvatar_block_t) {
    self.clickGroupAvatar_block_t();
  }
}

- (void)setGroupNumber:(NSInteger)groupNumber{
  _groupNumber = groupNumber;
  
    self.numberofLabel.hidden = YES;
  self.numberofLabel.text = [NSString stringWithFormat:@"%d 人",(int)groupNumber];
}

- (void)configurationCellForModel:(DLGroupsInfo *)model{
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
  
  _nameLabel.text = model.groupName;
  _desLabel.text = model.note;
  
  self.groupNumber = [model.count integerValue];
  _addinBtn.selected = model.isMember;
}

- (void)prepareForReuse{
  [super prepareForReuse];
  
  [_iconImage sd_cancelCurrentImageLoad];
}


@end
