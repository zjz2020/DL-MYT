//
//  DLTaskTableViewCell.m
//  Dlt
//
//  Created by USER on 2017/9/20.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTaskTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
@implementation DLTaskTableViewCell
{
    UIImageView *_iconImage;
    UILabel *_nickLable;
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
    _iconImage = [UIImageView new];
    _nickLable = [UILabel new];
    _timeLable = [UILabel new];
    _timeLable.font = [UIFont systemFontOfSize:14];
    _timeLable.textColor = [UIColor grayColor];
    _btnImage = [UIImageView new];
    _titleLabel = [UILabel new];
    UIView *line = [UIView new];
    
    line.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    _stateLable = [UILabel new];
 
    [self.contentView sd_addSubviews:@[_iconImage,_nickLable,_timeLable,_btnImage,_titleLabel,line,_stateLable]];
    _iconImage.sd_layout
    .topSpaceToView(self.contentView, 20)
    .heightIs(40)
    .widthIs(40)
    .leftSpaceToView(self.contentView, 10);
    _nickLable.sd_layout
    .topEqualToView(_iconImage)
    .leftSpaceToView(_iconImage, 10)
    .heightIs(20);
    [_nickLable setSingleLineAutoResizeWithMaxWidth:200];
    _timeLable.sd_layout
    .topSpaceToView(_nickLable, 3)
    .leftEqualToView(_nickLable)
    .heightIs(15);
    [_timeLable setSingleLineAutoResizeWithMaxWidth:200];
    _btnImage.sd_layout
    .centerYEqualToView(_iconImage)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(30)
    .widthIs(58);
    _titleLabel.sd_layout
    .topSpaceToView(_iconImage, 20)
    .leftEqualToView(_iconImage)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [_titleLabel setMaxNumberOfLinesToShow:3];
    line.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    _stateLable.sd_layout
    .topSpaceToView(line, 12)
    .rightEqualToView(_titleLabel)
    .heightIs(20);
    [_stateLable setSingleLineAutoResizeWithMaxWidth:200];
    
    [self setupAutoHeightWithBottomView:_stateLable bottomMargin:12];
}
-(void)setStatus:(DLTaskStatus *)status{
    _status = status;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,status.userHeadImg]]];
    NSArray *array = [status.text componentsSeparatedByString:@"{{"];
    if ([status.type isEqualToString:@"2"]) {
        _btnImage.image = [UIImage imageNamed:@"tuwen"];
        _titleLabel.text = array[0];
    }else{
        _btnImage.image = [UIImage imageNamed:@"lianjie"];
        _titleLabel.text = status.title;
    }
    _nickLable.text = status.userName;
    _timeLable.text = status.pubTime;
    if ([status.adStatus isEqualToString:@"1"]) {
        _stateLable.text = @"进行中";
        _stateLable.textColor = [UIColor redColor];
    }else if([status.adStatus isEqualToString:@"2"]){
        _stateLable.text = @"已下架";
        _stateLable.textColor = [UIColor grayColor];
    }else if([status.adStatus isEqualToString:@"3"]){
        _stateLable.text = @"未审核";
        _stateLable.textColor = [UIColor grayColor];
    }else if([status.adStatus isEqualToString:@"4"]){
        _stateLable.text = @"未通过";
        _stateLable.textColor = [UIColor grayColor];
    }
}

@end
