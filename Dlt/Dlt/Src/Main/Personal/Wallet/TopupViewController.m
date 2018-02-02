//
//  TopupViewController.m
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "TopupViewController.h"
#import "TopUpCell.h"
#import "PayCell.h"
#import "ChangephoneCell.h"
#import "SelectorPayCell.h"
#import "DLWalletPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ProtocalViewController.h"
#import "SDAutoLayout.h"

#define TopUpCellInderifer @"TopUpCellInderifer"
#define PayCellInderifer @"PayCellInderifer"
#define ChangephoneCellInderifer @"ChangephoneCellInderifer"
#define SelectorPayCellInderifer @"SelectorPayCellInderifer"

@interface TopupViewController ()

@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * value;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) DLWalletPayModel *paymodel;
@property (nonatomic, strong) UIButton *nextStep;//下一步
@property (nonatomic, strong) UIButton *isAgreeBtn;

@end

@implementation TopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"充值";
    [self back:@"friends_15"];
    [self.tableView registerClass:[TopUpCell class] forCellReuseIdentifier:TopUpCellInderifer];
      [self.tableView registerClass:[PayCell class] forCellReuseIdentifier:PayCellInderifer];
         [self.tableView registerClass:[ChangephoneCell class] forCellReuseIdentifier:ChangephoneCellInderifer];
    [self.tableView registerClass:[SelectorPayCell class] forCellReuseIdentifier:SelectorPayCellInderifer];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.dataArr = [DLWalletPayModel paymodelInstance];
    self.paymodel = [[DLWalletPayModel paymodelInstance] firstObject];
    
    self.tableView.tableFooterView = [self footerView];
}
- (void)backclick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.dataArr.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        return 210;
    }
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        TopUpCell * cell = [tableView dequeueReusableCellWithIdentifier:TopUpCellInderifer];
        @weakify(self)
        cell.ismoneyClick  = ^(UITextField *text) {
            @strongify(self)
            self.amount= text.text;
        };
        return cell;
    }
    PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
    [cell file:self.dataArr[indexPath.row - 1]];
    return cell;
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
        if (!self.paymodel.isOpen) {
            [DLAlert alertWithText:@"目前只提供支付宝提现，其他功能暂未开通"];
            return;
        }
        if (ISNULLSTR(self.amount)) {
            [DLAlert alertWithText:@"请输入充值金额"];
            return;
        }
        [self dl_networkForRecharge];
     }else{
         [DLAlert alertWithText:@"请阅读并同意《蚂蚁通钱包用户协议》"];
         return;
     }
}

#pragma mark - 网络请求
- (void)dl_networkForRecharge {
    NSString * url = [NSString stringWithFormat:@"%@Wallet/recharge",BASE_URL];
    NSString *payType;
    if ([self.paymodel.payType isEqualToString:@"aliPay"]) {
        payType = @"1";
    } else if ([self.paymodel.payType isEqualToString:@"weChatPay"]) {
         payType = @"2";
    } else {
         payType = @"3";
    }
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary * dic = @{
                           @"token":[DLTUserCenter userCenter].token,
                           @"uid":user.uid,
                           @"amount":[NSString stringWithFormat:@"%.0f",[self.amount floatValue] * 100],
                           @"payType":payType
                           };
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        if ([response[@"code"]integerValue]==1) {
            if(response[@"data"]){
                NSDictionary  * dic = response[@"data"];
                if(dic){
                    NSString * body = dic[@"body"];
                    [[AlipaySDK defaultService] payOrder:body fromScheme:@"alipaysdk"
                                                callback:^(NSDictionary *resultDic) {
                                                    NSInteger orderState=[resultDic[@"resultStatus"]integerValue];
                                                    if (orderState==9000) {
                                                        [DLAlert alertWithText:@"充值成功"];
                                                    }
                                                }];
                }
            }
          
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:response[@"msg"]];
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


#pragma mark - 本类私有方法
- (UIView *)footerView {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, footer.frame.size.width, .4)];
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [footer addSubview:line];
    
    self.nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextStep.frame = CGRectMake(30, 40, footer.frame.size.width - 60, 45);
    [self.nextStep ui_setCornerRadius:6];
    [self.nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextStep.titleLabel.font = [UIFont systemFontOfSize:17];
   
    [self.nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextStep addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.nextStep];
    
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn setTitle:@"同意《蚂蚁通钱包用户协议》" forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(toProtocol) forControlEvents:UIControlEventTouchUpInside];    signBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
