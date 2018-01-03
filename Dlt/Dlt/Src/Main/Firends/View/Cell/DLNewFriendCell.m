//
//  DLNewFriendCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLNewFriendCell.h"

static NSString * const kNewFriendCellID = @"NewFriendCellID";

@interface DLNewFriendCell ()

@end

@implementation DLNewFriendCell

+ (instancetype)creatNewFriendCellWithTableView:(UITableView *)tableView {
    DLNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewFriendCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLNewFriendCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *btnPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 72, 32) cornerRadius:6];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = btnPath.CGPath;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [shapeLayer strokeColor];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.refuseBtn.layer addSublayer:shapeLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 45, 45) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 45, 45);
    maskLayer.path = path.CGPath;
    self.headImg.layer.mask = maskLayer;
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 72, 32) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = CGRectMake(0, 0, 72, 32);
    maskLayer1.path = path1.CGPath;
    self.agreeBtn.layer.mask = maskLayer1;
    
    self.endBtn.layer.cornerRadius = 6;
    self.endBtn.layer.masksToBounds = YES;
    self.endBtn.layer.borderWidth = 1;
    self.endBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (IBAction)refuseButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dl_friendCell:clickButtonWithTag:)]) {
        [self.delegate dl_friendCell:self clickButtonWithTag:sender.tag];
    }
}
- (IBAction)agreeButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dl_friendCell:clickButtonWithTag:)]) {
        [self.delegate dl_friendCell:self clickButtonWithTag:sender.tag];
    }

}


@end
