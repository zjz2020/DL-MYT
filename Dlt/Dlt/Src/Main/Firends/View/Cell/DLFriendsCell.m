//
//  DLFriendsCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLFriendsCell.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"
#import "UIView+Extension.h"

static NSString * const kFriendsCellId = @"FriendsCellId";

@interface DLFriendsCell ()

@end


@implementation DLFriendsCell

+ (instancetype)creatFriendsCellWithTableView:(UITableView *)tableView {
    DLFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendsCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLFriendsCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImg ui_setCornerRadius:6];
    
    self.headerImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageViewAction:)];
    [self.headerImg addGestureRecognizer:tapges];
}

- (void)setFrinedsInfo:(DLFriendsInfo *)frinedsInfo {
    _frinedsInfo = frinedsInfo;
    if (!ISNULLSTR(frinedsInfo.headImg)) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,frinedsInfo.headImg];
        [self.headerImg sd_setImageWithURL:DLT_URL(imageUrl) placeholderImage:nil];
    }
    self.nickName.text = frinedsInfo.name;
    self.msgContent.text = frinedsInfo.note;
}

- (void)tapHeadImageViewAction:(UITapGestureRecognizer *)tap {
    if (self.headImgBlock) {
        self.headImgBlock(tap.view.tag);
    }
    if (self.clickBlock) {
        self.clickBlock(self.frinedsInfo);
    }
}

@end
