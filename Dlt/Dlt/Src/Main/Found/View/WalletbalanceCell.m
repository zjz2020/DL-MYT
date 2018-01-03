//
//  WalletbalanceCell.m
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "WalletbalanceCell.h"
@interface WalletbalanceCell ()
@property(nonatomic,strong)UILabel * balanceLabel;


@end
@implementation WalletbalanceCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"0080F5"];
}
-(void)ba_buildSubview
{
    self.balanceLabel = [[UILabel alloc]init];
    self.balanceLabel.font = AdaptedFontSize(14);
    self.balanceLabel.textColor =[UIColor whiteColor];
    self.balanceLabel.text =@"金额";
    [self addSubview:self.balanceLabel];
    
    
    self.moneyLabel = [[UILabel alloc]init];
//    self.moneyLabel.top_sd = self.balanceLabel.bottom_sd + 21;
    self.moneyLabel.font = AdaptedFontSize(50);
    self.moneyLabel.textColor = [UIColor whiteColor];
//    self.moneyLabel.text = @"¥500.00";
    [self addSubview:self.moneyLabel];
    
    
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(14*10);
        make.height.mas_equalTo(14);
        
    }];
    
    
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_balanceLabel);
        make.top.equalTo(_balanceLabel.mas_bottom).offset(21);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(50);
    }];
    
    
    
    
    
    
    
}

@end
