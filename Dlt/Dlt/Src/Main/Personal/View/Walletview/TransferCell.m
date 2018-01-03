//
//  TransferCell.m
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "TransferCell.h"
@interface TransferCell ()<UITextFieldDelegate>



@end
@implementation TransferCell
{
//    UIImageView * myIcon;
//    UILabel * myName;
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
    _myIcon = [[UIImageView alloc]initWithFrame:RectMake_LFL(304/2, 25, 70, 70)];
    _myIcon.layer.cornerRadius = _myIcon.width_sd /2;
    _myIcon.layer.masksToBounds = YES;
    _myIcon.backgroundColor = [UIColor redColor];
    [self addSubview:_myIcon];
    
    _myName =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, WIDTH, 17)];
    _myName.top_sd = _myIcon.bottom_sd + 11;
    _myName.font = AdaptedFontSize(17);
    _myName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_myName];
    transmoney = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 14*8, 14)];
    transmoney.top_sd = _myName.bottom_sd + 41;
    transmoney.font = AdaptedFontSize(14);
    transmoney.text = @"转账金额";
    [self addSubview:transmoney];
    
    rmb = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 40, 40)];
    rmb.top_sd = transmoney.bottom_sd + 22;
    rmb.font = AdaptedFontSize(40);
    rmb.text = @"¥";
    rmb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:rmb];
    
    moneyFiled = [[UITextField alloc]initWithFrame:RectMake_LFL(0, 0, 0, 70)];
    moneyFiled.delegate = self;
    moneyFiled.left_sd = rmb.right_sd;
    moneyFiled.top_sd = transmoney.bottom_sd + 8;
    moneyFiled.width_sd = WIDTH;
    moneyFiled.font = AdaptedFontSize(40);
    moneyFiled.keyboardType = UIKeyboardTypeNumberPad;

//    moneyFiled.leftView = [[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0)];
//    moneyFiled.leftView.userInteractionEnabled = NO;
//    moneyFiled.leftViewMode = UITextFieldViewModeAlways;
//    moneyFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [moneyFiled addTarget:self action:@selector(moneyClick:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:moneyFiled];
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.top_sd = moneyFiled.bottom_sd;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line];
    
    psText = [[UITextField alloc]initWithFrame:RectMake_LFL(15, 0, 0, 44)];
    psText.delegate = self;
    psText.top_sd = line.bottom_sd;
    psText.width_sd=WIDTH;
    psText.font =AdaptedFontSize(14);
    psText.placeholder = @"   附言";
    [psText addTarget:self action:@selector(psClick:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:psText];
    
    line1 =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
    line1.top_sd = psText.bottom_sd;
    line1.width_sd = WIDTH;
    line1.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line1];
    
    seletype = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 28*4, 40)];
    seletype.top_sd =line1.bottom_sd ;
    seletype.font = AdaptedFontSize(14);
    seletype.text = @"   支付方式";
    [self addSubview:seletype];
    line2 =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
    line2.top_sd = psText.bottom_sd;
    line2.width_sd = WIDTH;
    line2.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line2];
    [_myIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [_myName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.top.equalTo(_myIcon.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(17*10, 17));
    }];
    [transmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myName.mas_bottom).offset(41);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(14*6);
        make.height.mas_equalTo(14);
    }];
    [rmb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transmoney.mas_bottom).offset(27);
        make.left.mas_equalTo(transmoney);
        make.width.height.mas_equalTo(30);
    }];
    
    [moneyFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transmoney.mas_bottom).offset(8);
        make.left.equalTo(rmb.mas_right).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(70);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyFiled.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    
    [psText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(44);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(psText.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(10);
    }];
    
    [seletype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(40);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seletype.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    
}
-(void)moneyClick:(UITextField *)text
{
    if (_moneyClick) {
        _moneyClick(text);
    }
    
}
-(void)psClick:(UITextField *)text
{
    if (_psClick) {
        _psClick(text);
    }
}

@end
