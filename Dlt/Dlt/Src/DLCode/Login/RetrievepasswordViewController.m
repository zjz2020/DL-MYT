//
//  RetrievepasswordViewController.m
//  Dlt
//
//  Created by USER on 2017/5/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RetrievepasswordViewController.h"
#import "LoginViewController.h"
#import "BANewsNetManager.h"
#import "DLAdverAgreementViewController.h"
#import "XWCountryCodeController.h"
@interface RetrievepasswordViewController ()<UITextFieldDelegate,XWCountryCodeControllerDelegate>
{

    NSString * codetext;
    NSString * passwordtext;
    NSString * newpassword;
    
    
    
}
@property(nonatomic,strong)UIImageView * centerImage;
@property(nonatomic,strong)UIButton * regionBtn;
@property(nonatomic,strong)UITextField * phoneField;
@property(nonatomic,strong)UITextField * passwordField;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,strong)UILabel * phoneline;
@property(nonatomic,strong)UILabel * passwordline;
@property(nonatomic,strong)UIButton * backBtn;
@property(nonatomic,strong)UIButton * VerificationcodeBtn;
@property(nonatomic,strong)UITextField * registerFiled;
@property(nonatomic,strong)UILabel * registerline;
@property(nonatomic,strong)UIButton * lookBtn;
@property (strong, nonatomic) dispatch_source_t timer2;

@end

@implementation RetrievepasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup
{
    [self.view addSubview:self.centerImage];
    [self.view addSubview:self.regionBtn];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.phoneline];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.passwordline];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.VerificationcodeBtn];
    [self.view addSubview:self.registerline];
    [self.view addSubview:self.registerFiled];
    [self.view addSubview:self.lookBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.mas_equalTo(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+2);
        make.width.height.mas_equalTo(24);
    }];
    
    
    [_centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(75);
    }];
    [_regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImage.mas_bottom).offset(10);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(WIDTH-60);
        make.height.mas_equalTo(30);
        
    }];
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImage.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(WIDTH-60);
        make.height.mas_equalTo(55);
    }];
    
    [_phoneline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneField.mas_bottom).offset(0);
        make.left.mas_equalTo(_phoneField);
        make.width.mas_equalTo(_phoneField);
        make.height.mas_equalTo(0.5);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneline.mas_bottom).offset(0);
        make.left.mas_equalTo(_phoneField);
        make.width.mas_equalTo(_phoneField);
        make.height.mas_equalTo(_phoneField);
    }];
    [_passwordline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordField.mas_bottom).offset(0);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(0.5);
    }];
    
    [_registerFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordline.mas_bottom).offset(0);
        make.left.mas_equalTo(_phoneField);
        make.width.mas_equalTo(_phoneField);
        make.height.mas_equalTo(_phoneField);
    }];
    [_registerline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerFiled.mas_bottom).offset(0);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(0.5);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerFiled.mas_bottom).offset(35);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(45);
    }];
    
    [_VerificationcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneline.mas_bottom).offset(7);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(WIDTH-(74+40));
    }];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordline.mas_bottom).offset(15);
        make.left.mas_equalTo(WIDTH-60);
        make.width.height.mas_equalTo(24);
    }];
   
}
-(UIButton *)regionBtn{
    if (_regionBtn == nil) {
        _regionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_regionBtn setTintColor:[UIColor blackColor]];
        [_regionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_regionBtn addTarget:self action:@selector(upRegionButton) forControlEvents:UIControlEventTouchUpInside];
        [_regionBtn setTitle:@"中国 +86" forState:0];
    }return _regionBtn;
}
-(void)upRegionButton{
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    CountryCodeVC.deleagete = self;
    
    //block
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        
        [_regionBtn setTitle:countryCodeStr forState:0];
    }];
    
    [self presentViewController:CountryCodeVC animated:YES completion:nil];
}
-(UIImageView *)centerImage
{
    if (_centerImage == nil) {
        _centerImage = [[UIImageView alloc]initWithFrame:RectMake_LFL(286/2, 150/2, 180/2, 90)];
        _centerImage.image = [UIImage imageNamed:@"Login_00"];
    }
    return _centerImage;
}
-(UITextField *)phoneField
{
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc]initWithFrame:RectMake_LFL(58/2, 0, 0, 55)];
        _phoneField.delegate = self;
        _phoneField.top_sd = self.centerImage.bottom_sd + 40;
        _phoneField.width_sd = WIDTH - 70;
        _phoneField.placeholder = @" / 请输入您的手机号";
        _phoneField.font = AdaptedFontSize(17);
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        phoneimage.image = [UIImage imageNamed:@"Login_01"];
        _phoneField.leftView = phoneimage;
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneField;
}
-(UILabel *)phoneline
{
    if (_phoneline == nil) {
        _phoneline = [[UILabel alloc]initWithFrame:RectMake_LFL(self.phoneField.left_sd, self.phoneField.width_sd, 0, 0.5)];
        _phoneline.top_sd = self.phoneField.bottom_sd;
        _phoneline.width_sd = self.phoneField.width_sd;
        _phoneline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _phoneline;
}
-(UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc]initWithFrame:RectMake_LFL(58/2, 0, 0, 55)];
        _passwordField.delegate = self;
        _passwordField.top_sd = self.phoneline.bottom_sd ;
        _passwordField.width_sd = WIDTH -65;
        _passwordField.placeholder = @" / 短信验证码";
        _passwordField.font = AdaptedFontSize(17);
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        phoneimage.image = [UIImage imageNamed:@"Login_09"];
        _passwordField.leftView = phoneimage;
        _passwordField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordField;
}
-(UILabel *)passwordline
{
    if (_passwordline == nil) {
        _passwordline = [[UILabel alloc]initWithFrame:RectMake_LFL(self.passwordField.left_sd, 0, self.passwordField.width_sd, 0.5)];
        _passwordline.top_sd = self.passwordField.bottom_sd;
        _passwordline.width_sd = self.passwordField.width_sd;
        _passwordline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _passwordline;
}

-(UITextField *)registerFiled
{
    if (_registerFiled == nil) {
        _registerFiled = [[UITextField alloc]initWithFrame:RectMake_LFL(58/2, 0, 0, 55)];
        _registerFiled.delegate = self;
        _registerFiled.top_sd = self.passwordline.bottom_sd ;
        _registerFiled.width_sd = WIDTH -65;
        _registerFiled.placeholder = @" / 请输入您的密码(6-12位)";
        _registerFiled.font = AdaptedFontSize(17);
        _registerFiled.keyboardType = UIKeyboardTypeASCIICapable;
        UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        phoneimage.image = [UIImage imageNamed:@"Login_03"];
        _registerFiled.leftView = phoneimage;
        _registerFiled.leftViewMode = UITextFieldViewModeAlways;
        _registerFiled.secureTextEntry = YES;
        [_registerFiled addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _registerFiled;
}
-(UILabel *)registerline
{
    if (_registerline == nil) {
        _registerline = [[UILabel alloc]initWithFrame:RectMake_LFL(self.passwordField.left_sd, 0, self.passwordField.width_sd, 0.5)];
        _registerline.top_sd = self.registerFiled.bottom_sd;
        _registerline.width_sd = self.passwordField.width_sd;
        _registerline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _registerline;
}
-(UIButton *)lookBtn
{
    if (_lookBtn == nil) {
        _lookBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        _lookBtn.top_sd = self.passwordline.bottom_sd +20;
        _lookBtn.left_sd = WIDTH-65;
        [_lookBtn setImage:[UIImage imageNamed:@"Login_04"] forState:UIControlStateNormal];
        [_lookBtn setImage:[UIImage imageNamed:@"Login_05"] forState:UIControlStateSelected];
        [_lookBtn addTarget:self action:@selector(secureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}

-(UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(58/2, 0, self.passwordline.width_sd, 45)];
        _loginBtn.top_sd = self.registerline.bottom_sd + 35;
        _loginBtn.width_sd = WIDTH - 58;
        [_loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = AdaptedFontSize(17);
        //        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#0080F5"];
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"9c9c9c"];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.userInteractionEnabled = NO;
    }
    return _loginBtn;
}
-(UIButton *)VerificationcodeBtn
{
    if (_VerificationcodeBtn == nil) {
        _VerificationcodeBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 148/2, 40)];
        _VerificationcodeBtn.left_sd = self.phoneField.right_sd - 74;
        _VerificationcodeBtn.top_sd = self.phoneline.bottom_sd +15/2;
        [_VerificationcodeBtn setTitle:@"获取" forState:UIControlStateNormal];
        _VerificationcodeBtn.titleLabel.font = AdaptedFontSize(17);
        [_VerificationcodeBtn setTitleColor:[UIColor colorWithHexString:@"FF701C"] forState:UIControlStateNormal];
        
        _VerificationcodeBtn.layer.borderWidth =0.5;
        _VerificationcodeBtn.layer.borderColor = [UIColor colorWithHexString:@"FF701C"].CGColor;
        _VerificationcodeBtn.layer.cornerRadius = 4;
        [_VerificationcodeBtn addTarget:self action:@selector(verification:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _VerificationcodeBtn;
}


-(UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 22, 24, 24)];
        [_backBtn setImage:[UIImage imageNamed:@"Login_08"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)verification:(UIButton *)btn
{
    
    if ([_phoneField.text isEqualToString:@""]) {
        return;
    }
    NSString *accountStr;
    if ([[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1] isEqualToString:@"86"]) {
        accountStr =self.phoneField.text;
    }else{
        accountStr= [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
        
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = accountStr;
    [BANewsNetManager getsmsParmeters:dic completionHandle:^(id model, NSError *error) {
        
    }];
    
    
    __block int timeout = 59;
    
    /*! 倒计时时间 */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer2 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer2,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    /*! 每秒执行 */
    dispatch_source_set_event_handler(self.timer2, ^{
        
        if(timeout <= 0)
        {
            /*! 倒计时结束，关闭 */
            dispatch_source_cancel(self.timer2); dispatch_async(dispatch_get_main_queue(), ^{
                
                /*! 设置界面的按钮显示 根据自己需求设置 */
                [btn setTitle:@"获取" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                
            });
        }
        else
        {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            if ([strTime isEqualToString:@"0"])
            {
                strTime = [NSString stringWithFormat:@"%d", 60];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                /*! 设置界面的按钮显示 根据自己需求设置 */
                // BALog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                
                
                //
                
                
                
                
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer2);
    
}
-(void)login
{
    NSString *accountStr;
    if ([[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1] isEqualToString:@"86"]) {
        accountStr =self.phoneField.text;
    }else{
        accountStr= [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
        
    }
    NSString * url = [NSString stringWithFormat:@"%@UserCenter/findPwd",BASE_URL];
    NSString * newpassword1 = [CLMd5Tool MD5ForLower32Bate:passwordtext];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:accountStr,@"account",codetext,@"vCode",newpassword1,@"pwd",nil];
    
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        [DEFAULTS setObject:passwordtext forKey:@"backPassword"];
        if ([response[@"code"]integerValue]==1) {
            LoginViewController * login = [[LoginViewController alloc]init];
            login.account = _phoneField.text;
            login.password = newpassword1;
            [self presentViewController:login animated:YES completion:nil];

        }
        else
        {
            [DLAlert alertWithText:response[@"msg"]];

        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error==%@",error);
      //  [BAAlertView showTitle:@"" message:@"出现错误"];
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}
-(void)secureTextEntry:(UIButton *)sender
{
    self.registerFiled.secureTextEntry = !self.registerFiled.secureTextEntry;
    sender.selected = !sender.selected;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.phoneField  == textField)  //判断是否时我们想要限定的那个输入框
    {
        
        if ([toBeString length] > 10) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:11];
            
            
            
            return NO;
        }
        
    }
    if (self.passwordField== textField) {
        if ([toBeString length]>5) {
            textField.text = [toBeString substringToIndex:6];
            
            
            codetext = textField.text;
            return NO;
        }
        
    }
    if (self.registerFiled == textField) {
        if (_phoneField.text == nil) {
            return @"";
        }
    }
    //    if (self.registerFiled == textField) {
    //        if ([toBeString length]>6) {
    //
    //                textField.text = [toBeString substringToIndex:7];
    //
    //                self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#0080f5"];
    //                self.loginBtn.userInteractionEnabled= YES;
    //                [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //                passwordtext = textField.text;
    //            NSLog(@"%@",passwordtext);
    //                return YES;
    //
    //            }else
    //            {
    //                self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#9c9c9c"];
    //                self.loginBtn.userInteractionEnabled= NO;
    //                [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //            }
    //
    //
    //    }
    //    [];
    //    [self ba_isPasswordQualified:self.registerFiled.text];
    return YES;
    
}
- (void)textFieldEditChanged:(UITextField *)textField

{
    NSLog(@"textfield text %@",textField.text);
    if (textField.text.length >5) {
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"0080f5"];
        self.loginBtn.userInteractionEnabled= YES;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        passwordtext = textField.text;
      
    }else
    {
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"9c9c9c"];
        self.loginBtn.userInteractionEnabled= NO;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    
    
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
