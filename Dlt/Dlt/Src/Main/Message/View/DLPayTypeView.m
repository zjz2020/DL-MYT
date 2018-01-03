//
//  DLPayTypeView.m
//  Dlt
//
//  Created by Liuquan on 17/6/8.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLPayTypeView.h"
#import "RCHttpTools.h"

#define kPayTypeViewH  405

@interface DLPayTypeView (){
    UIView *_backView;
}

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
//@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation DLPayTypeView

+ (DLPayTypeView *)shareInstance {
    DLPayTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:@"DLPayTypeView" owner:nil options:nil] lastObject];
    return typeView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sureBtn.layer.cornerRadius = 6;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.balanceBtn.selected = YES;
    self.selectedBtn = self.balanceBtn;
    
    self.balanceBtn.tag = DLRedpackerPaytype_Balance;
    self.alipayBtn.tag = DLRedpackerPaytype_Alipay;
    //self.wechatBtn.tag = DLRedpackerPaytype_WechatPay;
    
    // 获取余额
    @weakify(self)
    [[RCHttpTools shareInstance] checkMyBalances:^(NSString *myBalances) {
       @strongify(self)
        self.balance.text = [NSString stringWithFormat:@"可用余额：%.2f",[myBalances floatValue]  / 100.0];
    }];
    
}

- (void)popAnimationView:(UIView *)supView {
    self.backgroundColor = [UIColor whiteColor];
    [self addBackView:supView];
    CGFloat originY = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = kPayTypeViewH;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat originX = 0;
    self.frame = CGRectMake(originX, originY, width, height);
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = originY - frame.size.height;
        self.frame = frame;
    }];
    [supView addSubview:self];
}
- (void)addBackView:(UIView *)supView {
    _backView = [[UIView alloc] init];
    _backView.frame = supView.bounds;
    _backView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewAction)];
    [_backView addGestureRecognizer:tapGesture];
    [supView addSubview:_backView];
}
- (void)tapBackViewAction {
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setPayCount:(NSString *)payCount {
    _payCount = payCount;
    self.totalMoney.text = payCount;
}

#pragma mark - 点击事件
- (IBAction)payButtonTypesAction:(UIButton *)sender {
    if (!sender.selected) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }

}
- (IBAction)sureButtonAction:(UIButton *)sender {
    [self tapBackViewAction];
    NSLog(@"%ld",(long)self.selectedBtn.tag);
    if (self.selectedBtn.tag == 100) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(payTypeView:andPayCount:andPayType:)]) {
            [self.delegate payTypeView:self andPayCount:self.payCount andPayType:self.selectedBtn.tag];
        }

    }else{
        [DLAlert alertWithText:@"暂时只支持余额支付"];
    }
    
}


@end
