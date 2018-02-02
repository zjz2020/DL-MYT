//
//  RegisterInputViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RegisterInputViewController.h"
#import "RegisterPersonDataViewController.h"
#import "BANetManager.h"
#import "LoginViewController.h"
#import "BAAlertView.h"
#import "GBAlertView.h"
#import "TDAlertView.h"
#import "UPPaymentControl.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIColor+NotRGB.h"



@interface RegisterInputViewController ()<UITextFieldDelegate,TDAlertViewDelegate>
{
    NSString * codetext;
    NSString * pName;
    NSString * pPrice;
    NSNumber * pId;
    NSString * body;
    NSString * newprice;

    TDAlertView *alert;
    TDAlertView *alert1;


}
@property(nonatomic,strong)UIImageView * centerImage;
@property(nonatomic,strong)UITextField * phoneField;
@property(nonatomic,strong)UITextField * passwordField;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,strong)UILabel * phoneline;
@property(nonatomic,strong)UILabel * passwordline;
@property(nonatomic,strong)UIButton * backBtn;
@property(nonatomic,strong)UIButton * VerificationcodeBtn;
@property(nonatomic,strong)UIButton * lookBtn;
@property(nonatomic,strong)UIButton * unreceiveSMSBtn;
@property (strong, nonatomic) dispatch_source_t timer2;

@end

@implementation RegisterInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    // Do any additional setup after loading the view.
}
-(void)setup
{
    [self.view addSubview:self.centerImage];
//    [self.view addSubview:self.phoneField];
//    [self.view addSubview:self.phoneline];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.passwordline];
    [self.view addSubview:self.loginBtn];
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.VerificationcodeBtn];
    [self.view addSubview:self.unreceiveSMSBtn];
    //    [self.view addSubview:self.lookBtn];
    
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
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImage.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(WIDTH-60);
        make.height.mas_equalTo(55);
    }];
    
    [_passwordline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordField.mas_bottom).offset(0);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(0.5);
    }];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordline.mas_bottom).offset(85);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(45);
    }];
    
    [_unreceiveSMSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordline.mas_bottom).offset(5);
        make.right.mas_equalTo(_passwordField);
        //make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(35);
    }];

    [_VerificationcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImage.mas_bottom).offset(47);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(WIDTH-(74+40));
    }];
    
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
        _phoneField.width_sd = WIDTH -58;
        _phoneField.placeholder = @" / 请输入您的密码(6-12位)";
        _phoneField.font = AdaptedFontSize(17);
        _phoneField.keyboardType = UIKeyboardTypeASCIICapable;
        UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        phoneimage.image = [UIImage imageNamed:@"Login_03"];
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
        _phoneline.backgroundColor = [UIColor ColorWithHexString:LINE];
    }
    return _phoneline;
}
-(UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc]initWithFrame:RectMake_LFL(58/2, 0, 0, 55)];
        _passwordField.delegate = self;
        _passwordField.top_sd = self.centerImage.bottom_sd +40;;
        _passwordField.width_sd = WIDTH -65;
        _passwordField.placeholder = @" / 请输入你邀请码";
        _passwordField.font = AdaptedFontSize(17);
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        phoneimage.image = [UIImage imageNamed:@"Login_11"];
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
        _passwordline.backgroundColor = [UIColor ColorWithHexString:LINE];
    }
    return _passwordline;
}
-(UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(58/2, 0, self.passwordline.width_sd, 45)];
        _loginBtn.top_sd = self.passwordline.bottom_sd + 35;
        _loginBtn.width_sd = WIDTH-58;
        [_loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = AdaptedFontSize(17);
        //        _loginBtn.backgroundColor = [UIColor ColorWithHexString:@"#0080F5"];
        _loginBtn.backgroundColor = [UIColor ColorWithHexString:@"9c9c9c"];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//        _loginBtn.userInteractionEnabled = NO;
    }
    return _loginBtn;
}
-(UIButton *)VerificationcodeBtn
{
    if (_VerificationcodeBtn == nil) {
        _VerificationcodeBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 148/2, 40)];
        _VerificationcodeBtn.left_sd = self.passwordField.right_sd - 74;
        _VerificationcodeBtn.top_sd = self.centerImage.bottom_sd +51;
        [_VerificationcodeBtn setTitle:@"购买" forState:UIControlStateNormal];
        _VerificationcodeBtn.titleLabel.font = AdaptedFontSize(17);
        [_VerificationcodeBtn setTitleColor:[UIColor ColorWithHexString:@"FF701C"] forState:UIControlStateNormal];
        
        _VerificationcodeBtn.layer.borderWidth =0.5;
        _VerificationcodeBtn.layer.borderColor = [UIColor ColorWithHexString:@"#FF701C"].CGColor;
        _VerificationcodeBtn.layer.cornerRadius = 4;
        [_VerificationcodeBtn addTarget:self action:@selector(verification:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _VerificationcodeBtn;
}
-(UIButton *)lookBtn
{
    if (_lookBtn == nil) {
        _lookBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        _lookBtn.top_sd = self.centerImage.bottom_sd +55;
        _lookBtn.left_sd = WIDTH-74;
        [_lookBtn setImage:[UIImage imageNamed:@"Login_04"] forState:UIControlStateNormal];
        [_lookBtn setImage:[UIImage imageNamed:@"Login_05"] forState:UIControlStateSelected];
        [_lookBtn addTarget:self action:@selector(secureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
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

-(UIButton *)unreceiveSMSBtn{
    if (_unreceiveSMSBtn == nil) {
        _unreceiveSMSBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        
        [_unreceiveSMSBtn setTitle:@"没收到邀请码？" forState:UIControlStateNormal];
        
        _unreceiveSMSBtn.frame = CGRectMake(self.loginBtn.right_sd - 110, 0, 110, 30);
        _unreceiveSMSBtn.top_sd = self.passwordline.bottom_sd + 5;
        
        //_unreceiveSMSBtn.titleLabel.font = AdaptedFontSize(17);
        //        _loginBtn.backgroundColor = [UIColor ColorWithHexString:@"#0080F5"];
        //        _unreceiveSMSBtn.backgroundColor = [UIColor ColorWithHexString:@"9c9c9c"];
        //[_unreceiveSMSBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        _unreceiveSMSBtn.layer.cornerRadius = 4;
        //        _unreceiveSMSBtn.layer.masksToBounds = YES;
        [_unreceiveSMSBtn addTarget:self action:@selector(ICodeInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unreceiveSMSBtn;
}

- (void)ICodeInfo{
    NSString * url = [NSString stringWithFormat:@"%@Order/Icode",BASE_URL];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"phone",nil];
    
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        
        if ([response[@"code"]integerValue]==1) {
            if(response[@"data"]){
                NSDictionary * dic = response[@"data"];
                if(dic){
                    NSString *icode = dic[@"icode"];
                    self.passwordField.text = icode;
                    
                    self.loginBtn.backgroundColor = [UIColor ColorWithHexString:@"0080f5"];
                    self.loginBtn.userInteractionEnabled= YES;
                    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    codetext = self.passwordField.text;
                }
            }
        }
        else
        {
            [DLAlert alertWithText:response[@"msg"]];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error==%@",error);
       // [BAAlertView showTitle:nil message:@"出现错误"];
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)verification:(UIButton *)btn
{

    
    [GBAlertView showWithtTtles:nil itemIndex:^(NSInteger itemIndex) {
        
  
        if (itemIndex==0) {
            NSString * url = [NSString stringWithFormat:@"%@Order/icodeInfo",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:nil successBlock:^(id response) {
                if ([response[@"code"]integerValue]==1) {
                    if(response[@"data"]){
                        NSDictionary  * dic = response[@"data"];
                        if(dic){
                            pName = dic[@"pName"];
                            pPrice = dic[@"pPrice"];
                            pId = dic[@"pId"];
                            int price =[pPrice intValue];
                            float  a = (float)price/100;
                            newprice = [NSString stringWithFormat:@"¥%.2f",a];
                            [self aleart1];
                        }
                    }
                }
            } failureBlock:^(NSError *error) {
               // [BAAlertView showTitle:nil message:@"出现错误"];

            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];

        }
        
        if (itemIndex==2) {
//            int payType =3;
//            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@(payType).stringValue,@"payType", nil];
            NSString * url = [NSString stringWithFormat:@"%@Order/icodeInfo",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:nil successBlock:^(id response) {
                if ([response[@"code"]integerValue]==1) {
                    if(response[@"data"]){
                        NSDictionary  * dic = response[@"data"];
                        if(dic){
                            pName = dic[@"pName"];
                            pPrice = dic[@"pPrice"];
                            pId = dic[@"pId"];
                            int price =[pPrice intValue];
                            float  a = (float)price/100;
                            newprice = [NSString stringWithFormat:@"¥%.2f",a];
                            [self aleart];
                        }
                    }
                }
            } failureBlock:^(NSError *error) {
             //   [BAAlertView showTitle:nil message:@"出现错误"];
            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        }
        
        
        
    }];

    
}

-(void)secureTextEntry:(UIButton *)sender
{
    self.phoneField.secureTextEntry = !self.passwordField.secureTextEntry;
    sender.selected = !sender.selected;
}
-(void)login{
   NSString *password = [CLMd5Tool MD5ForLower32Bate:_password];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_phone,@"account",password,@"password",codetext,@"iCode", nil];
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
//                                          [[DLTUserCenter userCenter] setUserPassword:password account:_phone];;
                                          LoginViewController * login = [[LoginViewController alloc]init];
                                          login.account = _phone;
                                          login.password = password;
                                          [self presentViewController:login animated:NO completion:nil];
                                        }
        
        
    } failureBlock:^(NSError *error) {
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    }
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.passwordField  == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 10) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:11];
            self.loginBtn.backgroundColor = [UIColor ColorWithHexString:@"0080f5"];
            self.loginBtn.userInteractionEnabled= YES;
            [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            codetext = textField.text;
            
            return NO;
        }else
        {
            self.loginBtn.backgroundColor = [UIColor ColorWithHexString:@"9c9c9c"];
            self.loginBtn.userInteractionEnabled= NO;
            [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
    }

    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)aleart
{
    TDAlertItem *item = [[TDAlertItem alloc] initWithTitle:@"立即支付"];
    item.titleColor = [UIColor blueColor];
    alert = [[TDAlertView alloc] initWithTitle:pName message:newprice items:@[item] delegate:self];
    [alert show];
}
-(void)aleart1
{
    TDAlertItem *item = [[TDAlertItem alloc] initWithTitle:@"立即支付"];
    item.titleColor = [UIColor blueColor];
    alert1 = [[TDAlertView alloc] initWithTitle:pName message:newprice items:@[item] delegate:self];
    [alert1 show];
}
-(void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex
{
    if (alertView==alert) {
        if (itemIndex==0) {
            int payType =3;
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@(payType).stringValue,@"payType", nil];
            NSString * url = [NSString stringWithFormat:@"%@Order/icodeOrder",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
                if ([response[@"code"]integerValue]==1) {
                    body = response[@"data"][@"body"];
                    //                    NSString * pid = [NSString stringWithFormat:@"%@",pId];
                    [[UPPaymentControl defaultControl] startPay:body fromScheme:@"Myt" mode:@"01" viewController:self];
                }
            } failureBlock:^(NSError *error) {
                
            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
            
        }
    }
    if (alertView==alert1) {
        if (itemIndex==0) {
            NSDictionary *dic = @{@"payType" : @"1",@"phone":_phone};
            NSString * url = [NSString stringWithFormat:@"%@Order/icodeOrder",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
                if ([response[@"code"]integerValue]==1) {
                    if(response[@"data"]){
                        NSDictionary * dic = response[@"data"];
                        if(dic){
                            body = dic[@"body"];
                            // 判断支付宝是否有安装
                            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]]) {
                                NSLog(@"请安装支付宝客户端....");
                                return;
                            }
                            [[AlipaySDK defaultService] payOrder:body fromScheme:@"alipaysdk" callback:^(NSDictionary *resultDic) {
                                NSLog(@"reslut = %@",resultDic);
                                NSInteger orderState=[resultDic[@"resultStatus"]integerValue];
                                if (orderState==9000) {
                                    [BAAlertView showTitle:@"购买成功" message:@"我们将以短信的形式发送到您的手机上,请注意查收!"];
                                    
                                }
                            }];
                        }
                    }
                }else
                {
                  //  [BAAlertView showTitle:nil message:@"出现错误"];
                }
            } failureBlock:^(NSError *error) {
                NSLog(@"这是error : %@",error);
               // [BAAlertView showTitle:nil message:@"出现错误"];
            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}


@end
