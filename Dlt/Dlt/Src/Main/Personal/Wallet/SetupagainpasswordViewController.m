//
//  SetupagainpasswordViewController.m
//  Dlt
//
//  Created by USER on 2017/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SetupagainpasswordViewController.h"
#import "TXTradePasswordView.h"
#import "WalleatViewController.h"
#import "NewsetupViewController.h"
@interface SetupagainpasswordViewController ()<TXTradePasswordViewDelegate>
{
    BOOL result;
    TXTradePasswordView *TXView;
}

@end

@implementation SetupagainpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"重次设置支付密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addleftitem];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_seleType==NO) {
        self.title = @"重次设置支付密码";
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
        TXView = [[TXTradePasswordView alloc]initWithFrame:RectMake_LFL(0, 100,0, 200) WithTitle:@"输入新的支付密码"];
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

    
    
    if (_seleType==NO) {
        if (![_oldPassword isEqualToString:Password]) {
            [BAAlertView showTitle:nil message:@"两次密码设置不一致"];

        }else
        {
            result=YES;
            WalleatViewController * walleat = [[WalleatViewController alloc]init];
            walleat.result =result;
            [self.navigationController pushViewController:walleat animated:YES];
            

        }
        
    }else
    {
//        NSString * token = [DEFAULTS objectForKey:@"token"];
//        NSString * uid = [DEFAULTS objectForKey:@"uid"];
//        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
//
//        NSDictionary * dic = @{@"token":[DLTUserCenter userCenter].token,
//                               @"uid":user.uid,
//                               @"payPwd":Password,
//                               @"oldPaypwd":_oldPassword};
//        
//        NSString * url = [NSString stringWithFormat:@"%@wallet/modifyPayPwd",BASE_URL];
//        [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
//            
//            if ([response[@"code"]integerValue]==1) {
////                SetupagainpasswordViewController * again = [[SetupagainpasswordViewController alloc]init];
////                again.resultcode = seletype;
////                again.againPassword = Password;
////                [self.navigationController pushViewController:again animated:YES];
//
        if ([Password isEqualToString:self.oldPassword]) {
            [DLAlert alertWithText:@"与原密码相同 请重新输入" afterDelay:3];
            
            SetupagainpasswordViewController *pagV = [[SetupagainpasswordViewController alloc] init];
            pagV.oldPassword = self.oldPassword;
            pagV.seleType = YES;
            [self.navigationController pushViewController:pagV animated:YES];
//            [TXView.TF becomeFirstResponder];
//            [self viewWillAppear:YES];
            return;
        }
        NewsetupViewController * news = [[NewsetupViewController alloc]init];
        news.againPassword = Password;
        news.oldPassword = _oldPassword;
        [self.navigationController pushViewController:news animated:YES];
//
//                
//                
//                
//            }else
//            {
////                [BAAlertView showTitle:nil message:@"密码出错"];
//                [DLAlert alertWithText:@"支付密码出错"];
//            }
//            
//        } failureBlock:^(NSError *error) {
//           // [BAAlertView showTitle:nil message:@"出现错误"];
//        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//            
//        }];
//    

    
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
