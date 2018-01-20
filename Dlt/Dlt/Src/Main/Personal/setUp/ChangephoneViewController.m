//
//  ChangephoneViewController.m
//  Dlt
//
//  Created by USER on 2017/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ChangephoneViewController.h"

@interface ChangephoneViewController ()<UITextFieldDelegate>
{
    NSString * currenetxt;
    NSString * newtext;
    NSString * againtext;

}
@property(nonatomic,strong)UITextField * currendPassword;
@property(nonatomic,strong)UITextField * newpassword;
@property(nonatomic,strong)UITextField * agianPassword;
@property(nonatomic,strong)UILabel * line;
@property(nonatomic,strong)UILabel * line1;
@property(nonatomic,strong)UILabel * line2;
@property(nonatomic,strong)UIButton * completeBtn;

@end

@implementation ChangephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addleftitem];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.currendPassword];
    [self.view addSubview:self.line];
    [self.view addSubview:self.newpassword];
    [self.view addSubview:self.agianPassword];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.completeBtn];

    // Do any additional setup after loading the view.
}
-(UITextField *)currendPassword
{
    if (_currendPassword ==nil) {
        _currendPassword = [[UITextField alloc]initWithFrame:RectMake_LFL(15, 35+NAVIH, 0, 55)];
        _currendPassword.delegate = self;
        _currendPassword.width_sd = WIDTH-30;
        _currendPassword.font = AdaptedFontSize(17);
        _currendPassword.placeholder = @"请输入当前登录密码";
        _currendPassword.secureTextEntry = YES;
        [_currendPassword addTarget:self action:@selector(currenpassword:) forControlEvents:UIControlEventEditingChanged];
    }

    
    return _currendPassword;
    
    
}
-(UILabel *)line
{
    if (_line == nil) {
        _line =[[UILabel alloc]initWithFrame:RectMake_LFL(self.currendPassword.left_sd, 0, 0, 0.5)];
        _line.top_sd = self.currendPassword.bottom_sd;
        _line.width_sd = self.currendPassword.width_sd;
        _line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    }

    return _line;
    
    
}
-(UITextField *)newpassword
{
    if (_newpassword ==nil) {
        _newpassword = [[UITextField alloc]initWithFrame:RectMake_LFL(15, 0, 0, 55)];
        _newpassword.delegate = self;
        _newpassword.top_sd = self.line.bottom_sd;
        _newpassword.width_sd = self.line.width_sd;
        _newpassword.font = AdaptedFontSize(17);
        _newpassword.placeholder = @"请输入新登录密码";
        _newpassword.secureTextEntry = YES;
        [_newpassword addTarget:self action:@selector(newnpassword:) forControlEvents:UIControlEventEditingChanged];
    }
    
    
    return _newpassword;
    
    
}
-(UILabel *)line1
{
    if (_line1 == nil) {
        _line1 =[[UILabel alloc]initWithFrame:RectMake_LFL(self.currendPassword.left_sd, 0, 0, 0.5)];
        _line1.top_sd = self.newpassword.bottom_sd;
        _line1.width_sd = self.newpassword.width_sd;
        _line1.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    }
    
    return _line1;
    
    
}
-(UITextField *)agianPassword
{
    if (_agianPassword ==nil) {
        _agianPassword = [[UITextField alloc]initWithFrame:RectMake_LFL(15, 0, 0, 55)];
        _agianPassword.delegate = self;
        _agianPassword.top_sd = self.line1.bottom_sd;
        _agianPassword.width_sd = self.line.width_sd;
        _agianPassword.font = AdaptedFontSize(17);
        _agianPassword.placeholder = @"请再次输入新登录密码";
        _agianPassword.secureTextEntry = YES;
        [_agianPassword addTarget:self action:@selector(againpassword:) forControlEvents:UIControlEventEditingChanged];
    }
    
    
    return _agianPassword;
    
    
}
-(UILabel *)line2
{
    if (_line2 == nil) {
        _line2 =[[UILabel alloc]initWithFrame:RectMake_LFL(self.currendPassword.left_sd, 0, 0, 0.5)];
        _line2.top_sd = self.agianPassword.bottom_sd;
        _line2.width_sd = self.agianPassword.width_sd;
        _line2.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    }
    
    return _line2;
    
    
}

-(UIButton *)completeBtn{
    if (_completeBtn == nil) {
        _completeBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 0, 45)];
        _completeBtn.top_sd = self.line2.bottom_sd + 35;
        _completeBtn.width_sd = self.line2.width_sd;
        
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeBtn.backgroundColor = [UIColor colorWithHexString:@"9c9c9c"];
        _completeBtn.userInteractionEnabled = NO;
        _completeBtn.layer.cornerRadius = 4;
        _completeBtn.layer.masksToBounds = YES;
        [_completeBtn addTarget:self action:@selector(complet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

#pragma mark--click

-(void)currenpassword:(UITextField *)text{
    currenetxt = text.text;
}

-(void)newnpassword:(UITextField *)text{
    newtext = text.text;
}
-(void)againpassword:(UITextField *)text{
    againtext = text.text;
    if ([againtext isEqualToString:newtext]) {
        self.completeBtn.userInteractionEnabled = YES;
        [self.completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.completeBtn.backgroundColor = [UIColor colorWithHexString:@"0080F5"];

    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(void)complet{
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
    NSString * url = [NSString stringWithFormat:@"%@UserCenter/userPwdModify",BASE_URL];
    NSDictionary * dic = @{@"token":userCenter.token,
                           @"uid":userCenter.curUser.uid,
                           @"pwd":[CLMd5Tool MD5ForLower32Bate:newtext],
                           @"oldPwd":[CLMd5Tool MD5ForLower32Bate:currenetxt]};
  
    [BANetManager ba_request_POSTWithUrlString:url
                                    parameters:dic
                                  successBlock:^(id response) {
                                    NSLog(@"response: %@",response);
        if ([response[@"code"]integerValue]==1) {
            [BAAlertView showTitle:nil message:@"修改成功"];
          [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [BAAlertView showTitle:nil message:@"修改失败"];

        }
    } failureBlock:^(NSError *error) {
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end
