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
        BOOL result = YES;
        WalleatViewController * walleat = [[WalleatViewController alloc]init];
        walleat.result =result;
        [self.navigationController pushViewController:walleat animated:YES];
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
