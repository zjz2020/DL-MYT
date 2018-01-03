//
//  DLCostViewController.m
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLCostViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLCostTableViewCell.h"
#import "DLPasswordInputView.h"
#import "RCHttpTools.h"
#import "SetupPasswordViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@interface DLCostViewController ()<DLPasswordInputViewDelegate>
@property (nonatomic , strong)UITextField *moneyField;
@property (nonatomic , strong)UITableView *tabelView;
@property (nonatomic , assign)int row;
@end

@implementation DLCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置推广费用";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addHeardView];
}
-(void)addHeardView{
    UIView *heardView = [UIView new];
    heardView.width = WIDTH;
    UILabel *topLabel = [UILabel new];
    topLabel.text = @"设置广告推广费用";
    topLabel.font = [UIFont systemFontOfSize:14];
    _moneyField = [UITextField new];
    _moneyField.keyboardType = UIKeyboardTypePhonePad;
    _moneyField.placeholder = @"00.00";
    _moneyField.font = [UIFont systemFontOfSize:40];
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = @"广告推广费用消费完后广告即下架";
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    UIView *line = [UIView new];
    line.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    
    [heardView sd_addSubviews:@[topLabel,_moneyField,line,moneyLabel,lineView]];
    CGFloat left = 10;
    topLabel.sd_layout
    .topSpaceToView(heardView, 40)
    .leftSpaceToView(heardView, left)
    .heightIs(15);
    [topLabel setSingleLineAutoResizeWithMaxWidth:200];
    _moneyField.sd_layout
    .topSpaceToView(topLabel, 20)
    .leftSpaceToView(heardView, left)
    .rightSpaceToView(heardView, 0)
    .heightIs(40);
    line.sd_layout
    .topSpaceToView(_moneyField, 20)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0)
    .heightIs(1);
    moneyLabel.sd_layout
    .topSpaceToView(line, 12)
    .leftSpaceToView(heardView, left)
    .heightIs(22);
    [moneyLabel setSingleLineAutoResizeWithMaxWidth:300];
    lineView.sd_layout
    .topSpaceToView(moneyLabel, 10)
    .heightIs(10)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0);
    UILabel *payLabel = [UILabel new];
    payLabel.text = @"支付方式";
    payLabel.font = [UIFont systemFontOfSize:14];
    UIView *line2 = [UIView new];
    line2.backgroundColor =UICOLORRGB(232, 232, 232, 1.0);
    [heardView sd_addSubviews:@[payLabel,line2]];
    payLabel.sd_layout
    .topSpaceToView(lineView, 12.5)
    .leftSpaceToView(heardView, 10)
    .heightIs(15)
    .widthIs(100);
    line2.sd_layout
    .topSpaceToView(payLabel, 12.5)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0)
    .heightIs(1);
    [heardView setupAutoHeightWithBottomView:line2 bottomMargin:0];
    [heardView layoutSubviews];
    UIView *footView = [UIView new];
    [self setUpFootView:footView];
    _tabelView = [UITableView new];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableHeaderView = heardView;
    _tabelView.tableFooterView = footView;
    [self.view addSubview:_tabelView];
    _tabelView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}
-(void)setUpFootView:(UIView *)footView{
    footView.width = WIDTH;
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = DLBLUECOLOR;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 10;
    [sureBtn setTintColor:[UIColor whiteColor]];
    [sureBtn setTitle:@"确认" forState:0];
    [sureBtn addTarget:self action:@selector(upSureButton) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sureBtn];
    sureBtn.sd_layout
    .topSpaceToView(footView, 40)
    .heightIs(45)
    .widthIs(315)
    .centerXEqualToView(footView);
    [footView setupAutoHeightWithBottomView:sureBtn bottomMargin:100];
    [footView layoutSubviews];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"COSTCELL";
    DLCostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DLCostTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
    if (indexPath.row == 0 && _row == 0) {
        cell.isSeleced = YES;
    }
    cell.row = indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLCostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        _row = 0;
        cell.isSeleced = YES;
        NSIndexPath *noIndex = [NSIndexPath indexPathForRow:1 inSection:0];
        DLCostTableViewCell *noCell = [tableView cellForRowAtIndexPath:noIndex];
        noCell.isSeleced = NO;
    }else if (indexPath.row == 1){
        _row = 1;
        cell.isSeleced = YES;
        NSIndexPath *noIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        DLCostTableViewCell *noCell = [tableView cellForRowAtIndexPath:noIndex];
        noCell.isSeleced = NO;
    }
    [tableView reloadData];

}
//  NSLog(@"点击了确认");
-(void)upSureButton{
    
    if (_row == 0) {
        @weakify(self)
        [[RCHttpTools shareInstance] userIsSetPayPassword:^(BOOL isSet) {
            @strongify(self)
            if (isSet) {
                DLPasswordInputView * inputview = [DLPasswordInputView initInputView];
                inputview.delegate = self;
                inputview.money = _moneyField.text;
                [inputview popAnimationView:self.view];
                
            } else {
                SetupPasswordViewController * setuppassword = [[SetupPasswordViewController alloc]init];
                [self.navigationController pushViewController:setuppassword animated:YES];
            }
        }];
    }else{
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
            [DLAlert alertWithText:@"请安装支付宝客户端"];
            return;
        }
        if (_isLink) {
            [self editText:_AdTitle passWord:@"zhifubao" type:@"1"];
        }else{
            
            [self editText:_AdTitle passWord:@"zhifubao" type:@"2"];
        }
    }
    
    
}
- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password{
        if (_isLink) {
            [self editText:_AdTitle passWord:password type:@"1"];
        }else{
            
            [self editText:_AdTitle passWord:password type:@"2"];
        }
}
//支付
-(void)editText:(NSString *)title passWord:(NSString *)password type:(NSString *)type{
   
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url ;
    if ([password isEqualToString:@"zhifubao"]) {
        url = [NSString stringWithFormat:@"%@promote/PubAdsOfAlipay",BASE_URL];
    }else{
        url = [NSString stringWithFormat:@"%@promote/pubads",BASE_URL];
    }
    
    CGFloat sureMoney = [self.moneyField.text floatValue]*100;
    NSString *money  = [NSString stringWithFormat:@"%d",(int)sureMoney];
    
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"text" : title,
                             @"promoteMoney" : money,
                             @"promoteType" :type,
                             @"coverImg":_covorImage,
                             @"cityCode":_cityCodeStr
                             };
     NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    if (![password isEqualToString:@"zhifubao"]) {
        param[@"payPwd"] = password;
    }
    
    if ([type isEqualToString:@"1"]) {
        param[@"title"] = _linkTitle;
    }
    
    [BANetManager ba_request_POSTWithUrlString:url parameters:param successBlock:^(id response) {
        
        if ([response[@"code"] intValue] == 1) {
            if (![password isEqualToString:@"zhifubao"]) {
                [DLAlert alertWithText:@"申请成功等待审核"];
                UIViewController *viewCtl = self.navigationController.viewControllers[2];
                [self.navigationController popToViewController:viewCtl animated:YES];
            }else{
                [self costPutAdsOfAlipay:response[@"data"]];
            }
           
        }else{
            [DLAlert alertWithText:response[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
-(void)costPutAdsOfAlipay:(NSString *)body{
   
    [[AlipaySDK defaultService] payOrder:body fromScheme:@"alipaysdk" callback:^(NSDictionary *resultDic) {
    
        NSInteger orderState=[resultDic[@"resultStatus"]integerValue];
        if (orderState==9000) {
            
            [DLAlert alertWithText:@"申请成功等待审核"];
            UIViewController *viewCtl = self.navigationController.viewControllers[2];
            [self.navigationController popToViewController:viewCtl animated:YES];
            
        }
        
    }];

}
@end
