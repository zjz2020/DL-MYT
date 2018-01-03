//
//  SingelCell.m
//  Dlt
//
//  Created by USER on 2017/6/16.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SingelCell.h"

@implementation SingelCell
{
    UILabel * phoneLabel;
    UILabel * line;
}
-(void)file:(id)data
{
    NSDictionary * dic =data;
    NSString * title = dic[@"title"];
    phoneLabel.text = title;
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    phoneLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 19, 17*4, 17)];
    phoneLabel.font = AdaptedFontSize(17);
    [self addSubview:phoneLabel];
    
    line =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.top_sd = phoneLabel.bottom_sd + 15;
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:line];
    
    _singer = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 54)];
    _singer.userInteractionEnabled = YES;
    _singer.left= phoneLabel.right_sd + 20;
    _singer.width = 250;
    _singer.font= AdaptedFontSize(17);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sing)];
    [_singer addGestureRecognizer:tap];
    [self addSubview:_singer];
    
    
}
-(void)sing
{
    if (_issinger) {
        _issinger();
    }
}


@end
