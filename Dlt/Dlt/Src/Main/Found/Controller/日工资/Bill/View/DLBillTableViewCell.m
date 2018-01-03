//
//  DLBillTableViewCell.m
//  Dlt
//
//  Created by USER on 2017/9/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLBillTableViewCell.h"

@implementation DLBillTableViewCell
{
    UILabel *_titleLable;
    UILabel *_timeLale;
    UILabel *_numbLable;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }return self;
}
-(void)setUp{
    _titleLable = [UILabel new];
    _titleLable.font = [UIFont systemFontOfSize:17];
    _timeLale = [UILabel new];
    _timeLale.font = [UIFont systemFontOfSize:14];
    _timeLale.textColor = UICOLORRGB(156, 156, 156, 1.0);
    _numbLable = [UILabel new];
    _numbLable.font = [UIFont systemFontOfSize:17];
    [self.contentView sd_addSubviews:@[_titleLable,_timeLale,_numbLable]];
    _titleLable.sd_layout
    .heightIs(25)
    .leftSpaceToView(self.contentView, 10);
    [_titleLable setSingleLineAutoResizeWithMaxWidth:200];
    _timeLale.sd_layout
    .topSpaceToView(_titleLable, 5)
    .heightIs(20)
    .leftEqualToView(_titleLable);
    [_timeLale setSingleLineAutoResizeWithMaxWidth:200];
    _numbLable.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20);
    [_numbLable setSingleLineAutoResizeWithMaxWidth:200];
}
-(void)setStatus:(DLBillStatus *)status{
    _status = status;
    _titleLable.sd_layout
    .topSpaceToView(self.contentView, 10);
    if ([status.type isEqualToString:@"1"]) {
        _titleLable.text = @"推广收入";
        _numbLable.text = [NSString stringWithFormat:@"+%.2f",[status.money integerValue]/100.0];
    }else{
        _titleLable.text = @"提取";
        _numbLable.text = [NSString stringWithFormat:@"-%.2f",[status.money integerValue]/100.0];
    }
     _timeLale.text=  status.time;
    
}
-(void)setPayIn:(NSString *)payIn{
    _titleLable.text = @"收入";
    _titleLable.sd_layout
    .centerYEqualToView(self.contentView);
    _numbLable.text = [NSString stringWithFormat:@"+%.2f",[payIn integerValue]/100.0];
}
-(void)setPayOut:(NSString *)payOut{
    _titleLable.text = @"提取";
    _titleLable.sd_layout
    .centerYEqualToView(self.contentView);
    _numbLable.text = [NSString stringWithFormat:@"-%.2f",[payOut integerValue]/100.0];
}
@end
