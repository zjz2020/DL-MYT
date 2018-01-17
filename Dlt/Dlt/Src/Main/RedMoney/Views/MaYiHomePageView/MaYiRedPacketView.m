//
//  MaYiRedPacketView.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiRedPacketView.h"

@interface  MaYiRedPacketView()

@property (nonatomic , strong) UIView           * backView;         //黑色背景
@property (nonatomic , strong) UIButton         * closeBtn;         //关闭
@property (nonatomic , strong) UIImageView      * backImageView;    //红包背景图
@property (nonatomic , strong) UILabel          * numLabel;         //抢到，1
@property (nonatomic , strong) UILabel          * yuanLabel;        //抢到，元
@property (nonatomic , strong) UILabel          * noneLabel;        //手慢了
@property (nonatomic , strong) UILabel          * contentLabel;     //恭喜||不要气馁
@property (nonatomic , strong) UIButton         * checkBtn;         //查看领取记录

@end

@implementation MaYiRedPacketView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.backView];
        [self addSubview:self.backImageView];
        [self addSubview:self.closeBtn];
        
        [self.backImageView addSubview:self.numLabel];
        [self.backImageView addSubview:self.yuanLabel];
        [self.backImageView addSubview:self.noneLabel];
        [self.backImageView addSubview:self.contentLabel];
        [self.backImageView addSubview:self.checkBtn];

    }
    return self;
}

#pragma -mark  -------------   私有方法  ------------

-(void)setShowType:(MaYiRedPacketType)showType{
    _showType = showType;
    switch (_showType) {
        case MaYiRedPacketNone:{
            _numLabel.alpha = _yuanLabel.alpha = 0;
            _noneLabel.alpha = 1;
            _contentLabel.text = @"不要气馁,再接再厉";
        }
            break;
            
        case MaYiRedPacketGet:{
            _numLabel.alpha = _yuanLabel.alpha = 1;
            _noneLabel.alpha = 0;
            _contentLabel.text = @"恭喜你抢到红包!";
        }
            break;
        default:
            break;
    }
    
    CGAffineTransform  transform = CGAffineTransformMakeScale(0.1, 0.1);
    _backImageView.transform = transform;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        self.alpha = 1;
        _backView.alpha = 0.5;
        CGAffineTransform  transform = CGAffineTransformMakeScale(1.0, 1.0);
        _backImageView.transform = transform;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)checkBtnClick{
    [self closeBtnClick];
    if(self.delegate && [self.delegate respondsToSelector:@selector(redPacketCheckBtnClick)]){
        [self.delegate redPacketCheckBtnClick];
    }
}

-(void)closeBtnClick{
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma -mark  -------------   初始化  ------------

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
    }
    return _backView;
}

-(UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _closeBtn.center = CGPointMake( kScreenWidth  / 2  , kScreenHeight / 2 + kScreenWidth * 0.68 / 0.6 / 2 + 25 );
        [_closeBtn setImage:[UIImage imageNamed:@"mayi_03"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIImageView *)backImageView{
    if(!_backImageView){
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.68 , kScreenWidth * 0.68 / 0.6)];
        _backImageView.center = CGPointMake(kScreenWidth /2 , kScreenHeight / 2 - 20);
        _backImageView.image = [UIImage imageNamed:@"mayi_16"];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50, 100, 50, 70)];
        _numLabel.center = CGPointMake(kScreenWidth * 0.68 /2 - 20, kScreenWidth * 0.68 / 0.6/2 +20);
        _numLabel.text = @"1";
        _numLabel.font = [UIFont systemFontOfSize:90 weight:UIFontWeightSemibold];
        _numLabel.textColor = SDColor(255, 241, 0, 1);
        _numLabel.alpha = 0;
    }
    return _numLabel;
}

-(UILabel *)yuanLabel{
    if(!_yuanLabel){
        _yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 130, 40, 35)];
        _yuanLabel.center = CGPointMake(kScreenWidth * 0.68 /2 + 20, kScreenWidth * 0.68 / 0.6/2 + 35);
        _yuanLabel.text = @"元";
        _yuanLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightSemibold];
        _yuanLabel.textColor = SDColor(255, 241, 0, 1);
        _yuanLabel.alpha = 0;
    }
    return _yuanLabel;
}

-(UILabel *)noneLabel{
    if(!_noneLabel){
        _noneLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, kScreenWidth * 0.68 , 40)];
        _noneLabel.center = CGPointMake(kScreenWidth * 0.68 /2, kScreenWidth * 0.68 / 0.6/2+20);
        _noneLabel.textAlignment = NSTextAlignmentCenter;
        _noneLabel.text = @"手慢了";
        _noneLabel.font = [UIFont systemFontOfSize:40];
        _noneLabel.textColor = SDColor(255, 241, 0, 1);
        _noneLabel.alpha = 0;
    }
    return _noneLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, kScreenWidth * 0.68 , 40)];
        _contentLabel.center = CGPointMake(kScreenWidth * 0.68 /2, kScreenWidth * 0.68 / 0.6/ 2 + 110 );
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

-(UIButton *)checkBtn{
    if(!_checkBtn){
        _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        _checkBtn.center = CGPointMake( kScreenWidth * 0.68 / 2, kScreenWidth * 0.68 / 0.6 - 40);
        [_checkBtn setTitle:@"查看领取记录 >" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:SDColor(255, 241, 0, 1) forState:UIControlStateNormal];
        [_checkBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}



@end
