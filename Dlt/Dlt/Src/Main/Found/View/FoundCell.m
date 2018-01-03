//
//  FoundCell.m
//  Dlt
//
//  Created by USER on 2017/5/12.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "FoundCell.h"
@interface FoundCell ()
@property(nonatomic,strong)UIImageView * iconImage;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * bottemLine;


@end
@implementation FoundCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    self.iconImage = [[UIImageView alloc]init];//    self.iconImage.image = [UIImage imageNamed:@"friends_00"];
    [self addSubview:self.iconImage];
    
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.left_sd = self.iconImage.right_sd + 15;
    self.contentLabel.font = AdaptedFontSize(17);
//    self.contentLabel.text = @"蚂蚁圈";
    [self addSubview:self.contentLabel];
    
    self.bottemLine = [[UILabel alloc]init];
    self.bottemLine.width_sd = WIDTH;
    self.bottemLine.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:self.bottemLine];

    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
        
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.equalTo(_iconImage.mas_right).offset(10);
        make.width.mas_equalTo(17*6);
        make.height.mas_equalTo(17);
    }];
    
    [_bottemLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImage.mas_bottom).offset(15);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(10);
    }];
    
    
    
    

}
-(void)file:(id)data
{
    NSString * icon = data[@"icon"];
    self.iconImage.image =[UIImage imageNamed:icon];
    NSString * title = data[@"title"];
    self.contentLabel.text = title;
}
@end
