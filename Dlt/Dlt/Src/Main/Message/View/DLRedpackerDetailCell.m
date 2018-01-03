//
//  DLRedpackerDetailCel.m
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLRedpackerDetailCell.h"
#import "UIView+Extension.h"
#import "DLRedpackerRecordModel.h"

@interface DLRedpackerDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIImageView *maxSign;

@end

static NSString * const kRedpackerDetailCellId = @"RedpackerDetailCellId";

@implementation DLRedpackerDetailCell
+ (instancetype)creatRedpackerCellWithTableView:(UITableView *)tableView {
    DLRedpackerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kRedpackerDetailCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLRedpackerDetailTableViewVC" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImg ui_setCornerRadius:6];
    
    self.maxSign.hidden = YES;
}

- (void)setRecordModel:(DLRedpackerRecord *)recordModel {
    _recordModel = recordModel;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,recordModel.userHeadImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    if (ISNULLSTR(recordModel.userHeadImg)) {
         [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,recordModel.userHead]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    }
    self.nickName.text = recordModel.userName;
    self.count.text = [NSString stringWithFormat:@"%.2f",[recordModel.amount floatValue] / 100.0];
    self.time.text = [RCKitUtility ConvertMessageTime:[recordModel.timeStamp longLongValue]];
    self.maxSign.hidden = recordModel.isBest ? NO : YES;
    self.time.hidden = recordModel.isFriendPacket;
}

@end
