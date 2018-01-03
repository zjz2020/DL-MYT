//
//  ChangephoneCell.m
//  Dlt
//
//  Created by USER on 2017/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ChangephoneCell.h"

@implementation ChangephoneCell
{
    UILabel * phoneLabel;
    UILabel * line;
}
-(void)filedata:(id)data
{
    NSDictionary * dic = data;
    NSString * title = dic[@"title"];
    phoneLabel.text =title;
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    phoneLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 19, 100, 17)];
    phoneLabel.font = AdaptedFontSize(17);
    [self addSubview:phoneLabel];
    
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.top_sd = phoneLabel.bottom_sd + 15;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line];
    
    _userName = [[UITextField alloc]init];
    _userName.delegate = self;
    [_userName addTarget:self action:@selector(changeName:) forControlEvents:UIControlEventEditingChanged];
    _userName.font = AdaptedFontSize(17);
//    _userName.textColor = [UIColor colorWithHexString:@"909090"];
    [self addSubview:_userName];
    
    _sexStr = [[UILabel alloc]init];
    _sexStr.font = AdaptedFontSize(17);
    _sexStr.textColor = [UIColor colorWithHexString:@"909090"];
    [self addSubview:_sexStr];
    
    _dateStr = [[UILabel alloc]init];
    _dateStr.font = AdaptedFontSize(17);
    _dateStr.textColor = [UIColor colorWithHexString:@"909090"];
    _dateStr.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singTap)];
    [_dateStr addGestureRecognizer:tap];
    [self addSubview:_dateStr];

    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(phoneLabel.mas_right).offset(15);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(54);
    }];
    
    [_sexStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(_userName);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(17);
    }];
    
    [_dateStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);

        make.left.mas_equalTo(_userName);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(17);
    }];
}
-(void)changeName:(UITextField *)changename
{
    if (_isUsername) {
        _isUsername(changename);
    }
}
-(void)singTap
{
    if (_isdate) {
        _isdate();
    }
}
@end
