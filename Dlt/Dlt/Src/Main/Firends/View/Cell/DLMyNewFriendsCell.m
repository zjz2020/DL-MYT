//
//  DLMyNewFriendsCell.m
//  Dlt
//
//  Created by Liuquan on 17/6/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLMyNewFriendsCell.h"
#import "UIView+Extension.h"
#import "DLMyNewFriendModel.h"


static NSString * const kMyNewFriendsCellId = @"MyNewFriendsCellId";

@interface DLMyNewFriendsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *refuseLabel;

@end


@implementation DLMyNewFriendsCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView {
    DLMyNewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyNewFriendsCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLMyNewFriendsTableViewController" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.refuseLabel.hidden = YES;
    [self.headImg ui_setCornerRadius:6];
    [self.refuseBtn ui_setCornerRadius:6 withBorderColor:[UIColor colorWithHexString:@"cacaca"] borderWidth:1];
    [self.agreeBtn ui_setCornerRadius:6 withBackgroundColor:[UIColor colorWithHexString:@"0089F1"]];
    
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkThisUserInfomation:)];
    [self.headImg addGestureRecognizer:tap];
}


- (void)setInfoModel:(DLMyNewFriendModel *)infoModel {
    _infoModel = infoModel;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,infoModel.headImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    
    self.nickName.text = infoModel.name;
    self.detailLabel.text = [NSString stringWithFormat:@"“%@”请求加你为好友",infoModel.name];
    self.refuseLabel.hidden = YES;
    self.agreeBtn.hidden = NO;
    self.refuseBtn.hidden = NO;
    if ([infoModel.status integerValue] == 202) {
        self.refuseLabel.hidden = YES;
    }
    if ([infoModel.status integerValue] == 200) {
        self.refuseLabel.text = @"已同意";
    }
    if ([infoModel.status integerValue] == 201) {
        self.refuseLabel.text = @"已拒绝";
        
    }
    if ([infoModel.status integerValue] == 201 || [infoModel.status integerValue] == 200) {
        self.agreeBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
        self.refuseLabel.hidden = NO;
    }
}

- (IBAction)agreeButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myNewFriendCell:clickRAgreeButtonWtihModel:)]) {
        [self.delegate myNewFriendCell:self clickRAgreeButtonWtihModel:self.infoModel];
    }

}

- (IBAction)refuseButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myNewFriendCell:clickRefuseButtonWtihModel:)]) {
        [self.delegate myNewFriendCell:self clickRefuseButtonWtihModel:self.infoModel];
    }
}

- (void)checkThisUserInfomation:(UITapGestureRecognizer *)tapGes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myNewFriendCell:clickHeadImageSeeUserInfomation:)]) {
        [self.delegate myNewFriendCell:self clickHeadImageSeeUserInfomation:self.infoModel];
    }
}

@end
