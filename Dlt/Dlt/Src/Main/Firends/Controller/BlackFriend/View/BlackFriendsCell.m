//
//  BlackFriendsCell.m
//  Dlt
//
//  Created by USER on 2017/8/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BlackFriendsCell.h"
#import "SDAutoLayout.h"
#import "UIImage+CompressImage.h"
@implementation BlackFriendsCell
{
    UIImageView *_iconImage;
    UILabel *_nickLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }return self;
}
-(void)setup{
    _iconImage = [UIImageView new];
    _nickLabel = [UILabel new];
    _nickLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView sd_addSubviews:@[_iconImage,_nickLabel]];
   
    _iconImage.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(40)
    .widthIs(40);
    _nickLabel.sd_layout
    .centerYEqualToView(_iconImage)
    .heightIs(25)
    .leftSpaceToView(_iconImage, 10);
    [_nickLabel setSingleLineAutoResizeWithMaxWidth:200];
}

-(void)setStatus:(BlackFriendStatus *)status{
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,status.headImg];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    _nickLabel.text = status.name;
}
@end
