//
//  DLSeachGroupsCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLSeachGroupsCell.h"
#import "DLGroupsModel.h"
#import "DltUICommon.h"


static NSString * const kSeachGroupsCellId = @"SeachGroupsCellId";


@interface DLSeachGroupsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property(nonatomic, strong) UILabel * numberofLabel;
@property(nonatomic, assign) NSInteger groupNumber;

@end


@implementation DLSeachGroupsCell

+ (instancetype)creatSeachGroupCellWithTableView:(UITableView *)tableView {
    DLSeachGroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeachGroupsCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLSeachGroupsCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    UIBezierPath *btnPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 55, 30) cornerRadius:15];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = btnPath.CGPath;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [shapeLayer strokeColor];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.enterBtn.layer addSublayer:shapeLayer];
  
  self.enterBtn.hidden = YES;
  
  
//  self.numberofLabel = [[UILabel alloc]init];
//  self.numberofLabel.font = AdaptedFontSize(8);
//  self.numberofLabel.textAlignment = NSTextAlignmentCenter;
//  self.numberofLabel.backgroundColor = [UIColor colorWithHexString:@"3acff6"];
//  [self addSubview:self.numberofLabel];
//  
//  [_numberofLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.mas_equalTo(37);
//    make.height.mas_equalTo(16);
//    make.left.equalTo(self.groupName.mas_right).mas_offset(10);
//    make.centerY.equalTo(self.groupName);
//  }];
//  
//  self.groupNumber = 0;
}

- (void)setGroupNumber:(NSInteger)groupNumber{
  _groupNumber = groupNumber;
  
//  self.numberofLabel.hidden = groupNumber == 0;
//  self.numberofLabel.text = [NSString stringWithFormat:@"%d 人",(int)groupNumber];
}


- (void)setInfoModel:(DLGroupsInfo *)infoModel {
    _infoModel = infoModel;
    
    if (!ISNULLSTR(infoModel.headImg)) {
        NSString *imageString = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,infoModel.headImg];
        [self.headImg sd_setImageWithURL:DLT_URL(imageString) placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    }
    self.groupName.text = infoModel.name;
    if (ISNULLSTR(infoModel.name)) {
       self.groupName.text = infoModel.groupName;
    }
    if (infoModel.isMember) {
        [self.enterBtn setTitle:@"进入" forState:UIControlStateNormal];
    } else {
        [self.enterBtn setTitle:@"加入" forState:UIControlStateNormal];
    }
    self.detail.text = infoModel.note;
   self.groupNumber = [infoModel.count integerValue];
}



@end
