//
//  ClassinfomationCell.m
//  Dlt
//
//  Created by USER on 2017/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ClassinfomationCell.h"

static NSString * const kClassInfomationCellId = @"ClassInfomationCellId";


@interface ClassinfomationCell ()

@property (nonatomic, assign) int personalPropertys;

@end

@implementation ClassinfomationCell
{
    UILabel *_personalProperty;
//    UILabel * line;
//    UILabel * hometownLabel;
//    UILabel * emotional;
    UILabel *_professional;

}


-(void)ba_buildSubview
{
    _professional = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 300, 45)];
    _professional.font = [UIFont systemFontOfSize:16];
    [self addSubview:_professional];
    
//    line = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
//    line.top_sd = infoLabel.bottom_sd + 15;
//    line.width_sd = WIDTH;
//    line.backgroundColor = [UIColor colorWithHexString:@"CECECE"];
//    [self addSubview:line];
  
    
//    hometownLabel  = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 0, 0, 17)];
//    hometownLabel.top_sd = line.bottom_sd + 45/2;
//    hometownLabel.width_sd = 34*5;
//    hometownLabel.font = AdaptedFontSize(17);
//    hometownLabel.text = @"家乡: 浙江杭州";
//    [self addSubview:hometownLabel];
  
    
//    emotional = [[UILabel alloc]initWithFrame:RectMake_LFL(hometownLabel.left_sd, 0, 0, 17)];
//    emotional.top_sd = hometownLabel.bottom_sd + 13;
//    emotional.width_sd = 34*5;
//    emotional.font = AdaptedFontSize(17);
//    emotional.text = @"情感状态: 保密";
//    [self addSubview:emotional];
//    
    _personalProperty = [[UILabel alloc]initWithFrame:RectMake_LFL(_professional.left,38,_professional.width, 40)];
  _personalProperty.font = [UIFont systemFontOfSize:16];
    [self addSubview:_personalProperty];
  
   self.personalPropertys = 0;
 
}

- (void)setPersonalPropertys:(int)personalPropertys{
  _personalPropertys = personalPropertys;
  
  _personalProperty.text = @"...";
}

- (void)setModel:(DLTUserProfile *)model {
    _model = model;
  
  self.personalPropertys = [model.balance intValue];
  _professional.text = (model.area.length > 0)? [NSString stringWithFormat:@"家乡：%@",model.area] : @"家乡：无";
}


@end
