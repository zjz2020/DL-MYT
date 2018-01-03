//
//  DLPrivateRedPacketViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLPrivateRedPacketViewController.h"
#import "DltUICommon.h"
#import "DLPayTypeView.h"
#import "DLPasswordInputView.h"
#import "RCHttpTools.h"
#import "ProtocalViewController.h"

NSString * const kRemarkKey = @"remark";
NSString * const ktotalMoneyKey = @"totalMoneyKey";
NSString * const kPassWordKey = @"passwordKey";

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"


@interface DLPrivateRedPacketViewController ()<
  UITextFieldDelegate,
  DLPasswordInputViewDelegate,
  DLPayTypeViewDelegate,
  DLPasswordInputViewDelegate,
  UIAlertViewDelegate
>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutH;
@property (weak, nonatomic) IBOutlet UIView *inputNumberView;
@property (weak, nonatomic) IBOutlet UIView *inputDetailView;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UITextField *detailText;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *isAgreeBtn;
@property (nonatomic, strong) NSString *payCount;

@end

@implementation DLPrivateRedPacketViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_numberText resignFirstResponder];
    [_detailText resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.sureBtn.layer.cornerRadius = 6;
    self.sureBtn.layer.masksToBounds = YES;
    self.inputNumberView.layer.borderWidth = 1;
    self.inputNumberView.layer.borderColor = [UIColor colorWithHexString:@"9C9C9C"].CGColor;
    self.inputDetailView.layer.borderWidth = 1;
    self.inputDetailView.layer.borderColor = [UIColor colorWithHexString:@"9C9C9C"].CGColor;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        self.sureBtn.backgroundColor = [UIColor grayColor];
        [self.isAgreeBtn setTitle:@"✘" forState:0];
    }else{
        [self.isAgreeBtn setTitle:@"✔️" forState:0];
    }
    [self addLeftItem];

    [self.numberText addTarget:self action:@selector(moneyTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.detailText addTarget:self action:@selector(detailTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.numberText.delegate = self;
    
}
- (IBAction)upIsAgreeButton:(id)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chooseYES"];
        self.sureBtn.backgroundColor = [UIColor redColor];
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

-(void)addLeftItem {
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"friend_00"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = rightitem;
}
- (void)leftItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)senderRedPacket:(UIButton *)sender {
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
         if (ISNULLSTR(self.numberText.text)) {
             [DLAlert alertWithText:@"请填写红包金额"];
             return;
         }
         if ([self.totalMoney.text isEqualToString:@"0.00"]) {
             [DLAlert alertWithText:@"请输入正确金额"];
             return ;
         }
         
         if ([self.totalMoney.text floatValue] > 200.00) {
             [DLAlert alertWithText:@"单个红包金额不能超过200"];
             return;
         }
         if (self.detailText.text.length > 16) {
            return;
         }
         [self.numberText resignFirstResponder];
         [self.detailText resignFirstResponder];
         /// 选择支付方式
         DLPayTypeView *typeView = [DLPayTypeView shareInstance];
         typeView.payCount = self.totalMoney.text;
         typeView.delegate = self;
         [typeView popAnimationView:[UIApplication sharedApplication].keyWindow];
     }else{
         [DLAlert alertWithText:@"请阅读并同意《蚂蚁通钱包用户协议"];
         return;
     }
}
- (IBAction)seeDLTMoneyPacketAgreement:(UIButton *)sender {


}

#pragma mark - 代理
- (void)payTypeView:(DLPayTypeView *)payView andPayCount:(NSString *)payCount andPayType:(DLRedpackerPaytype)payType {
    self.payCount = payCount;
    [DLAlert alertShowLoad];
    if (payType == DLRedpackerPaytype_Balance) {
        // 验证是否设置过支付密码
        @weakify(self)
        [[RCHttpTools shareInstance] userIsSetPayPassword:^(BOOL isSet) {
            @strongify(self)
            if (isSet) {
                [DLAlert alertHideLoad];
                DLPasswordInputView *inputView = [DLPasswordInputView initInputView];
                inputView.delegate = self;
                inputView.money = payCount;
                [inputView popAnimationView:[UIApplication sharedApplication].keyWindow];
            } else {
                [DLAlert alertWithText:@"您还未设置支付密码，请先设置"];
            }
        }];
    }
}

- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password {
    /// 验证支付密码
    [DLAlert alertShowLoad];
    @weakify(self)
    [[RCHttpTools shareInstance] verificationPayPassword:password handle:^(BOOL isSame) {
        @strongify(self)
        if (isSame) {
            [DLAlert alertHideLoad];
            if (self.delegate && [self.delegate respondsToSelector:@selector(privateRedpacketViewController:sureSendRedpacker:)]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:self.totalMoney.text forKey:ktotalMoneyKey];
                [dic setObject:password forKey:kPassWordKey];
                if (ISNULLSTR(self.detailText.text)) {
                    [dic setObject:@"恭喜发财，大吉大利" forKey:kRemarkKey];
                } else {
                    [dic setObject:self.detailText.text forKey:kRemarkKey];
                }
                [self.delegate privateRedpacketViewController:self sureSendRedpacker:dic];
            }
            [self leftItemClick];
        } else {
            [DLAlert alertHideLoad];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付密码错误，请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            [alert show];
        }
    }];
    
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            DLPasswordInputView *inputView = [DLPasswordInputView initInputView];
            inputView.delegate = self;
            inputView.money = self.payCount;
            [inputView popAnimationView:[UIApplication sharedApplication].keyWindow];
        });
    }
}

#pragma mark - 私有方法
- (void)detailTextDidChange:(UITextField *)textField {
    if (textField.text.length > 16) {
        [DLAlert alertWithText:@"留言备注最多16个字"];
        textField.text = [textField.text substringToIndex:16];
    }
}


- (void)moneyTextDidChange:(UITextField *)textField {
    if ([textField.text integerValue] > 100000) {
        textField.text = self.totalMoney.text;
        return ;
    }
   
    if ([textField.text containsString:@"-"]) {
        [DLAlert alertWithText:@"请输入正确金额"];
        return;
    }
    BOOL isEnable = [self validateMoney:textField.text];
    if (ISNULLSTR(textField.text)) {
        self.totalMoney.text = @"0.00";
    }
    if ([textField.text hasSuffix:@"."]) {
        self.totalMoney.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
    }
    if (isEnable) {
        self.totalMoney.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (int i = futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}

-(BOOL)validateMoney:(NSString *)money {
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:money];
}

- (IBAction)toProtocol:(id)sender {
    ProtocalViewController *ptv = [[ProtocalViewController alloc] init];
    [self.navigationController pushViewController:ptv animated:YES];}


@end
