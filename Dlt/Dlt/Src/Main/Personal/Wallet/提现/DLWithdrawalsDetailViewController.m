//
//  DLWithdrawalsDetailViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLWithdrawalsDetailViewController.h"
#import "DltUICommon.h"
#import "DLPasswordInputView.h"
#import "ProtocalViewController.h"

@interface DLWithdrawalsDetailViewController ()<DLPasswordInputViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutW;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *payChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *isAgreeBtn;


@end

@implementation DLWithdrawalsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.payType) {
        case DLTPayType_Alipay: {
            self.title = @"提现到支付宝";
        }
            break;
        case DLTPayType_WeChat: {
            self.title = @"提现到微信";
        }
            break;
        default: {
            self.title = @"提现到银行卡";
        }
            break;
    }
    if (self.paramsDic) {
        self.amountLabel.text = self.paramsDic[@"accomtCount"];
        NSString *cash = self.paramsDic[@"payAccont"];
        if (!ISNULLSTR(cash)) {
            self.titleLabel.text = @"到账账户";
            self.rightLabel.hidden = YES;
        }
        [self.payChooseBtn setTitle:cash forState:UIControlStateNormal];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.sureBtn ui_setCornerRadius:6 withBackgroundColor:[UIColor colorWithHexString:@"0089f1"]];
    
}
- (IBAction)upIsAgreeButton:(id)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chooseYES"];
        self.sureBtn.backgroundColor = [UIColor colorWithRed:0 green:137.0/255.0 blue:241.0/255.0 alpha:1.0];
        [self.isAgreeBtn setTitle:@"✔️" forState:0];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"chooseYES"];
        self.sureBtn.backgroundColor = [UIColor grayColor];
        [self.isAgreeBtn setTitle:@"✘" forState:0];
        
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.backViewLayoutH.constant = kScreenSize.height + 10;
    self.backViewLayoutW.constant = kScreenSize.width;
}

#pragma mark - 点击事件
/// 确定提现
- (IBAction)sureButtonAction:(UIButton *)sender {
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
    NSString *cash = self.paramsDic[@"payAccont"];
    if (ISNULLSTR(cash)) {
        [DLAlert alertWithText:@"请先选择提现账户"];
        return;
    }
    DLPasswordInputView *passwordView = [DLPasswordInputView initInputView];
    passwordView.delegate = self;
    passwordView.titleLabel.text = @"提现金额";
    passwordView.money = self.paramsDic[@"accomtCount"];
    [passwordView popAnimationView:[UIApplication sharedApplication].keyWindow];
     }else{
         [DLAlert alertWithText:@"请阅读并同意《蚂蚁通钱包用户协议》"];
         return;
     }
}

- (IBAction)agreementButtonAction:(UIButton *)sender {

}

#pragma mark - 自定义代理
- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password {
    [self dl_networkForWithdrawalsWithPassword:password];
}

#pragma mark - 网络请求
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"
- (void)dl_networkForWithdrawalsWithPassword:(NSString *)password {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/withdrawals",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : [DLTUserCenter userCenter].curUser.uid,
                             @"payPwd": password,
                             @"amount": [NSString stringWithFormat:@"%ld",[self.paramsDic[@"accomtCount"] integerValue] * 100],
                             @"account": self.paramsDic[@"payAccont"],
                             @"accountType" : @(self.payType)
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DLAlert alertWithText:response[@"msg"]];
        });
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
#pragma clang diagnostic pop
- (IBAction)toProtocol:(id)sender {
    ProtocalViewController *ptv = [[ProtocalViewController alloc] init];
    [self.navigationController pushViewController:ptv animated:YES];}

@end
