//
//  MaYiOpenPayView.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/12.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiOpenPayView.h"
#import "PayCell.h"
#import "RCHttpTools.h"
#import "DLPasswordInputView.h"
#import "DLWalletPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "IQUIWindow+Hierarchy.h"

#define PayViewWidth           (320 * kNewScreenWScale)
#define PayViewHeight          (400 * kNewScreenWScale)
#define PayCellInderifer       @"PayCellInderifer"

@interface MaYiOpenPayView()<UITableViewDelegate , UITableViewDataSource ,DLPasswordInputViewDelegate>{
   NSInteger  _selectCellNum;
   NSString  *_currentBalance;
   NSString  *_toID;
}

@property (nonatomic , strong) UIView           * backView;         //黑色背景
@property (nonatomic , strong) UIView           * payBackView;      //支付父视图
@property (nonatomic , strong) UIButton         * closeBtn;         //关闭
@property (nonatomic , strong) UIImageView      * topImageView;     //顶部背景图
@property (nonatomic , strong) UIImageView      * yImageView;       //¥图片
@property (nonatomic , strong) UILabel          * numLabel;         //1数字
@property (nonatomic , strong) UILabel          * mayiLabel;        //成为蚂蚁
@property (nonatomic , strong) UILabel          * payLabel;         //支付方式文字
@property (nonatomic , strong) UIView           * topLineView;      //列表上方横线
@property (nonatomic , strong) UITableView      * payTableView;     //支付方式列表
@property (nonatomic , strong) UIButton         * agreeBtn;         //同意蚂蚁条款
@property (nonatomic , strong) UIButton         * nextBtn;          //下一步

@property (nonatomic, strong) NSArray           * dataArr;
@property (nonatomic, strong) DLWalletPayModel  * paymodel;

@end

@implementation MaYiOpenPayView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        _dataArr = [NSMutableArray array];
        _selectCellNum = 0;
        [self addSubview:self.backView];
        [self addSubview:self.payBackView];
        [self addSubview:self.closeBtn];
        
        [self.payBackView addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@(0));
            make.right.equalTo(@(0));
            make.bottom.equalTo(@(0));
        }];
        
        [self.payBackView addSubview:self.yImageView];
        [self.yImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@((PayViewWidth * 0.28 - 35)/2));
            make.left.equalTo(@(20));
            make.width.equalTo(@(25));
            make.height.equalTo(@(32));
        }];

        [self.payBackView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.yImageView.mas_bottom);
            make.left.equalTo(self.yImageView.mas_right).offset(10);
            make.width.equalTo(@(25));
            make.height.equalTo(@(40));
        }];

        [self.payBackView addSubview:self.mayiLabel];
        [self.mayiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.yImageView.mas_bottom);
            make.left.equalTo(self.numLabel.mas_right).offset(8);
            make.width.equalTo(@(100));
            make.height.equalTo(@(15));
        }];

        [self.payBackView addSubview:self.payLabel];
        [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(90 *kNewScreenWScale+10));
            make.left.equalTo(@(15));
            make.width.equalTo(@(100));
            make.height.equalTo(@(30));
        }];
        
        [self.payBackView addSubview:self.topLineView];
        [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payLabel.mas_bottom).offset(9);
            make.left.equalTo(@(10));
            make.right.equalTo(@(-10));
            make.height.equalTo(@(0.5));
        }];
        
        [self.payBackView addSubview:self.payTableView];
        [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payLabel.mas_bottom).offset(10);
            make.left.equalTo(@(0));
            make.right.equalTo(@(0));
            make.height.equalTo(@(70*kNewScreenWScale*2));
        }];

        [self.payBackView addSubview:self.agreeBtn];
        [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payTableView.mas_bottom).offset(xyzH(10));
            make.left.equalTo(self.payLabel.mas_left);
            make.width.equalTo(@(150));
            make.height.equalTo(@(xyzH(35)));
        }];

        [self.payBackView addSubview:self.nextBtn];
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.agreeBtn.mas_bottom).offset(10);
            make.left.equalTo(self.payLabel.mas_left);
            make.right.equalTo(@(-15));
            make.height.equalTo(@(xyzW(45)));
        }];
        
    }
    return self;
}

#pragma -mark  -------------   私有方法  ------------

-(void)show{
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[DLWalletPayModel paymodelInstance]];
    [temp removeLastObject];
    DLWalletPayModel *model = [temp firstObject];
    model.isSelectedPay = NO;
    model.isOpen = NO;
     @weakify(self)
    [[RCHttpTools shareInstance] checkMyBalances:^(NSString *myBalances) {
        @strongify(self)
        DLWalletPayModel *model = [DLWalletPayModel new];
        model.title = @"余额支付";
        model.icon = @"wallet_07";
        model.content = [NSString stringWithFormat:@"可用余额:%.2f",[myBalances floatValue] / 100.0];
        _currentBalance = [NSString stringWithFormat:@"%.2f",[myBalances floatValue] / 100.0];
        model.isSelectedPay = YES;
        model.isOpen = YES;
        model.payType = @"balancePay";
        [temp insertObject:model atIndex:0];
        self.dataArr = temp.copy;
        self.paymodel = [self.dataArr firstObject];
        [self.payTableView reloadData];
    }];
    
    
    CGAffineTransform  transform = CGAffineTransformMakeScale(0.1, 0.1);
    _payBackView.transform = transform;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        self.alpha = 1;
        _backView.alpha = 0.6;
        CGAffineTransform  transform = CGAffineTransformMakeScale(1.0, 1.0);
        _payBackView.transform = transform;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide{
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)agreeBtnClick{

    [self hide];
    ProtocalViewController *ptv = [[ProtocalViewController alloc] init];
    if(self.delegate && [self.delegate respondsToSelector:@selector(openPayJumpProtocalCtr:)]){
        [self.delegate openPayJumpProtocalCtr:ptv];
    }
}

-(void)nextBtnClick{
    
    if (_selectCellNum == 0) {
        //余额转账
        if ([self.paymodel.payType isEqualToString:@"balancePay"]) {
            if ([_currentBalance floatValue] < 1) {
                [DLAlert alertWithText:@"余额不足"];
                return;
            }
        }
        
        DLPasswordInputView *passwordView = [DLPasswordInputView initInputView];
        passwordView.delegate = self;
        passwordView.money = @"1.00";
        passwordView.titleLabel.text = @"蚂蚁通转账";
        [passwordView popAnimationView:[UIApplication sharedApplication].keyWindow];
        
    }else if(_selectCellNum == 1){
        //支付宝转账
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
            [DLAlert alertWithText:@"请安装支付宝客户端...."];
            return;
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(openPaySelectPayMethod:andPassWord:)]){
            [self.delegate openPaySelectPayMethod:MaYiOpenPayALiPay andPassWord:nil];
        }
    }
}

#pragma - ark  -------------   代理方法  ------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count > 0 ? 2 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
    [cell file:self.dataArr[indexPath.row]];
    cell.lineWidth = PayViewWidth - 20;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70*kNewScreenWScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLWalletPayModel *model = self.dataArr[indexPath.row];
    for (DLWalletPayModel *payModel in self.dataArr) {
        payModel.isSelectedPay = NO;
    }
    model.isSelectedPay = YES;
    self.paymodel = model;
    _selectCellNum = indexPath.row;
    [self.payTableView reloadData];
}

//输入交易密码代理
- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password {
    if(self.delegate && [self.delegate respondsToSelector:@selector(openPaySelectPayMethod:andPassWord:)]){
        [self.delegate openPaySelectPayMethod:MaYiOpenPayBalance andPassWord:password];
    }
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

-(UIView *)payBackView{
    if(!_payBackView){
        _payBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PayViewWidth, PayViewHeight)];
        _payBackView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 50);
    }
    return _payBackView;
}

-(UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _closeBtn.center = CGPointMake( kScreenWidth  / 2  , kScreenHeight / 2 + PayViewWidth / 2 + 25 );
        [_closeBtn setImage:[UIImage imageNamed:@"mayi_03"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIImageView *)topImageView{
    if(!_topImageView){
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topImageView.image = [UIImage imageNamed:@"mayi_02"];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImageView;
}

-(UIImageView *)yImageView{
    if(!_yImageView){
        _yImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _yImageView.image = [UIImage imageNamed:@"mayi_09"];
        _yImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _yImageView;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLabel.text = @"1";
        _numLabel.font = [UIFont systemFontOfSize:50 weight:UIFontWeightSemibold];
        _numLabel.textColor = SDColor(255, 255, 255, 1);
    }
    return _numLabel;
}

-(UILabel *)mayiLabel{
    if(!_mayiLabel){
        _mayiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _mayiLabel.text = @"成为蚂蚁";
        _mayiLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _mayiLabel.textColor = SDColor(255, 255, 255, 1);
    }
    return _mayiLabel;
}

-(UILabel *)payLabel{
    if(!_payLabel){
        _payLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _payLabel.text = @"支付方式";
        _payLabel.font = [UIFont systemFontOfSize:15];
        _payLabel.textColor = SDColor(44, 44, 44, 1);
    }
    return _payLabel;
}

-(UIView *)topLineView{
    if(!_topLineView){
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = SDColor(211, 211, 211, 1);
    }
    return _topLineView;
}

-(UITableView *)payTableView{
    if(!_payTableView){
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _payTableView.bounces = NO;
        _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        [_payTableView registerClass:[PayCell class] forCellReuseIdentifier:PayCellInderifer];
    }
    return _payTableView;
}

-(UIButton *)agreeBtn{
    if(!_agreeBtn){
        _agreeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _agreeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _agreeBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-30,0,0);
        NSString *contentStr = @"同意《蚂蚁条款》";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:SDColor(153, 153, 153, 1) range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:SDColor(0, 137, 241, 1) range:NSMakeRange(2, contentStr.length-2)];
        [_agreeBtn setAttributedTitle:str forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

-(UIButton *)nextBtn{
    if(!_nextBtn){
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_nextBtn setBackgroundColor:SDColor(0, 137, 241, 1)];
        _nextBtn.layer.cornerRadius = 5.0;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

@end
