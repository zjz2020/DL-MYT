//
//  TopUpCell.m
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "TopUpCell.h"

@implementation TopUpCell
{
    UIImageView * myIcon;
    UILabel * myName;
    UILabel * transmoney;
    UILabel * rmb;
    UITextField * moneyFiled;
    UILabel * line;
    UITextField * psText;
    UILabel * line1;
    UILabel * seletype;
    UILabel * line2;

    
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{

    transmoney = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 46/2, 14*8, 14)];

    transmoney.font = AdaptedFontSize(14);
    transmoney.text = @"充值余额";
    [self addSubview:transmoney];

    
    moneyFiled = [[UITextField alloc]initWithFrame:RectMake_LFL(15, 0, 0, 70)];
    moneyFiled.delegate = self;
//    moneyFiled.left_sd = rmb.right_sd;
    moneyFiled.top_sd = transmoney.bottom_sd + 8;
    moneyFiled.width_sd = WIDTH;
    moneyFiled.font = AdaptedFontSize(25);
    moneyFiled.placeholder = @"请输入金额";
    moneyFiled.keyboardType = UIKeyboardTypeDecimalPad;

    [moneyFiled addTarget:self action:@selector(moneyClick:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:moneyFiled];
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.top_sd = moneyFiled.bottom_sd;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line];
    
    myName = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 78/2)];
    myName.top_sd = line.bottom;
    myName.font = AdaptedFontSize(14);
    myName.text = @"备注：无";
    myName.width_sd = WIDTH;
    myName.textColor = [UIColor colorWithHexString:@"a2a2a2"];
    myName.backgroundColor = [UIColor whiteColor];
    [self addSubview:myName];

    
    line1 =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
    line1.top_sd = myName.bottom_sd;
    line1.width_sd = WIDTH;
    line1.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line1];
    
    seletype = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 28*4, 40)];
    seletype.top_sd =line1.bottom_sd ;
    seletype.font = AdaptedFontSize(14);
    seletype.text = @"   支付方式";
    [self addSubview:seletype];
    
    line2 =[[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line2];
    
    
    
    [transmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(14*8);
        make.height.mas_equalTo(14);
    }];
    
    [moneyFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transmoney.mas_bottom).offset(8);
        make.left.mas_equalTo(transmoney);
        make.width.mas_equalTo(WIDTH-30);
        make.height.mas_equalTo(70);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyFiled.mas_bottom).offset(0);
        make.width.mas_equalTo(moneyFiled);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(moneyFiled);
    }];
    
    
    [myName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(0);
        make.left.mas_equalTo(moneyFiled);
        make.width.mas_equalTo(WIDTH-100);
        make.height.mas_equalTo(78/2);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myName.mas_bottom).offset(0);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(WIDTH);
    }];
    
    [seletype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(40);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seletype.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(WIDTH);
    }];
    
    
    
}
-(void)moneyClick:(UITextField *)text
{
    if (_ismoneyClick) {
        _ismoneyClick(text);
    }
    
}

@end
