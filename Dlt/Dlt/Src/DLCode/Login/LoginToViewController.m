//
//  LoginToViewController.m
//  Dlt
//
//  Created by USER on 2017/6/6.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "LoginToViewController.h"

@interface LoginToViewController ()
@property(nonatomic,strong)UIImageView * centerImage;
@property(nonatomic,strong)UITextField * phoneField;
@property(nonatomic,strong)UITextField * passwordField;
@property(nonatomic,strong)UIButton * lookBtn;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,strong)UIButton * resBtn;
@property(nonatomic,strong)UIButton * forgetBtn;
@property(nonatomic,strong)UILabel * phoneline;
@property(nonatomic,strong)UILabel * passwordline;




@property(nonatomic,strong)UIButton *backBtn;

@end

@implementation LoginToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    // Do any additional setup after loading the view.
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
-(void)initUI
{
    [self.view addSubview:self.backBtn];
 
    [self.view addSubview:self.centerImage];
    [_centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(285/2);
        make.top.mas_equalTo(75);
        make.width.height.mas_equalTo (90);
    }];

}
-(UIImageView *)centerImage
{
    if (!_centerImage) {
        _centerImage = [[UIImageView alloc]init];
        _centerImage.image = [UIImage imageNamed:@"Login_00"];

    }
    return _centerImage;
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
