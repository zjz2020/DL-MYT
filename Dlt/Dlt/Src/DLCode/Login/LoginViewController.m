//
//  LoginViewController.m
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
#import <RongIMKit/RongIMKit.h>
#import "KeyChainManager.h"
#import "RCDataBaseManager.h"
#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "UesrSqlite.h"
#import "MainTabbarViewController.h"
#import "BaseNC.h"
#import "RetrievepasswordViewController.h"
#import "RegisterPersonDataViewController.h"
#import "RCHttpTools.h"
#import "SAMKeychain+Extension.h"
#import "ZWBucket.h"
#import "AppDelegate.h"
#import "DLAdverAgreementViewController.h"
#import "XWCountryCodeController.h"
#import <RongIMKit/RongIMKit.h>
@interface LoginViewController ()<UITextFieldDelegate,RCIMUserInfoDataSource,XWCountryCodeControllerDelegate,RCIMGroupInfoDataSource>
{
    NSString * newpassword;
}
@property(nonatomic,strong)UIImageView * centerImage;
@property(nonatomic,strong)UIButton * regionBtn;
@property(nonatomic,strong)UITextField * phoneField;
@property(nonatomic,strong)UITextField * passwordField;
@property(nonatomic,strong)UIButton * lookBtn;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,strong)UIButton * resBtn;
@property(nonatomic,strong)UIButton * forgetBtn;
@property(nonatomic,strong)UILabel * phoneline;
@property(nonatomic,strong)UILabel * passwordline;

@property (nonatomic , strong)UIButton *chooseBtn;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    UIImage *Image = [[UIImage imageNamed:@"bc_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"agrementYES"]) {
        Image = [[UIImage imageNamed:@"bc_03.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [_chooseBtn setImage:Image forState:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self setup];
    
    NSString *accout = [[NSUserDefaults standardUserDefaults] objectForKey:MYUserAccount];
    self.phoneField.text = accout;
   
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
    [self.view addSubview:self.resBtn];
    [self.view addSubview:self.forgetBtn];

    [self.view addSubview:self.lookBtn];
    
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
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordline.mas_bottom).offset(35);
        make.left.mas_equalTo(_passwordField);
        make.width.mas_equalTo(_passwordField);
        make.height.mas_equalTo(45);
    }];
    
    [_resBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(17*6);
        make.height.mas_equalTo(17);
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(WIDTH-122);
        make.width.mas_equalTo(17*6);
        make.height.mas_equalTo(17);
    }];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneline.mas_bottom).offset(15);
        make.left.mas_equalTo(WIDTH-60);
        make.width.height.mas_equalTo(24);
    }];
  
//  [self test];
    [self addAgreementView];
    if(![KeyChainManager readUUID]){
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChainManager saveUUID:idfv];
    }
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
        Image = [[UIImage imageNamed:@"bc_03.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
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
        make.left.mas_equalTo(0);
        make.top.equalTo(_resBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(WIDTH);
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
- (void)test{
  @weakify(self);
  [[_phoneField rac_textSignal] subscribeNext:^(NSString *text) {
     @strongify(self);
    if ([text isEqualToString:@"158"]) [self updatePhone:@"15801064928"];
    if ([text isEqualToString:@"07"]) [self updatePhone:@"18770070853"];
    if ([text isEqualToString:@"08"]) [self updatePhone:@"18770080853"];
    if ([text isEqualToString:@"09"]) [self updatePhone:@"18770090853"];
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

- (void)updatePhone:(NSString *)phone{  // ArExplorer
  self->_phoneField.text = phone;
  self->_passwordField.text = @"123456";
  [self login:_loginBtn];
  [_phoneField resignFirstResponder];
}


#pragma mark =====nil
-(UIImageView *)centerImage
{
    if (!_centerImage) {
        _centerImage = [[UIImageView alloc]init];
        
        _centerImage.image = [UIImage imageNamed:@"Login_00"];
    }
    return _centerImage;
}
-(UITextField *)phoneField
{
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc]init];
        _phoneField.delegate = self;
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
        _phoneline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _phoneline;
}
-(UITextField *)passwordField
{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc]init];
        _passwordField.delegate = self;
        _passwordField.placeholder = @" / 请输入您的密码";
        _passwordField.font = AdaptedFontSize(17);
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 24, 24)];
        phoneimage.image = [UIImage imageNamed:@"Login_03"];
        _passwordField.leftView = phoneimage;
        _passwordField.leftViewMode = UITextFieldViewModeAlways;
        [_passwordField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _passwordField.secureTextEntry = YES;
    }
    return _passwordField;
}
-(UILabel *)passwordline
{
    if (_passwordline == nil) {
        _passwordline = [[UILabel alloc]init];
        _passwordline.backgroundColor = [UIColor colorWithHexString:LINE];
    }
    return _passwordline;
}
-(UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = AdaptedFontSize(17);
          _loginBtn.backgroundColor = [UIColor colorWithHexString:@"9c9c9c"];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.userInteractionEnabled = NO;
    }
    return _loginBtn;
}

-(UIButton *)resBtn
{
    if (_resBtn == nil) {
        _resBtn = [[UIButton alloc]init];
        _resBtn.titleLabel.font = AdaptedFontSize(17);
//        _resBtn.top_sd = self.loginBtn.bottom_sd + 20;
        [_resBtn setTitle:@"立即注册" forState:UIControlStateNormal];
//         [_resBtn setTitle:localizable(@"abc") forState:UIControlStateNormal];
        [_resBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_resBtn addTarget:self action:@selector(res) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resBtn;
}

-(UIButton *)forgetBtn
{
    if (_forgetBtn == nil) {
        _forgetBtn = [[UIButton alloc]init];
//        _forgetBtn.top_sd = self.loginBtn.bottom_sd + 20;
//        _forgetBtn.left_sd = WIDTH-17*6-20;
        _forgetBtn.titleLabel.font = AdaptedFontSize(17);
        [_forgetBtn setTitle:@"找回密码" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}
-(UIButton *)lookBtn
{
    if (_lookBtn == nil) {
        _lookBtn = [[UIButton alloc]init];
//        _lookBtn.top_sd = self.phoneline.bottom_sd +16;
//        _lookBtn.left_sd = WIDTH-58;
        [_lookBtn setImage:[UIImage imageNamed:@"Login_04"] forState:UIControlStateNormal];
        [_lookBtn setImage:[UIImage imageNamed:@"Login_05"] forState:UIControlStateSelected];
        [_lookBtn addTarget:self action:@selector(secureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}
#pragma mark ==== Click
-(void)login:(UIButton *)sender{
    
    [DLAlert alertShowLoad];
    [self.passwordField resignFirstResponder];
    [self.phoneField resignFirstResponder];
  if (_phoneField.text.length == 0 || _passwordField.text.length == 0) {
    return;
  }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"agrementYES"]) {
        [DLAlert alertWithText:@"请阅读并同意用户协议"];
        return;
    }
    NSString *accountStr;
    if ([[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1] isEqualToString:@"86"]) {
        accountStr =self.phoneField.text;
    }else{
        accountStr= [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
        
    } //再次存储账号
    [[NSUserDefaults standardUserDefaults] setObject:accountStr forKey:MYUserAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
   NSString *password = [CLMd5Tool MD5ForLower32Bate:_passwordField.text];
    @weakify(self);
    [[[DLTUserCenter userCenter] login:accountStr
                              password:password]
     subscribeNext:^(id response) {
         @strongify(self);
         int code = [response[@"code"] intValue];
     
         [DLAlert alertHideLoad];
        if (code == 1){ // 登录成功
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                NSString *tokneStr = response[@"data"][@"token"];
                ZWBucket.userDefault.set(DLTUserTokenKey,tokneStr);
                
                 [[RCIM sharedRCIM] setUserInfoDataSource:self];
                 [[RCIM sharedRCIM] setGroupInfoDataSource:self];
                
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
         
      
              [DLAlert alertWithText:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        
     }
     
     completed:^{
         
     }];
    
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    
    [[RCHttpTools shareInstance] getUserInfoByUserId:userId handle:^(RCUserInfo *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(userInfo);
        });
    }];
}
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion {
    [[RCHttpTools shareInstance] getGroupInfoByGroupId:groupId handle:^(RCGroup *groupInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(groupInfo);
        });
    }];
}

- (void)presentRegisterPersonDataViewController:(NSString *)token withUid:(NSString *)userId{
  RegisterPersonDataViewController * persondata = [[RegisterPersonDataViewController alloc]init];
  persondata.token = token;
  persondata.uid = userId;
    NSString *accountStr;
    if ([[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1] isEqualToString:@"86"]) {
        accountStr =self.phoneField.text;
    }else{
        accountStr= [NSString stringWithFormat:@"+%@%@",[_regionBtn.titleLabel.text componentsSeparatedByString:@"+"][1],self.phoneField.text];
        
    }
  persondata.account = accountStr;
    persondata.pwd = _passwordField.text;
  [self presentViewController:persondata animated:YES completion:nil];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
-(void)res
{
    RegisteredViewController * res = [[RegisteredViewController alloc]init];
    [self presentViewController:res animated:nil completion:nil];
}
-(void)forget
{
    RetrievepasswordViewController * retrivepassword = [[RetrievepasswordViewController alloc]init];
    [self presentViewController:retrivepassword animated:nil completion:nil];
}
#pragma clang diagnostic pop
-(void)secureTextEntry:(UIButton *)sender
{
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
    sender.selected = !sender.selected;
}
#pragma mark === textFiledDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.phoneField == textField) {
        if ([toBeString length]>10) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField

{
    NSLog(@"textfield text %@",textField.text);
    if (textField.text.length >5) {
        newpassword = textField.text;
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"0080f5"];
        self.loginBtn.userInteractionEnabled= YES;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else
    {
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"9c9c9c"];
        self.loginBtn.userInteractionEnabled= NO;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
