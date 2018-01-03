//
//  DLGroupMemberCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupMemberCell.h"
#import "DLGroupMemberModel.h"


static NSString * const kGroupMemberCellId = @"GroupMemberCellId";

@interface DLGroupMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation DLGroupMemberCell

+ (instancetype)creatGroupMemberCellWith:(UITableView *)tableView {
    DLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupMemberCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLGroupMemberCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 45, 45) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 45, 45);
    maskLayer.path = path.CGPath;
    self.headImg.layer.mask = maskLayer;
    
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageViewAction:)];
    [self.headImg addGestureRecognizer:tap];
}

- (void)setInfoModel:(DLGroupMemberInfo *)infoModel {
    _infoModel = infoModel;
    self.selectedImg.hidden = YES;
//    switch ([infoModel.Role intValue]) {
//        case 3: {
//            self.selectedImg.hidden = YES;
//        }
//            break;
//        case 2: {
//            self.selectedImg.image = [UIImage imageNamed:@"group_choose_selected"];
//        }
//            break;
//        default:
//            break;
//    }
    self.nickName.text = infoModel.Remrk;
    NSString *headImage = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,infoModel.headImg];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    if ([infoModel.sex isEqualToString:@"1"]) {
        self.sexLabel.text = @"男   ";
        self.sexLabel.backgroundColor = [UIColor colorWithHexString:@"0089F1"];
    } else if ([infoModel.sex isEqualToString:@"2"]) {
        self.sexLabel.text = @"女   ";
        self.sexLabel.backgroundColor = [UIColor colorWithHexString:@"FF7B7B"];
    } else {
        self.sexLabel.text = @"保密   ";
        self.sexLabel.backgroundColor = [UIColor colorWithHexString:@"FF7B7B"];
    }
    if (infoModel.isSetManager) {
        self.selectedImg.image = [UIImage imageNamed:@"group_choose_selected"];
    }
}

- (void)tapHeadImageViewAction:(UITapGestureRecognizer *)tap {
    if (self.headImgBlock) {
        self.headImgBlock(self.infoModel);
    }
}

@end
