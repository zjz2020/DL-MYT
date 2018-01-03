//
//  DLVulgarTycoonTableViewCell.m
//  Dlt
//
//  Created by USER on 2017/9/23.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLVulgarTycoonTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
@implementation DLVulgarTycoonTableViewCell

{
    UILabel *_timeLable;
    UILabel *_titleLabel;
    UILabel *_stateLable;
    UIImageView *_btnImage;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }return self;
}
-(void)setUp{

    _timeLable = [UILabel new];
    _timeLable.font = [UIFont systemFontOfSize:14];
    _timeLable.textColor = [UIColor grayColor];
    _btnImage = [UIImageView new];
    _titleLabel = [UILabel new];
    UIView *line = [UIView new];
    line.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    _stateLable = [UILabel new];
    [self.contentView sd_addSubviews:@[_stateLable,_btnImage,_titleLabel,line,_timeLable]];
    _stateLable.sd_layout
    .topSpaceToView(self.contentView, 25)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(20);
    _btnImage.sd_layout
    .centerYEqualToView(_stateLable)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(30)
    .widthIs(58);
    _titleLabel.sd_layout
    .topSpaceToView(_stateLable, 20)
    .leftEqualToView(_stateLable)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [_titleLabel setMaxNumberOfLinesToShow:3];
    line.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    _timeLable.sd_layout
    .topSpaceToView(line, 10)
    .leftEqualToView(_stateLable)
    .heightIs(15);
    [_timeLable setSingleLineAutoResizeWithMaxWidth:200];
    [_stateLable setSingleLineAutoResizeWithMaxWidth:200];
    
     [self setupAutoHeightWithBottomView:_timeLable bottomMargin:12];
}

-(void)setStatus:(DLTaskStatus *)status{
    _status = status;
    _timeLable.text = status.pubTime;
    NSArray *array = [status.text componentsSeparatedByString:@"{{"];
    if ([status.type isEqualToString:@"2"]) {
        _btnImage.image = [UIImage imageNamed:@"tuwen"];
        _titleLabel.text = array[0];
    }else{
        _btnImage.image = [UIImage imageNamed:@"lianjie"];
        _titleLabel.text = status.title;
    }
    
    if ([status.status isEqualToString:@"1"]) {
        _stateLable.text = @"进行中";
        _stateLable.textColor = [UIColor redColor];
    }else if([status.status isEqualToString:@"2"]){
        _stateLable.text = @"已下架";
        _stateLable.textColor = [UIColor grayColor];
    }else if([status.status isEqualToString:@"3"]){
        _stateLable.text = @"未审核";
        _stateLable.textColor = [UIColor grayColor];
    }else if([status.status isEqualToString:@"4"]){
        _stateLable.text = @"未通过";
        _stateLable.textColor = [UIColor grayColor];
    }
    
}
@end
