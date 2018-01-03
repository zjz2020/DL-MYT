//
//  SingerViewController.m
//  Dlt
//
//  Created by USER on 2017/6/16.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SingerViewController.h"

@interface SingerViewController ()<UITextFieldDelegate>{
    NSString * _names;
}
@property(nonatomic,strong) UITextField *singerTextField;

@end

@implementation SingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   [self back:@"friends_15"];
    [self rightTitle:@"保存"];
  
    _singerTextField = [[UITextField alloc]initWithFrame:RectMake_LFL(10, 0, 0, 54)];
    _singerTextField.delegate = self;
    [_singerTextField addTarget:self action:@selector(dosinger:) forControlEvents:UIControlEventEditingChanged];
    _singerTextField.width_sd = WIDTH;
    _singerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _singerTextField.font = AdaptedFontSize(17);

    [self.view addSubview:_singerTextField];
    
    UILabel * label = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    label.width_sd= WIDTH;
    label.top_sd = _singerTextField.bottom_sd;
    label.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:label];
    self.tableView.tableHeaderView =  _singerTextField;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
  
  self.title = _titleStr;
}

-(void)backclick{
 [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightclicks{
  @weakify(self);
    if ([_titleStr isEqualToString:@"昵称"]) {
        if (!_names) {
            return[DLAlert alertWithText:@"您还未修改信息"];
        }else
        {
          
            DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
            NSDictionary *params = @{@"token":[DLTUserCenter userCenter].token,
                                   @"uid":user.uid,
                                   @"userName":_names};
          [[DLT_USER_CENTER setModifyUserInfo:params]
           subscribeNext:^(id  _Nullable x) {
             @strongify(self);
             [self updateUserSuccessful];
          } error:^(NSError * _Nullable error) {
             [DLAlert alertWithText:@"修改信息失败"];
          } completed:^{
            
          }];
        }
        
        
    }else if ([_titleStr isEqualToString:@"签名"])
    {
        if (!_names) {
            return[DLAlert alertWithText:@"您还未修改信息"];
        }else
        {
            DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
            NSDictionary *params = @{@"token":[DLTUserCenter userCenter].token,
                                   @"uid":user.uid,
                                   @"note":_names};
          [[DLT_USER_CENTER setModifyUserInfo:params]
           subscribeNext:^(id  _Nullable x) {
             @strongify(self);
             [self updateUserSuccessful];
           } error:^(NSError * _Nullable error) {
              [DLAlert alertWithText:@"修改信息失败"];
           } completed:^{
             
           }];
            
        }

    }
}

-(void)dosinger:(UITextField *)text
{
    _names = text.text;
  
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_titleStr isEqualToString:@"昵称"]) {
        NSString * tobe = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (_singerTextField == textField) {
            if ([tobe length]>10) {
             
                textField.text = [tobe substringToIndex:10];
                _names = textField.text;
                return NO;

            }
            
        }
    }
    return YES;
}


- (void)updateUserSuccessful{
  [DLAlert alertWithText:@"保存成功"];
  DLTUserProfile *userProfile = DLT_USER_CENTER.curUser.copy;
  
  if ([_titleStr isEqualToString:@"昵称"]){
      userProfile.userName = _names;
  }else{
     userProfile.note = _names;
  }

  [DLT_USER_CENTER setUserProfile:userProfile];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   [self.navigationController popViewControllerAnimated:YES];
  });
  

}

@end
