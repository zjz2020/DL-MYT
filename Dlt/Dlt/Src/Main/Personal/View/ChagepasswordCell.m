//
//  ChagepasswordCell.m
//  Dlt
//
//  Created by USER on 2017/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ChagepasswordCell.h"

@implementation ChagepasswordCell
{
    UILabel * passwordLabel;
    UILabel * line;
    
}
-(void)filedata:(id)data
{
    NSDictionary * dic = data;
    NSString * title = dic[@"title"];
    passwordLabel.text =title;
    
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    passwordLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 22, 17*10, 17)];
    passwordLabel.font = AdaptedFontSize(17);
    [self addSubview:passwordLabel];
    
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
    line.top_sd = passwordLabel.bottom_sd + 35;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line];
    
    
    _icon = [[UIImageView alloc]init];
    _icon.backgroundColor = [UIColor redColor];
    _icon.layer.cornerRadius = 4;
    _icon.layer.masksToBounds = YES;
    [self addSubview:_icon];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(22);
        make.width.mas_equalTo(17*10);
        make.height.mas_equalTo(17);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLabel.mas_bottom).offset(18);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(10);
    }];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(WIDTH-85);
        make.width.height.mas_equalTo (46);
    }];
    
    
    
    
    
    
}




@end
