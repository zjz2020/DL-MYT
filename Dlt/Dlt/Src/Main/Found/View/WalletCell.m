//
//  WalletCell.m
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "WalletCell.h"
@interface WalletCell ()
@property(nonatomic,strong)UILabel * setupPassword;


@end
@implementation WalletCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"fdffdc"];
    
}
-(void)ba_buildSubview
{
    self.setupPassword = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 14, 0, 14)];
    self.setupPassword.width_sd = WIDTH;
    self.setupPassword.font = AdaptedFontSize(14);
    self.setupPassword.text = @"为了保障你的资金安全，请先设置你的支付密码";
    [self addSubview:self.setupPassword];
}

@end
