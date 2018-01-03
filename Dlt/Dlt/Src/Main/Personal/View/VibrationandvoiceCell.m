//
//  VibrationandvoiceCell.m
//  Dlt
//
//  Created by USER on 2017/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "VibrationandvoiceCell.h"

@implementation VibrationandvoiceCell
{
    UILabel * alertLabel;
    UILabel * line;
    UISwitch * ison;
}
-(void)file:(id)data
{
    NSDictionary * dic = data;
    NSString * title = dic[@"title"];
    alertLabel.text = title;
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    alertLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 15, 17*5, 17)];
    alertLabel.font = AdaptedFontSize(17);
    [self addSubview:alertLabel];
    
    ison = [[UISwitch alloc]initWithFrame:RectMake_LFL(0, 15, 0, 45/2)];
    ison.left_sd = WIDTH-60;
    ison.width_sd = 50;
    [ison addTarget:self action:@selector(switchon:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:ison];
    
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.top_sd = alertLabel.bottom_sd + 15;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line];
    
    
    
}
-(void)switchon:(UISwitch *)on
{
    if (_isonClick) {
        _isonClick(on);
    }
}

@end
