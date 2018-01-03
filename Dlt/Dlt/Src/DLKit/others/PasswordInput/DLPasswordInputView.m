//
//  DLPasswordInputView.m
//  Dlt
//
//  Created by Liuquan on 17/6/8.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLPasswordInputView.h"
#import "DLCInputPasswordView.h"

#define kPasswordInputH   220.5


@interface DLPasswordInputView ()<DLCInputPasswordViewDelegate> {
    UIView *_backView;
}
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (nonatomic, strong)  DLCInputPasswordView *passwordView;
@end


@implementation DLPasswordInputView

+ (DLPasswordInputView *)initInputView {
    DLPasswordInputView *inputView = [[[NSBundle mainBundle] loadNibNamed:@"DLPasswordInputView" owner:nil options:nil] lastObject];
    return inputView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    DLCInputPasswordView *passwordView = [[DLCInputPasswordView alloc] initWithFrame:CGRectMake(10, 150.5, 280, 50)];
    self.passwordView = passwordView;
    passwordView.delegate = self;
    [self addSubview:passwordView];
    [passwordView.textField becomeFirstResponder];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setMoney:(NSString *)money {
    _money = money;
    self.totalMoney.text = [NSString stringWithFormat:@"¥%@",money];
}

- (void)popAnimationView:(UIView *)supView {
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, 300, kPasswordInputH);
    self.center = CGPointMake(kScreenSize.width / 2, kScreenSize.height / 2 - 100);
    [self addBackView:supView];
    [supView addSubview:self];
}
- (void)addBackView:(UIView *)supView {
    _backView = [[UIView alloc] init];
    _backView.frame = supView.bounds;
    _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [supView addSubview:_backView];
}
- (void)tapBackViewAction {
    [self.passwordView.textField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [_backView removeFromSuperview];
    _backView = nil;
    self.passwordView = nil;
}
- (IBAction)cancleInputPassword:(UIButton *)sender {
    [self endEditing:YES];
    [self tapBackViewAction];
}

#pragma mark - 代理
-(void)inputPasswordViewDelegate:(DLCInputPasswordView *)inputPasswordView inputEndWithPassword:(NSString *)inputEndWithPassword {
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordInputView:inputPasswordText:)]) {
        [self.delegate passwordInputView:self inputPasswordText:inputEndWithPassword];
    }
    [self tapBackViewAction];
}

@end
