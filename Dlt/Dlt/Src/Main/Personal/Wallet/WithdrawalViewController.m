//
//  WithdrawalViewController.m
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "WithdrawalCell.h"
#import "PayCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SelectorPayCell.h"
#import "RCHttpTools.h"
#import "DltUICommon.h"
#import "DLWalletPayModel.h"
#import "DLWithdrawalsDetailViewController.h"
#import "DLPasswordInputView.h"
#import "ProtocalViewController.h"

#define WithdrawalCellInderifer @"WithdrawalCellInderifer"
#define PayCellInderifer @"PayCellInderifer"
#define SelectorPayCellInderifer @"SelectorPayCellInderifer"

@interface WithdrawalViewController ()<WithdrawalCellDelegate,DLPasswordInputViewDelegate>
{
    NSString * blances;
}
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) DLWalletPayModel *paymodel;
@property (nonatomic, strong) NSMutableDictionary *paramsDic;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSDictionary *resultDic;
@property (nonatomic, strong) UIButton *nextStep;
@property (nonatomic, strong) UIButton *isAgreeBtn;
@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    [self back:@"friends_15"];
    [self.tableView registerClass:[WithdrawalCell class] forCellReuseIdentifier:WithdrawalCellInderifer];
    [self.tableView registerClass:[PayCell class] forCellReuseIdentifier:PayCellInderifer];
    [self.tableView registerClass:[SelectorPayCell class] forCellReuseIdentifier:SelectorPayCellInderifer];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.tableFooterView = [self footerView];
    
    self.dataArr = [DLWalletPayModel paymodelInstance];
    self.paymodel = [[DLWalletPayModel paymodelInstance] firstObject];
    
}
-(void)backclick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[RCHttpTools shareInstance] checkMyBalances:^(NSString *myBalances) {
    
        blances = myBalances.copy;
        [self.tableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1 + self.dataArr.count;
    return 2;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        return [WithdrawalCell CellH];
    } else {
        return [PayCell CellH];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        WithdrawalCell * cell = [tableView dequeueReusableCellWithIdentifier:WithdrawalCellInderifer];
        cell.withdrawalDelegate = self;
        cell.blances = [NSString stringWithFormat:@"%.2f",[blances floatValue] / 100.0];
        return cell;
    } else {
        PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
        [cell file:self.dataArr[indexPath.row - 1]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        DLWalletPayModel *model = self.dataArr[indexPath.row - 1];
        for (DLWalletPayModel *payModel in self.dataArr) {
            payModel.isSelectedPay = NO;
        }
        model.isSelectedPay = YES;
        self.paymodel = model;
        [self.tableView reloadData];
    }
}

#pragma mark - 点击事件
- (void)nextStepButtonAction:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
            [DLAlert alertWithText:@"请安装支付宝客户端"];
            return;
        }
        if (!self.paymodel.isOpen) {
            [DLAlert alertWithText:@"目前只提供支付宝提现，其他功能暂未开通"];
            return;
        }
     
        if (ISNULLSTR(self.money)) {
            [DLAlert alertWithText:@"请输入提现金额"];
            return;
        }
    
        if ([self.money floatValue] < 0.1) {
            [DLAlert alertWithText:@"请输入正确的金额"];
            return;
        }
        [self getAlipayPower];
    }else{
        [DLAlert alertWithText:@"请阅读并同意《蚂蚁通钱包用户协议》"];
        return;
    }
}

- (void)withdrawalCell:(WithdrawalCell *)cell clickAllWithFrawalButtonAction:(NSString *)myblance {
    if ([myblance floatValue] < 0.1) {
        [DLAlert alertWithText:@"请输入正确的金额"];
        return;
    }
    self.money = [NSString stringWithFormat:@"%.2f",[myblance floatValue]];
    cell.moneyFiled.text = [NSString stringWithFormat:@"%.2f",[myblance floatValue]];
}
- (void)withdrawalCell:(WithdrawalCell *)cell inputFinishAccomt:(NSString *)accomt {
    self.money = accomt;
}

#pragma mark - 网络请求
/// 支付宝授权
- (void)getAlipayPower {
    [DLAlert alertShowLoad];
    NSString * url = [NSString stringWithFormat:@"%@Wallet/alipayOauthInfo",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
//    if (ISNULLSTR(user.uid) || ISNULLSTR(user.token)) {
//        [DLAlert alertWithText:@"错误，请重试"];
//        return;
//    }

    NSDictionary *params = @{
                             @"uid" : user.uid,
                             @"token" :[DLTUserCenter userCenter].token
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        [DLAlert alertHideLoad];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([response[@"code"] integerValue] == 1) {
                NSString *infoStr = response[@"data"][@"infoStr"];
                if (infoStr) {
                    [[AlipaySDK defaultService] auth_V2WithInfo:infoStr fromScheme:@"alipaysdk" callback:^(NSDictionary *resultDic) {
                        NSString *result = resultDic[@"result"];
                        self.resultDic = [self getParameters:result];
                        [self showPasswordInput];
                    }];
                }
            }
        });
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"请确保网络畅通"];
    } progress:nil];
}

- (void)dl_networkForWithdrawalsWithPassword:(NSString *)password {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/withdrawals",BASE_URL];
    if (ISNULLSTR(self.money)) {[DLAlert alertWithText:@"错误，请重试"]; return;}
    NSString *amount = [NSString stringWithFormat:@"%.0f",[self.money floatValue] * 100];
    NSString *user_id = self.resultDic[@"user_id"];
    if (ISNULLSTR(user_id)) {
        user_id = @"";
    }
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : [DLTUserCenter userCenter].curUser.uid,
                             @"payPwd": password,
                             @"amount": amount,
                             @"account": user_id,
                             @"accountType" : @(1)
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DLAlert alertWithText:response[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

/// 验证支付密码
- (void)showPasswordInput {
    // 先判断是否有设置支付密码
    [[RCHttpTools shareInstance] userIsSetPayPassword:^(BOOL isSet) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (isSet) {
               DLPasswordInputView *passwordView = [DLPasswordInputView initInputView];
               passwordView.delegate = self;
               passwordView.titleLabel.text = @"提现金额";
               passwordView.money = self.money;
               [passwordView popAnimationView:[UIApplication sharedApplication].keyWindow];
           } else {
               [DLAlert alertWithText:@"请先设置支付密码"];
           }
       });
    }];
}

#pragma mark - 自定义代理
- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password {
    [self dl_networkForWithdrawalsWithPassword:password];
}

#pragma mark - 本类私有方法
- (UIView *)footerView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, footer.frame.size.width, .4)];
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [footer addSubview:line];

    _nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextStep.frame = CGRectMake(30, 40, footer.frame.size.width - 60, 45);
    [_nextStep ui_setCornerRadius:6];
    [_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStep.titleLabel.font = [UIFont systemFontOfSize:17];
    _nextStep.backgroundColor = [UIColor colorWithHexString:@"0089f1"];
    [_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStep addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_nextStep];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn ui_setCornerRadius:6];
    [signBtn setTitle:@"同意《蚂蚁通钱包用户协议》" forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(toProtocol) forControlEvents:UIControlEventTouchUpInside];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [signBtn setTitleColor:[UIColor colorWithHexString:@"9c9c9c"] forState:UIControlStateNormal];
    [footer addSubview:signBtn];
    signBtn.sd_layout
    .topSpaceToView(self.nextStep, 20)
    .centerXEqualToView(self.nextStep);
    [signBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:25];
    
    
    self.isAgreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.isAgreeBtn addTarget:self action:@selector(upIsAgreeButton) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.isAgreeBtn];
    self.isAgreeBtn.sd_layout
    .topEqualToView(signBtn)
    .rightSpaceToView(signBtn, 0)
    .heightIs(25)
    .widthIs(25);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        [self.isAgreeBtn setTitle:@"✘" forState:0];
        self.nextStep.backgroundColor = [UIColor grayColor];
    }else{
        [self.isAgreeBtn setTitle:@"✔️" forState:0];
        self.nextStep.backgroundColor = [UIColor colorWithHexString:@"0089f1"];
    }

    return footer;
}
-(void)upIsAgreeButton{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chooseYES"];
        self.nextStep.backgroundColor = [UIColor colorWithHexString:@"0089f1"];
        [self.isAgreeBtn setTitle:@"✔️" forState:0];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"chooseYES"];
        self.nextStep.backgroundColor = [UIColor grayColor];
        [self.isAgreeBtn setTitle:@"✘" forState:0];
        
    }
    
}
- (void)toProtocol{
    ProtocalViewController *ptv = [[ProtocalViewController alloc] init];
    [self.navigationController pushViewController:ptv animated:YES];
}
- (NSMutableDictionary *)getParameters:(NSString *)string {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *parametersString = string;
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                [params setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return nil;
        }
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        if (key == nil || value == nil) {
            return nil;
        }
        [params setValue:value forKey:key];
    }
    return params;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)paramsDic {
    if (!_paramsDic) {
        _paramsDic = [NSMutableDictionary dictionary];
    }
    return _paramsDic;
}

@end
