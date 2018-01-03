//
//  SelectorPayCell.m
//  Dlt
//
//  Created by USER on 2017/6/5.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SelectorPayCell.h"

@implementation SelectorPayCell
{
    UILabel * payType;
}
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)file:(id)data
{
    NSDictionary  *  dic = data;
    NSString * title = dic[@"title"];
    payType.text = title;
}
-(void)ba_buildSubview
{
    payType = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 15, WIDTH, 17)];
//    payType.text = @"支付方式";
    payType.font = AdaptedFontSize(17);
    [self addSubview:payType];
    
    UILabel * line = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 54, 0, 0.5)];
    line.width_sd = WIDTH;
    line.backgroundColor = [UIColor colorWithHexString:LINE];
    [self addSubview:line];
    
    
}
+(CGFloat)CellH
{
    return 54;
}
@end
