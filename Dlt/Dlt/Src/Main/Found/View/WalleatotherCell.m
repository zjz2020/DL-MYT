//
//  WalleatotherCell.m
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "WalleatotherCell.h"
@interface WalleatotherCell ()
@property(nonatomic,strong)UILabel * topline;
@property(nonatomic,strong)UIButton * transferBtn;
@property(nonatomic,strong)UIButton * topupBtn;
@property(nonatomic,strong)UIButton * wageBtn;
@property(nonatomic,strong)UILabel * bottemline;


@end
@implementation WalleatotherCell
-(void)ba_setupCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =[UIColor colorWithHexString:@"f6f6f6"];

}
-(void)ba_buildSubview
{
//    self.topline = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
//    self.topline.width_sd = WIDTH;
//    self.topline.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
//    [self addSubview:self.topline];
    
    [self transfer];
    
    self.topupBtn = [[UIButton alloc]init];
//    self.topupBtn.left_sd = self.transferBtn.right_sd +1;
//    self.topupBtn.titleLabel.width_sd = 300;
//    self.topupBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.topupBtn setImage:[UIImage imageNamed:@"wallet_04"] forState:UIControlStateNormal];
    [self.topupBtn setTitle:@"转账" forState:UIControlStateNormal];
    [self.topupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.topupBtn.titleLabel.font = AdaptedFontSize(12);
    [self.topupBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 43, 40, 41)];
    [self.topupBtn setTitleEdgeInsets:UIEdgeInsetsMake(41, 0, 0, 41)];
    self.topupBtn.backgroundColor =[UIColor whiteColor];
    [self.topupBtn addTarget:self action:@selector(topup:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.topupBtn];
//
    self.wageBtn = [[UIButton alloc]init];
//    self.wageBtn.left_sd = self.topupBtn.right_sd +1;
    self.wageBtn.titleLabel.width_sd = 100;
//    self.wageBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.wageBtn addTarget:self action:@selector(wage:) forControlEvents:UIControlEventTouchUpInside];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"UserIsPromoter"]) {
         [self.wageBtn setTitle:@"日工资" forState:UIControlStateNormal];
            [self.wageBtn setImage:[UIImage imageNamed:@"wallet_06"] forState:UIControlStateNormal];

    }else{
         [self.wageBtn setTitle:@"申请推广员" forState:UIControlStateNormal];
        [self.wageBtn setImage:[UIImage imageNamed:@"friends_426"] forState:UIControlStateNormal];

    }
   
    [self.wageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.wageBtn.titleLabel.font = AdaptedFontSize(12);
    [self.wageBtn.titleLabel sizeToFit];
    [self.wageBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 48, 40, 41)];
    [self.wageBtn setTitleEdgeInsets:UIEdgeInsetsMake(41, 0, 0, 33)];
    self.wageBtn.backgroundColor =[UIColor whiteColor];
    [self addSubview:self.wageBtn];
     CGFloat CellH = WIDTH/3;
    [_transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(CellH);
        make.height.mas_equalTo(99);


    }];
   
    [_topupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_transferBtn.mas_right).offset(1);
        make.width.mas_equalTo(CellH);
        make.height.mas_equalTo(99);
    }];
    
    [_wageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topupBtn.mas_right).offset(1);
        make.width.mas_equalTo(CellH);
        make.height.mas_equalTo(99);
    }];
    
}
//收款
-(void)transfer{
    self.transferBtn = [[UIButton alloc]init];
    [self.transferBtn setImage:[UIImage imageNamed:@"wallet_30"] forState:UIControlStateNormal];
    //    self.transferBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.transferBtn setTitle:@"收款" forState:UIControlStateNormal];
    [self.transferBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.transferBtn.titleLabel.font = AdaptedFontSize(12);
    [self.transferBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 43, 40, 41)];
    [self.transferBtn setTitleEdgeInsets:UIEdgeInsetsMake(41, 0, 0, 41)];
    self.transferBtn.backgroundColor =[UIColor whiteColor];
    [self.transferBtn addTarget:self action:@selector(transfer:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.transferBtn];
}
-(void)transfer:(UIButton *)btn
{
    if (_transferClick) {
        _transferClick(btn);
    }
}
-(void)topup:(UIButton *)btn
{
    if (_topupClick) {
        _topupClick(btn);
    }
}
-(void)wage:(UIButton *)btn
{
    if (_wageClick) {
        _wageClick(btn);
    }
}
@end
