//
//  MaYiOpenView.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiOpenView.h"

@interface MaYiOpenView()

@property (nonatomic , strong)  UIView           * backView; //红色背景View
@property (nonatomic , strong)  UIImageView      * topImageView; //上部背景图
@property (nonatomic , strong)  UILabel          * textLabel1;   //天上掉钱
@property (nonatomic , strong)  UILabel          * textLabel2;   //不捡白不捡
@property (nonatomic , strong)  UIView           * leftLine;  //左边白线
@property (nonatomic , strong)  UIView           * rightLine; //右边白线
@property (nonatomic , strong)  UILabel          * textLabel3;   //变成蚂蚁抢红包
@property (nonatomic , strong)  UIImageView      * openImageView; //按钮背景图

@property (nonatomic , strong)  UILabel          * textLabel4;   //说明1
@property (nonatomic , strong)  UILabel          * textLabel5;   //说明2

@end


@implementation MaYiOpenView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.backView];
        [self.backView addSubview:self.topImageView];
        [self.backView addSubview:self.textLabel1];
        [self.backView addSubview:self.textLabel2];
        [self.backView addSubview:self.textLabel3];
        [self.backView addSubview:self.leftLine];
        [self.backView addSubview:self.rightLine];
        [self.backView addSubview:self.openImageView];
        [self.backView addSubview:self.openBtn];
        [self.backView addSubview:self.textLabel4];
        [self.backView addSubview:self.textLabel5];
    }
    return self;
}

#pragma -mark  -------------    私有方法  ------------
//判断是否有cityCode
- (BOOL)judeCityCode{
    if (![DLTUserCenter userCenter].cityCode || [DLTUserCenter userCenter].cityCode.length < 4) {
        [DLAlert alertWithText:@"蚂蚁未获取到你的定位,请检查设置是否开启定位" afterDelay:3];
        return NO;
    }
    return YES;
}
-(void)openBtnClick{
    if (![self judeCityCode]) {
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(openViewBtnClick)]){
        [self.delegate openViewBtnClick];
    }
}

#pragma -mark  -------------    初始化  ------------

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49)];
        _backView.backgroundColor = SDColor(229, 15, 57, 1);
    }
    return _backView;
}

-(UIImageView *)topImageView{
    if(!_topImageView){
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, xyzH(421))];
        _topImageView.image = [UIImage imageNamed:@"mayi_01"];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImageView;
}

-(UILabel *)textLabel1{
    if(!_textLabel1){
        _textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, xyzH(260), kScreenWidth, xyzH(50))];
        _textLabel1.text = @"天上掉钱";
        _textLabel1.textAlignment = NSTextAlignmentCenter;
        _textLabel1.textColor = [UIColor whiteColor];
        _textLabel1.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
    }
    return _textLabel1;
}

-(UILabel *)textLabel2{
    if(!_textLabel2){
        _textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, xyzH(310), kScreenWidth, xyzH(50))];
        _textLabel2.text = @"不捡白不捡";
        _textLabel2.textAlignment = NSTextAlignmentCenter;
        _textLabel2.textColor = [UIColor whiteColor];
        _textLabel2.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
    }
    return _textLabel2;
}

-(UILabel *)textLabel3{
    if(!_textLabel3){
        _textLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, xyzW(120), xyzH(30))];
        _textLabel3.center = CGPointMake(kScreenWidth/2, xyzH(385));
        _textLabel3.text = @"变成蚂蚁抢红包";
        _textLabel3.textAlignment = NSTextAlignmentCenter;
        _textLabel3.textColor = [UIColor whiteColor];
        _textLabel3.font = [UIFont systemFontOfSize:xyzW(16)];
    }
    return _textLabel3;
}

-(UIView *)leftLine{
    if(!_leftLine){
        _leftLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 120, xyzH(385), 50, 1)];
        _leftLine.backgroundColor = [UIColor whiteColor];
    }
    return _leftLine;
}

-(UIView *)rightLine{
    if(!_rightLine){
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2 + 50 + 20 , xyzH(385), 50, 1)];
        _rightLine.backgroundColor = [UIColor whiteColor];
    }
    return _rightLine;
}

-(UIImageView *)openImageView{
    if(!_openImageView){
        _openImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xyzW(140), xyzH(52))];
        _openImageView.center = CGPointMake(kScreenWidth / 2, xyzH(460));
        _openImageView.image = [UIImage imageNamed:@"mayi_00"];
        _openImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _openImageView;
}


-(UIButton *)openBtn{
    if(!_openBtn){
        _openBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, xyzW(140), xyzH(52))];
        _openBtn.center = CGPointMake(kScreenWidth / 2, xyzH(460));
        [_openBtn setTitle:@"1元开启" forState:UIControlStateNormal];
        [_openBtn setTitleColor:SDColor(44, 44, 44, 1) forState:UIControlStateNormal];
        [_openBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_openBtn addTarget:self action:@selector(openBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

-(UILabel *)textLabel4{
    if(!_textLabel4){
        _textLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, xyzH(486+18), kScreenWidth, 30)];
        _textLabel4.text = @"1.发1元红包变蚂蚁(红包会随意掉落在地图里)";
        _textLabel4.textAlignment = NSTextAlignmentCenter;
        _textLabel4.textColor = [UIColor whiteColor];
        _textLabel4.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel4;
}

-(UILabel *)textLabel5{
    if(!_textLabel5){
        _textLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, xyzH(486+18+30), kScreenWidth, 30)];
        _textLabel5.text = @"2.变成蚂蚁随时进入地图抢红包";
        _textLabel5.textColor = [UIColor whiteColor];
        _textLabel5.textAlignment = NSTextAlignmentCenter;
        _textLabel5.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel5;
}



@end
