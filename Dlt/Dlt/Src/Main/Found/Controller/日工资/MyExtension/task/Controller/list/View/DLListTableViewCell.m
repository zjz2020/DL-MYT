//
//  DLListTableViewCell.m
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLListTableViewCell.h"

@implementation DLListTableViewCell
{
    UIImageView *_iconImage;
    UILabel *_nickLabel;
    UILabel *_autograph;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }return self;
}
-(void)setUp{
    _iconImage = [UIImageView new];
    _nickLabel = [UILabel new];
    _autograph = [UILabel new];
    _autograph.textColor = [UIColor grayColor];
    _autograph.font = [UIFont systemFontOfSize:14];
  
    [self.contentView sd_addSubviews:@[_iconImage,_nickLabel,_autograph]];
    _iconImage.sd_layout
    .topSpaceToView(self.contentView, 12.5)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(45)
    .widthIs(45);
    _nickLabel.sd_layout
    .topEqualToView(_iconImage)
    .leftSpaceToView(_iconImage, 10)
    .heightIs(20);
    [_nickLabel setSingleLineAutoResizeWithMaxWidth:200];
    _autograph.sd_layout
    .bottomEqualToView(_iconImage)
    .leftEqualToView(_nickLabel)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(15);
    
}
-(void)setStatus:(DLListStatus *)status{
    _status = status;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,status.headImg]]];
    _nickLabel.text = status.userName;
    _autograph.text = status.note;
}

@end
