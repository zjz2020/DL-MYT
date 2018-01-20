//
//  NewsetupViewController.m
//  Dlt
//
//  Created by USER on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "NewsetupViewController.h"
#import "TXTradePasswordView.h"
#import "WalleatViewController.h"
@interface NewsetupViewController ()<TXTradePasswordViewDelegate>
{
    TXTradePasswordView *TXView;

}
@end

@implementation NewsetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addleftitem];
    self.title = @"修改支付密码";
    TXView = [[TXTradePasswordView alloc]initWithFrame:RectMake_LFL(0, 100,0, 200) WithTitle:@"再次输入新的支付密码"];
    TXView.width_sd = WIDTH;
    TXView.TXTradePasswordDelegate = self;
    if (![TXView.TF becomeFirstResponder])
    {
        //成为第一响应者。弹出键盘
        [TXView.TF becomeFirstResponder];
    }
    [self.view addSubview:TXView];
}
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    if ([_againPassword isEqualToString:Password]) {
       
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        
        NSDictionary * dic = @{@"token":[DLTUserCenter userCenter].token,
                               @"uid":user.uid,
                               @"payPwd":Password,
                               @"oldPaypwd":_oldPassword};
        
        NSString * url = [NSString stringWithFormat:@"%@wallet/modifyPayPwd",BASE_URL];
        [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
            
            if ([response[@"code"]integerValue]==1) {
            
                BOOL result = YES;
                WalleatViewController * walleat = [[WalleatViewController alloc]init];
                walleat.result =result;
                [self.navigationController pushViewController:walleat animated:YES];
                
            }else
            {

               [BAAlertView showTitle:nil message:@"重置密码失败"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failureBlock:^(NSError *error) {
            // [BAAlertView showTitle:nil message:@"出现错误"];
        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];
        

        
    }else
    {
        [BAAlertView showTitle:nil message:@"两次设置不一样"];

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
