//
//  SetupPasswordViewController.m
//  Dlt
//
//  Created by USER on 2017/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SetupPasswordViewController.h"
#import "TXTradePasswordView.h"
#import "SetupagainpasswordViewController.h"
@interface SetupPasswordViewController ()<TXTradePasswordViewDelegate>
{
    TXTradePasswordView *TXView;
}
@end

@implementation SetupPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"设置支付密码";
    self.view.backgroundColor = [UIColor whiteColor];

    [self addleftitem];

}
-(void)viewWillAppear:(BOOL)animated
{
    if (_changeType==0) {
        self.title = @"设置支付密码";
        TXView = [[TXTradePasswordView alloc]initWithFrame:RectMake_LFL(0, 100,0, 200) WithTitle:@"请设置支付密码,勿与银行卡取款密码相同"];
        TXView.width_sd = WIDTH;
        TXView.TXTradePasswordDelegate = self;
        if (![TXView.TF becomeFirstResponder])
        {
            //成为第一响应者。弹出键盘
            [TXView.TF becomeFirstResponder];
        }
        
        
        [self.view addSubview:TXView];
    }else
    {
        self.title = @"修改支付密码";
        TXView = [[TXTradePasswordView alloc]initWithFrame:RectMake_LFL(0, 100,0, 200) WithTitle:@"输入当前支付密码"];
        TXView.width_sd = WIDTH;
        TXView.TXTradePasswordDelegate = self;
        if (![TXView.TF becomeFirstResponder])
        {
            //成为第一响应者。弹出键盘
            [TXView.TF becomeFirstResponder];
        }
        
        
        [self.view addSubview:TXView];
    }
}
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    if (_changeType==0) {
        if (Password.length==6) {
            //[DEFAULTS setObject:Password forKey:@"Paypassword"];
//            NSString * token = [DEFAULTS objectForKey:@"token"];
//            NSString * uid = [DEFAULTS objectForKey:@"uid"];
            
            DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

            NSDictionary * dic = @{@"token":[DLTUserCenter userCenter].token,
                                   @"uid":user.uid,
                                   @"payPwd":Password};
            NSString * url = [NSString stringWithFormat:@"%@Wallet/setPayPwd",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:dic
                                          successBlock:^(id response) {
                                              if ([response[@"code"]integerValue]==1) {
                                                  NSLog(@"密码 = %@",Password);
                                                  SetupagainpasswordViewController * again = [[SetupagainpasswordViewController alloc]init];
                                                  again.seleType= _changeType;
                                                  again.oldPassword = Password;

                                                  [self.navigationController pushViewController:again animated:YES];
                                              }else
                                              {
                                                  [BAAlertView showTitle:nil message:response[@"msg"]];
                                                   [TXView.TF becomeFirstResponder];
                                              }
                                              
                                              
                                          } failureBlock:^(NSError *error) {
                                              
                                          } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                              
                                          }];
        }

    }else
    {
        if (Password.length==6) {
            //[DEFAULTS setObject:Password forKey:@"Paypassword"];
//            NSString * token = [DEFAULTS objectForKey:@"token"];
//            NSString * uid = [DEFAULTS objectForKey:@"uid"];
            DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

            NSDictionary * dic = @{@"token":[DLTUserCenter userCenter].token,
                                   @"uid":user.uid,
                                   @"paypwd":Password};
            NSString * url = [NSString stringWithFormat:@"%@Wallet/verifyPaypwd",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:dic
                                          successBlock:^(id response) {
//                                              BOOL isset = [response[@"data"] boolValue];
//                                              NSString * issetup = isset?@"true":@"false";
                                               NSString * issetup = [response[@"data"] stringValue];
                                              NSLog(@"密码 = %@",issetup);

                                              if ([issetup isEqualToString:@"1"]) {
                                                  NSLog(@"密码 = %@",Password);
                                                  SetupagainpasswordViewController * again = [[SetupagainpasswordViewController alloc]init];
                                                  again.seleType = _changeType;
                                                  again.oldPassword = Password;
                                                  [self.navigationController pushViewController:again animated:YES];
                                              }else
                                              {
                                                  [BAAlertView showTitle:nil message:@"支付密码错误"];
                                                  [TXView.TF becomeFirstResponder];
                                              }

                                              
                                          } failureBlock:^(NSError *error) {
//                                              [BAAlertView showTitle:nil message:error];
                                              
                                          } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                              
                                          }];
        }

    }
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
