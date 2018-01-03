//
//  DLGroupsCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupsCell.h"
#import "DLGroupsModel.h"
#import "DltUICommon.h"

static NSString * const kGroupsCellId = @"GroupsCellId";


@interface DLGroupsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GroupsImg;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupDetail;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;

@end

@implementation DLGroupsCell

+ (instancetype)creatGroupCellWithTableView:(UITableView *)tableView {
    DLGroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupsCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLGroupsCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 45, 45) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 45, 45);
    maskLayer.path = path.CGPath;
    self.GroupsImg.layer.mask = maskLayer;
}

- (void)setGroupInfo:(DLGroupsInfo *)groupInfo {
    _groupInfo = groupInfo;
    
    if (!ISNULLSTR(groupInfo.headImg)) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,groupInfo.headImg];
        [self.GroupsImg sd_setImageWithURL:DLT_URL(imageUrl) placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    }
    self.groupName.text = groupInfo.groupName;
    self.groupDetail.text = groupInfo.note;
    self.peopleCount.hidden = YES;
}

@end
