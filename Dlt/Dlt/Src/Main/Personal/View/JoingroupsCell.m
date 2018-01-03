//
//  JoingroupsCell.m
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "JoingroupsCell.h"
@interface JoingroupsCell ()
@property(nonatomic,strong)UIImageView * iconImage;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * numberofLabel;
@property(nonatomic,strong)UILabel * deputyLabel;
@property(nonatomic,strong)UIButton * addinBtn;
@property(nonatomic,strong)UILabel * line;


@end
@implementation JoingroupsCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
    self.iconImage = [[UIImageView alloc]initWithFrame:RectMake_LFL(15, 14.5, 45, 45)];
    self.iconImage.image = [UIImage imageNamed:@"friends_01"];
    [self addSubview:self.iconImage];
    
    
    self.contentLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 35/2, 17*6, 17)];
    self.contentLabel.left_sd = self.iconImage.right_sd + 15;
    self.contentLabel.font = AdaptedFontSize(17);
    self.contentLabel.textColor = [UIColor colorWithHexString:@"007bf5"];
    self.contentLabel.text = @"杭州车友会";
    [self addSubview:self.contentLabel];
    
    self.deputyLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 200, 14)];
    self.deputyLabel.left_sd = self.iconImage.right_sd + 15;
    self.deputyLabel.top_sd = self.contentLabel.bottom_sd + 7.5;
    self.deputyLabel.font = AdaptedFontSize(14);
    self.deputyLabel.textColor = [UIColor colorWithHexString:@"9c9c9c"];
    self.deputyLabel.text = @"加入群员，请遵守游戏";
    [self addSubview:self.deputyLabel];
    
    self.numberofLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 16, 14*4, 13)];
    self.numberofLabel.left_sd = self.contentLabel.right_sd + 12;
    self.numberofLabel.font = AdaptedFontSize(14);
    self.numberofLabel.backgroundColor = [UIColor colorWithHexString:@"3acff6"];
    self.numberofLabel.text = @"2000人";
    [self addSubview:self.numberofLabel];
    
    self.addinBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 17, 55, 30)];
    self.addinBtn.left_sd = WIDTH - 30-30;
    self.addinBtn.titleLabel.font = AdaptedFontSize(17);
    [self.addinBtn setTitle:@"加入" forState:UIControlStateNormal];
    [self.addinBtn setTitleColor:[UIColor colorWithHexString:@"007bf5"] forState:UIControlStateNormal];
    self.addinBtn.layer.borderColor = [UIColor colorWithHexString:@"9c9c9c"].CGColor;
    self.addinBtn.layer.borderWidth = 0.5;
    self.addinBtn.layer.cornerRadius = 10;
    self.addinBtn.layer.masksToBounds = YES;;
    [self addSubview:self.addinBtn];
    
    self.line = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 75, 0, 0.5)];
    self.line.width_sd = WIDTH;
    self.line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:self.line];
    
    
}

@end
