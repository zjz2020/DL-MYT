//
//  WithdrawalCell.m
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "WithdrawalCell.h"

@interface WithdrawalCell ()<UITextFieldDelegate>

@end

@implementation WithdrawalCell
{
    UIImageView * myIcon;
//    UILabel * myName;
//    UILabel * transmoney;
    UILabel * rmb;
    UILabel * line;
    UITextField * psText;
    UILabel * line1;
    UILabel * seletype;
    UIButton * withdrawalBtn;
    UILabel * line2;
    UILabel *_myName;
    
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{

    _transmoney = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 48/2, 14*8, 14)];
    
    _transmoney.font = AdaptedFontSize(14);
    _transmoney.text = @"提现金额";
    [self.contentView addSubview:_transmoney];
    

    self.moneyFiled = [[UITextField alloc]initWithFrame:RectMake_LFL(15, 0, 0, 70)];
    self.moneyFiled.delegate = self;
    self.moneyFiled.top_sd = _transmoney.bottom_sd + 8;
    self.moneyFiled.width_sd = WIDTH;
    self.moneyFiled.font = AdaptedFontSize(25);
    self.moneyFiled.placeholder = @"请输入金额";
    self.moneyFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.moneyFiled];
    
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.top_sd = _moneyFiled.bottom_sd;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self.contentView addSubview:line];
    
    _myName = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 78/2)];
    _myName.top_sd = line.bottom;
    _myName.font = AdaptedFontSize(14);
    _myName.width_sd = WIDTH -100;
    _myName.textColor = [UIColor colorWithHexString:@"a2a2a2"];
    _myName.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_myName];

    withdrawalBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 14*5, 14)];
    withdrawalBtn.left = WIDTH-14*5-15;
    withdrawalBtn.top_sd = line.bottom_sd+10;
    withdrawalBtn.titleLabel.font = AdaptedFontSize(14);
    [withdrawalBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [withdrawalBtn setTitleColor:[UIColor colorWithHexString:@"0089f1"] forState:UIControlStateNormal];
    [withdrawalBtn addTarget:self action:@selector(withdrawal) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:withdrawalBtn];
    
    
    
    line1 =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
    line1.top_sd = _myName.bottom_sd;
    line1.width_sd = WIDTH;
    line1.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self.contentView addSubview:line1];
    
    seletype = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 28*4, 14)];
    seletype.top_sd =line1.bottom_sd +10;
    seletype.font = AdaptedFontSize(14);
    seletype.text = @"   支付方式";
    [self.contentView addSubview:seletype];
    line2 =[[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self.contentView addSubview:line2];
    [_transmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(14*8);
        make.height.mas_equalTo(14);
    }];
    
    [self.moneyFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_transmoney.mas_bottom).offset(8);
        make.left.mas_equalTo(_transmoney);
        make.width.mas_equalTo(WIDTH-30);
        make.height.mas_equalTo(70);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyFiled.mas_bottom).offset(0);
        make.width.mas_equalTo(_moneyFiled);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(_moneyFiled);
    }];
    
    
    [_myName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(0);
        make.left.mas_equalTo(_moneyFiled);
        make.width.mas_equalTo(WIDTH-100);
        make.height.mas_equalTo(78/2);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myName.mas_bottom).offset(0);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(WIDTH);
    }];
    
    [seletype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(40);
    }];
    [withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(13);
        make.left.mas_equalTo(WIDTH-75);
        make.width.mas_equalTo(14*5);
        make.height.mas_equalTo(14);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seletype.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(WIDTH);
    }];
}
- (void)setBlances:(NSString *)blances {
    _blances = blances;
    _myName.text = [NSString stringWithFormat:@"可用余额：%.2f",[blances floatValue]];
}

+(CGFloat)CellH {
    return 210;
}
-(void)withdrawal {
    if (self.withdrawalDelegate && [self.withdrawalDelegate respondsToSelector:@selector(withdrawalCell:clickAllWithFrawalButtonAction:)]) {
        [self.withdrawalDelegate withdrawalCell:self clickAllWithFrawalButtonAction:self.blances];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.withdrawalDelegate && [self.withdrawalDelegate respondsToSelector:@selector(withdrawalCell:inputFinishAccomt:)]) {
        [self.withdrawalDelegate withdrawalCell:self inputFinishAccomt:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.withdrawalDelegate && [self.withdrawalDelegate respondsToSelector:@selector(withdrawalCell:inputFinishAccomt:)]) {
        [self.withdrawalDelegate withdrawalCell:self inputFinishAccomt:text];
    }
    return YES;
    
}
@end
