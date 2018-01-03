//
//  DLGroupRedpacketViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupRedpacketViewController.h"
#import "DltUICommon.h"
#import "DLPayTypeView.h"
#import "DLPasswordInputView.h"
#import "RCHttpTools.h"
#import "ProtocalViewController.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

NSString * const kGroupRedpackerDetailKey = @"GroupRedpackerDetailKey";
NSString * const kGroupRedpackertMoneyKey = @"GroupRedpackertMoneyKey";
NSString * const kGroupPayPassWordKey = @"GroupPayPassWordKey";
NSString * const kGroupRedpackerTypeKey = @"GroupRedpackerTypeKey";
NSString * const kGroupRedpackerCountKey = @"GroupRedpackerCountKey";

@interface DLGroupRedpacketViewController ()
<
    UITextFieldDelegate,
    DLPasswordInputViewDelegate,
    DLPayTypeViewDelegate,
    DLPasswordInputViewDelegate,
    UIAlertViewDelegate
>
{
    BOOL _isRandomMoney; // 默认yes 表示是随机红包 no 表示固定金额红包
}
@property (weak, nonatomic) IBOutlet UIView *inputNumberView;
@property (weak, nonatomic) IBOutlet UIView *redpacketView;
@property (weak, nonatomic) IBOutlet UIView *inputDetailView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UITextField *redpacketCountText;
@property (weak, nonatomic) IBOutlet UITextField *detailText;
@property (weak, nonatomic) IBOutlet UILabel *groupNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutH;
@property (weak, nonatomic) IBOutlet UIButton *isAgreeBtn;

@end

@implementation DLGroupRedpacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.sureBtn.layer.cornerRadius = 6;
    self.sureBtn.layer.masksToBounds = YES;
    self.inputNumberView.layer.borderWidth = 1;
    self.inputNumberView.layer.borderColor = [UIColor colorWithHexString:@"9C9C9C"].CGColor;
    self.inputDetailView.layer.borderWidth = 1;
    self.inputDetailView.layer.borderColor = [UIColor colorWithHexString:@"9C9C9C"].CGColor;
    self.redpacketView.layer.borderWidth = 1;
    self.redpacketView.layer.borderColor = [UIColor colorWithHexString:@"9C9C9C"].CGColor;
    self.changeBtn.selected = YES;  // 表示选中状态为随机红包
    _isRandomMoney = YES;
    self.redpackerType = DLGroupRedpackerType_Random;
    
    self.groupNumber.text = [NSString stringWithFormat:@"本群%ld人",(long)self.membersCount];
    
    [self addLeftItem];
    
    self.moneyText.delegate = self;
    
    [self.moneyText addTarget:self action:@selector(moneyTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.redpacketCountText addTarget:self action:@selector(redpacketCountTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        self.sureBtn.backgroundColor = [UIColor grayColor];
        [self.isAgreeBtn setTitle:@"✘" forState:0];
    }else{
        [self.isAgreeBtn setTitle:@"✔️" forState:0];
    }
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

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.backViewLayoutH.constant = kScreenSize.height + 10;
    self.backViewLayoutW.constant = kScreenSize.width;
}

- (IBAction)sureBtnAction:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        if ([self.totalMoney.text floatValue] > 200 * [self.    redpacketCountText.text integerValue]) {
            [DLAlert alertWithText:@"平均单个红包不能大于200"];
            return;
        }

        if (ISNULLSTR(self.moneyText.text)) {
            [DLAlert alertWithText:@"请填写红包金额"];
            return;
        }
        if (ISNULLSTR(self.redpacketCountText.text)) {
            [DLAlert alertWithText:@"请填写红包个数"];
            return;
        }
        if (self.detailText.text.length > 16) {
            [DLAlert alertWithText:@"留言备注最多16个字"];
            return;
        }
        [self.moneyText resignFirstResponder];
        [self.redpacketCountText resignFirstResponder];
        [self.detailText resignFirstResponder];
        /// 选择支付方式
        DLPayTypeView *typeView = [DLPayTypeView shareInstance];
        typeView.payCount = self.moneyText.text;
        typeView.delegate = self;
        [typeView popAnimationView:[UIApplication sharedApplication].keyWindow];
    }else{
        [DLAlert alertWithText:@"请阅读并同意《蚂蚁通钱包用户协议》"];
        return;
    }


}
- (IBAction)seeDLTUserRule:(UIButton *)sender {
    
}
- (IBAction)changeRedPacketType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 随机红包
        _isRandomMoney = YES;
        self.stateLabel.text = @"红包金额随机，";
        [self.changeBtn setTitle:@"改为普通红包" forState:UIControlStateNormal];
        self.typeLabel.text = @"总金额";
        self.typeImage.image = [UIImage imageNamed:@"redpacker_09"];
        self.redpackerType = DLGroupRedpackerType_Random;
    } else {
        // 固定红包
        _isRandomMoney = NO;
        self.stateLabel.text = @"红包金额固定，";
        [self.changeBtn setTitle:@"改为随机红包" forState:UIControlStateNormal];
        self.typeLabel.text = @"单个红包";
        self.typeImage.image = [UIImage imageNamed:@"redpacker_08"];
        self.redpackerType = DLGroupRedpackerType_Fixed;
    }
}

#pragma mark - 自定义代理
- (void)payTypeView:(DLPayTypeView *)payView andPayCount:(NSString *)payCount andPayType:(DLRedpackerPaytype)payType {
//    self.payCount = payCount;
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(groupRedpackerViewController:sendRedpackerWithParams:)]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                CGFloat sureMoney = [self.moneyText.text floatValue]*100;
                NSString *accont  = [NSString stringWithFormat:@"%d",(int)sureMoney];
                [dic setObject:accont forKey:kGroupRedpackertMoneyKey];
                [dic setObject:password forKey:kGroupPayPassWordKey];
                [dic setObject:@(self.redpackerType) forKey:kGroupRedpackerTypeKey];
                [dic setObject:self.redpacketCountText.text forKey:kGroupRedpackerCountKey];
                if (ISNULLSTR(self.detailText.text)) {
                    [dic setObject:@"恭喜发财，大吉大利" forKey:kGroupRedpackerDetailKey];
                } else {
                    [dic setObject:self.detailText.text forKey:kGroupRedpackerDetailKey];
                }
                [self.delegate groupRedpackerViewController:self sendRedpackerWithParams:dic];
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
            inputView.money = self.totalMoney.text;
            [inputView popAnimationView:[UIApplication sharedApplication].keyWindow];
        });
    }
}



#pragma mark - 私有方法
- (void)moneyTextDidChange:(UITextField *)textField {
    if ([textField.text integerValue] > 100000) {
        textField.text = self.totalMoney.text;
        return ;
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

- (void)redpacketCountTextDidChange:(UITextField *)textField {
    if ([textField.text integerValue] > self.membersCount) {
        [DLAlert alertWithText:@"红包数不能超过群人数"];
        textField.text = [NSString stringWithFormat:@"%ld",(long)self.membersCount];
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
