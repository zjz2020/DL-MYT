//
//  PersonalCell.m
//  Dlt
//
//  Created by USER on 2017/5/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "PersonalCell.h"
#import "DltUICommon.h"
@interface PersonalCell ()
//@property(nonatomic,strong)UIImageView * myIcon;
//@property(nonatomic,strong)UILabel * nameLabel;
//@property(nonatomic,strong)UILabel * mytNumbel;
@property(nonatomic,strong)UILabel * bottemLine;



@end;
@implementation PersonalCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)ba_buildSubview
{
    self.myIcon = [[UIImageView alloc]init];
        self.myIcon.layer.cornerRadius = 4;
    self.myIcon.layer.masksToBounds = YES;
    [self addSubview:self.myIcon];
    
    self.nameLabel = [[UILabel alloc]init];
//    self.nameLabel.left_sd = self.myIcon.right_sd + 15;
    self.nameLabel.font = AdaptedFontSize(25);
    [self addSubview:self.nameLabel];
    
    self.mytNumbel = [[UILabel alloc]init];
//    self.mytNumbel.top_sd = self.nameLabel.bottom_sd +11;
//    self.mytNumbel.text = @"蚂蚁通号：37975726";
    self.mytNumbel.font = AdaptedFontSize(14);
    self.mytNumbel.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    [self addSubview:self.mytNumbel];
    
    
    self.bottemLine = [[UILabel alloc]init];
//    self.bottemLine.top_sd = self.myIcon.bottom_sd + 23;
//    self.bottemLine.width_sd = WIDTH;
    self.bottemLine.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:self.bottemLine];
    
    
    [_myIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(24);
        make.width.height.mas_equalTo(88);
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_myIcon.mas_right).offset(15);
        make.top.mas_equalTo(41);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(25);
    }];
    
    [_mytNumbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(_nameLabel);
        make.height.mas_equalTo(14);
    }];
    
    [_bottemLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH);
        make.top.equalTo(_myIcon.mas_bottom).offset(45/2);
        make.height.mas_equalTo(10);
    }];
    
}
-(void)setUserinfo:(DLTUserProfile *)userinfo
{
    _userinfo = userinfo;
    NSString * str = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,userinfo.userHeadImg];
    if (!ISNULLSTR(userinfo.userHeadImg)) {
        [self.myIcon sd_setImageWithURL:DLT_URL(str) placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    }
    self.nameLabel.text = userinfo.userName;
             self.mytNumbel.text = [NSString stringWithFormat:@"蚂蚁通号:%@",userinfo.phone];
   
    
}
@end
