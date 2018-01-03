//
//  SelectorphoteCell.m
//  Dlt
//
//  Created by USER on 2017/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SelectorphoteCell.h"
@interface SelectorphoteCell ()
@property(nonatomic,strong)UILabel * topLine;
@property(nonatomic,strong)UILabel * albumLabel;
@property(nonatomic,strong)UILabel * line;


@end


@implementation SelectorphoteCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview
{
//    self.topLine = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
//    self.topLine.width_sd = WIDTH;
//    self.topLine.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
//    [self addSubview:self.topLine];
    self.albumLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(15, 13, WIDTH, 14)];
    self.albumLabel.font = AdaptedFontSize(14);
    self.albumLabel.text = @"相册";
    [self addSubview:self.albumLabel];
    
    self.line = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    self.line.top_sd = self.albumLabel.bottom_sd + 15;
    self.line.width_sd = WIDTH;
    self.line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:self.line];

    [_albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (15);
        make.top.mas_equalTo(13);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(14);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_albumLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(WIDTH);
    }];
    
    

    
     
    
    
}

@end
