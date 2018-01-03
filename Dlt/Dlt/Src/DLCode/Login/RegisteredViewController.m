//
//  RegisteredViewController.m
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RegisteredViewController.h"
#import "RegisterInputViewController.h"
#import "BANewsNetManager.h"
#import "DLAdverAgreementViewController.h"
#import "AppDelegate.h"
#import "RegisterPersonDataViewController.h"
#import "XWCountryCodeController.h"
@interface RegisteredViewController ()<UITextFieldDelegate,XWCountryCodeControllerDelegate>
{
    NSString * codetext;
    NSString * passwordtext;
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

@property (strong , nonatomic)UIButton *chooseBtn;
@property (nonatomic , assign)BOOL isChoose;
@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
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
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+2;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.mas_equalTo(top);
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
        make.top.equalTo(_registerFiled.mas_bottom).offset(85);
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


    //    [self textdidchage:self.registerFiled];
    [self addAgreementView];

}
-(void)addAgreementView{
    UIView *agreeView = [UIView new];
    UIButton *pushNoticeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [pushNoticeBtn setTitle:@"用户协议书" forState:0];
    [pushNoticeBtn addTarget:self action:@selector(upPushNoticeButton) forControlEvents:UIControlEventTouchUpInside];
    [pushNoticeBtn setTintColor:[UIColor blackColor]];
    pushNoticeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *Image = [[UIImage imageNamed:@"bc_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"agrementYES"]) {
        _isChoose = YES;
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"agrementYES"];
    [_chooseBtn setImage:Image forState:0];
    _chooseBtn.tag = 10010;
    [_chooseBtn addTarget:self action:@selector(upChooseButton) forControlEvents:UIControlEventTouchUpInside];
    [agreeView sd_addSubviews:@[pushNoticeBtn,_chooseBtn]];
    pushNoticeBtn.sd_layout
    .centerXEqualToView(agreeView)
    .topSpaceToView(agreeView, 0);
    [pushNoticeBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:20];
    _chooseBtn.sd_layout
    .topSpaceToView(agreeView, 0)
    .rightSpaceToView(pushNoticeBtn, 5)
    .heightIs(20)
    .widthIs(20);
    [self.view addSubview:agreeView];
    [agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(20);
    }];
}
//点击了协议书
-(void)upPushNoticeButton{
    DLAdverAgreementViewController *sdView = [DLAdverAgreementViewController new];
    sdView.isLogin = YES;
    [self presentViewController:sdView animated:YES completion:nil];
}
//点击了方框
-(void)upChooseButton{
    if (_chooseBtn.tag == 10010) {
        _chooseBtn.tag = 10086;
        UIImage *Image = [[UIImage imageNamed:@"bc_03.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_chooseBtn setImage:Image forState:0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"agrementYES"];
        
    }else{
        _chooseBtn.tag = 10010;
        UIImage *Image = [[UIImage imageNamed:@"bc_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_chooseBtn setImage:Image forState:0];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"agrementYES"];
    }
    
}
-(UIImageView *)centerImage
{
    if (_centerImage == nil) {
        _centerImage = [[UIImageView alloc]init];
        _centerImage.image = [UIImage imageNamed:@"Login_00"];
    }
    return _centerImage;
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
-(UITextField *)phoneField
{
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc]init];
        _phoneField.delegate = self;
//        _phoneField.top_sd = self.centerImage.bottom_sd + 40;
//        _phoneField.width_sd = WIDTH -65;
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
        _phoneline = [[UILabel alloc]init];
//        _phoneline.top_sd = self.phoneField.bottom_sd;
//        _phoneline.width_sd = self.phoneField.width_sd;
        _phoneline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _phoneline;
}
-(UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc]init];        _passwordField.delegate = self;
//        _passwordField.top_sd = self.phoneline.bottom_sd ;
//        _passwordField.width_sd = WIDTH -65;
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
        _passwordline = [[UILabel alloc]init];
//        _passwordline.top_sd = self.passwordField.bottom_sd;
//        _passwordline.width_sd = self.passwordField.width_sd;
        _passwordline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _passwordline;
}

-(UITextField *)registerFiled
{
    if (_registerFiled == nil) {
        _registerFiled = [[UITextField alloc]init];        _registerFiled.delegate = self;
//        _registerFiled.top_sd = self.passwordline.bottom_sd ;
//        _registerFiled.width_sd = WIDTH -65;
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
        _registerline = [[UILabel alloc]init];
//        _registerline.top_sd = self.registerFiled.bottom_sd;
//        _registerline.width_sd = self.passwordField.width_sd;
        _registerline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _registerline;
}
-(UIButton *)lookBtn
{
    if (_lookBtn == nil) {
        _lookBtn = [[UIButton alloc]init];
//        _lookBtn.top_sd = self.passwordline.bottom_sd +20;
//        _lookBtn.left_sd = WIDTH-58;
        [_lookBtn setImage:[UIImage imageNamed:@"Login_04"] forState:UIControlStateNormal];
        [_lookBtn setImage:[UIImage imageNamed:@"Login_05"] forState:UIControlStateSelected];
        [_lookBtn addTarget:self action:@selector(secureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}

-(UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]init];
//        _loginBtn.top_sd = self.registerline.bottom_sd + 35;
//        _loginBtn.width_sd = WIDTH-58;
        [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
        _VerificationcodeBtn = [[UIButton alloc]init];
//        _VerificationcodeBtn.left_sd = self.phoneField.right_sd - 74;
//        _VerificationcodeBtn.top_sd = self.phoneline.bottom_sd +15/2;
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
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"Login_08"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(void)back
{
    if (_isChoose) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"agrementYES"];
    }
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
            dispatch_source_cancel(self.timer2);
            dispatch_async(dispatch_get_main_queue(), ^{
                
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
    [DLAlert alertShowLoad];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"agrementYES"]) {
        [DLAlert alertWithText:@"请阅读并同意用户协议"];
        return;
    }

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString *accountStr;
    if ([[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1] isEqualToString:@"86"]) {
        accountStr =self.phoneField.text;
    }else{
        accountStr= [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
    }
    NSLog(@"%@",accountStr);
    NSLog(@"%@",codetext);
    dic[@"account"]=accountStr;
    dic[@"vCode"] = codetext;

  
    NSString * url = [NSString stringWithFormat:@"%@UserCenter/checkSMSCode",BASE_URL];
    
    NSLog(@"---%@",url);
  
  @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        [DLAlert alertHideLoad];
      @strongify(self);
        NSNumber * code = response[@"code"];
        NSLog(@"%@",response);
        if ([code isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [BAAlertView showTitle:@"验证码错误" message:nil];
        }else if ([code isEqualToNumber:[NSNumber numberWithInt:1]])
        {
//            RegisterInputViewController * input = [[RegisterInputViewController alloc]init];
//            input.phone = phonetext;
//            input.code = codetext;
//            input.password = passwordtext;
//            [self presentViewController:input animated:NO completion:nil];
            NSString *password = [CLMd5Tool MD5ForLower32Bate:passwordtext];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:accountStr,@"account",password,@"password", nil];
            NSString * url =[NSString stringWithFormat:@"%@UserCenter/register",BASE_URL];
            
            @weakify(self);
            [BANetManager ba_request_POSTWithUrlString:url
                                            parameters:dic
                                          successBlock:^(id response) {
                                              @strongify(self);
                                              NSNumber * code =response[@"code"];
                                              if ([code isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                  //[BAAlertView showTitle:@"邀请码错误或者账号已经被注册" message:@""];
                                                  [DLAlert alertWithText:response[@"msg"]];
                                              }
                                              
                                              else{
                                                  [self Takelogin];
                                              }
                                              
                                              
                                          } failureBlock:^(NSError *error) {
                                              [DLAlert alertWithText:@"请保持网络畅通"];
                                          } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                              
                                          }];

        }
        
        
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"情保持网络畅通"];
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}
-(void)Takelogin{
    NSString *password = [CLMd5Tool MD5ForLower32Bate:passwordtext];
    
    @weakify(self);
    [[[DLTUserCenter userCenter] login:_phoneField.text
                              password:password]
     subscribeNext:^(id response) {
         @strongify(self);
         int code = [response[@"code"] intValue];
         
         
         if (code == 1){ // 登录成功
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[AppDelegate  shareAppdelegate] loginCompleted];
             });
         }
         
         else if (code == 2) {
             NSString * token = response[@"data"][@"token"];
             NSString * userId = response[@"data"][@"uid"];
             [self presentRegisterPersonDataViewController:token withUid:userId];
         }
     }
     error:^(NSError * _Nullable error) {
         
         if ( error.code == 10086) {
             [DLAlert alertWithText:@"密码或者账号有误"];
         }else{
             [DLAlert alertWithText:@"网络延迟请稍后重试"];
         }
         
     }
     
     completed:^{
         
     }];

}
- (void)presentRegisterPersonDataViewController:(NSString *)token withUid:(NSString *)userId{
    NSString *accountStr;
    if ([[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1] isEqualToString:@"86"]) {
        accountStr =self.phoneField.text;
    }else{
        accountStr= [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
        
    }
    
    RegisterPersonDataViewController * persondata = [[RegisterPersonDataViewController alloc]init];
    persondata.token = token;
    persondata.uid = userId;
    persondata.account = accountStr;
    persondata.pwd = passwordtext;
    [self presentViewController:persondata animated:YES completion:nil];
}
- (void)numnerIsRegister:(NSString *)number{
    NSString * url =[NSString stringWithFormat:@"%@UserCenter/isRegister",BASE_URL];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:number forKey:@"account"];
    [BANetManager ba_request_POSTWithUrlString:url
                                    parameters:dic
                                  successBlock:^(id response) {
                                      
                                      NSNumber * code =response[@"code"];
                                      if ([code isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                          if ([response[@"data"][@"isRegister"] integerValue] == 1) {
                                              [DLAlert alertWithText:@"该手机号已被注册！"];
                                          }
                                          
                                      }
                                      
                                      else{
                                         
                                      }
                                      
                                      
                                  } failureBlock:^(NSError *error) {
                                      
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
        if ([toBeString length] == 11) {
        if(![string isEqualToString:@""] && toBeString.length == 11){
            NSString *str = [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
            [self numnerIsRegister:str];
             
        }}
      
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
