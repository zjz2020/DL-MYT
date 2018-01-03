//
//  JoingroupCell.m
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "JoingroupCell.h"
@interface JoingroupCell ()


@end
@implementation JoingroupCell
{
    UILabel * joingroup;
    UILabel * line;

}

-(void)ba_setupCell
{
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    joingroup = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 15, 28*4, 14)];
    joingroup.font =AdaptedFontSize(14);
    joingroup.text = @"加入群聊";
    [self addSubview:joingroup];
    
    line = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    line.backgroundColor =[UIColor colorWithHexString:@"f6f6f6"];
    line.top_sd = joingroup.bottom_sd + 15;
    line.width_sd = WIDTH;
    [self addSubview:line];
    
    
}

@end
