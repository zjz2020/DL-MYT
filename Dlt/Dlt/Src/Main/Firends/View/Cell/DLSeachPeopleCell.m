//
//  DLSeachPeopleCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLSeachPeopleCell.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"

static NSString * const kSeachPeopleCellId = @"SeachPeopleCellId";


@interface DLSeachPeopleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *detail;

@end


@implementation DLSeachPeopleCell

+ (instancetype)creatSeachPeopleCellWithTableView:(UITableView *)tableView {
    DLSeachPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeachPeopleCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLSeachPeopleCell" owner:nil options:nil] lastObject];
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
    
    // 给button画线和圆角
    UIBezierPath *btnPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 85, 30) cornerRadius:15];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = btnPath.CGPath;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [shapeLayer strokeColor];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.addBtn.layer addSublayer:shapeLayer];
}
- (IBAction)addNewFriendsAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(seachPeopleCell:clickAddFriendWithIndx:)]) {
        [self.delegate seachPeopleCell:self clickAddFriendWithIndx:sender.tag];
    }
}

- (void)setInfoModel:(DLFriendsInfo *)infoModel {
    _infoModel = infoModel;
    
    if (!ISNULLSTR(infoModel.headImg)) {
        NSString *imageString = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,infoModel.headImg];
        [self.headImg sd_setImageWithURL:DLT_URL(imageString) placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    }
    self.nickName.text = infoModel.name;
    self.detail.text = @"";
    if (infoModel.isFriend) {
        [self.addBtn setTitle:@"发消息" forState:UIControlStateNormal];
    }
}

@end
