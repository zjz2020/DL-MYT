//
//  DLTransferAccountsTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTransferAccountsTableViewController.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"
#import "DLWalletPayModel.h"
#import "PayCell.h"
#import "RCHttpTools.h"
#import "DLPasswordInputView.h"
#import "ProtocalViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#define PayCellInderifer @"PayCellInderifer"


@interface DLTransferAccountsTableViewController ()<DLPasswordInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) DLWalletPayModel *paymodel;
@property (nonatomic, strong) NSString *currentBalance;
@property (nonatomic, strong) UIButton *nextStep;
@property (nonatomic, strong) UIButton *isAgreeBtn;

@property (nonatomic , assign)int upCellRow;

@end

@implementation DLTransferAccountsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //"转账"
    [self.headImg ui_setCornerRadius:35];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,self.friendsInfo.headImg]] placeholderImage:[UIImage imageNamed:@"personal_00"]];
    self.nickName.text = self.friendsInfo.name;
    [self.tableView registerClass:[PayCell class] forCellReuseIdentifier:PayCellInderifer];
    
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
        model.isSelectedPay = YES;
        model.isOpen = YES;
        model.payType = @"balancePay";
        [temp insertObject:model atIndex:0];
        self.dataArr = temp.copy;
        self.paymodel = [self.dataArr firstObject];
        self.currentBalance = [NSString stringWithFormat:@"%.2f",[myBalances floatValue] / 100.0];
        [self.tableView reloadData];
    }];
    
    self.tableView.tableFooterView = [self footerView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.dataArr.count;
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
    [cell file:self.dataArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLWalletPayModel *model = self.dataArr[indexPath.row];
    for (DLWalletPayModel *payModel in self.dataArr) {
        payModel.isSelectedPay = NO;
    }
    model.isSelectedPay = YES;
    self.paymodel = model;
    _upCellRow = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - 点击事件
- (void)nextStepButtonAction:(UIButton *)sender {
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chooseYES"]) {
         if (ISNULLSTR(self.moneyTextField.text)) {
             [DLAlert alertWithText:@"请输入转账金额"];
             return;
         }
         if ([self.moneyTextField.text containsString:@"-"]) {
             [DLAlert alertWithText:@"请输入正确金额"];
             return;
         }
         if (self.remarksTextField.text.length > 20) {
             [DLAlert alertWithText:@"附言不能超过20个字"];
             return;
         }
         if (_upCellRow == 0) {
                //余额转账
            [self balanceTransfer];
         }else if(_upCellRow == 1){
                //支付宝转账
             if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
                 [DLAlert alertWithText:@"请安装支付宝客户端...."];
                 return;
             }
             [self alipayTransfer];
         }else{
               [DLAlert alertWithText:@"转账暂不支持微信转账"];
         }
      
     }else{
         [DLAlert alertWithText:@"请阅读并同意《蚂蚁通钱包用户协议》"];
         return;
     }
    
}
//余额转账
-(void)balanceTransfer{
    
    
    if ([self.paymodel.payType isEqualToString:@"balancePay"]) {
        if ([self.currentBalance floatValue] < [self.moneyTextField.text floatValue]) {
            [DLAlert alertWithText:@"余额不足"];
            return;
        }
    }
    if (self.remarksTextField.text.length > 20) {
        [DLAlert alertWithText:@"附言不能超过20个字"];
        return;
    }
    
    DLPasswordInputView *passwordView = [DLPasswordInputView initInputView];
    passwordView.delegate = self;
    passwordView.money = _moneyTextField.text;
    passwordView.titleLabel.text = @"蚂蚁通转账";
    [passwordView popAnimationView:[UIApplication sharedApplication].keyWindow];
}
//支付宝转账
-(void)alipayTransfer{
    NSString *url = [NSString stringWithFormat:@"%@Wallet/transferAccountOfAlipay",BASE_URL];
    CGFloat sureMoney = [self.moneyTextField.text floatValue]*100;
    NSString *accont  = [NSString stringWithFormat:@"%d",(int)sureMoney];
   
    
    NSString *toIDStr;
    if (_toID) {
        toIDStr = _toID;
    }else{
        toIDStr = self.friendsInfo.fid;
    }
    NSDictionary *dic = @{
                          @"toId" : toIDStr,
                          @"tranAmount" : accont,
                          @"uid" : [DLTUserCenter userCenter].curUser.uid,
                          @"token" : [DLTUserCenter userCenter].token
                          };
    
    
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
      
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(response[@"data"]){
                    NSDictionary  * dic = response[@"data"];
                    if(dic){
                        NSString *body = dic[@"body"];
                        
                        [[AlipaySDK defaultService] payOrder:body fromScheme:@"alipaysdk" callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                            NSInteger orderState=[resultDic[@"resultStatus"]integerValue];
                            if (orderState==9000) {
                                [self.navigationController popViewControllerAnimated:YES];
                                [DLAlert alertWithText:@"转账成功"];
                                
                            }
                        }];
                    }
                }
            });
        }else{
            [DLAlert alertWithText:response[@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"错了莫名其妙的就出现错了怎么那个是好的我这个就是错的呢");
    } progress:nil];

}
#pragma mark - 自定义代理
- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password {
    [self dl_networkForTransferAccountWithPassword:password];

}
#pragma mark - 网络请求
- (void)dl_networkForTransferAccountWithPassword:(NSString *)password {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/transferAccount",BASE_URL];
    CGFloat sureMoney = [self.moneyTextField.text floatValue]*100;
    NSString *accont  = [NSString stringWithFormat:@"%d",(int)sureMoney];

    NSString *toIDStr;
    if (_toID) {
        toIDStr = _toID;
    }else{
        toIDStr = self.friendsInfo.fid;
    }
    NSDictionary *dic = @{
                          @"toId" : toIDStr,
                          @"tranAmount" : accont,
                          @"payPwd" : password,
                          @"uid" : [DLTUserCenter userCenter].curUser.uid,
                          @"token" : [DLTUserCenter userCenter].token
                          };
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [DLAlert alertWithText:@"转账成功"];
            });
        }else{
            [DLAlert alertWithText:response[@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

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

@end
