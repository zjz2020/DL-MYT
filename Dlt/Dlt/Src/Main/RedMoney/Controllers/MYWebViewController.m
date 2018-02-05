//
//  MYWebViewController.m
//  Dlt
//
//  Created by Fang on 2018/1/17.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MYWebViewController.h"

@interface MYWebViewController ()
@property(nonatomic,strong)UIWebView *webview;
@end

@implementation MYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蚂蚁搜搜";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addrightitem];
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webview];
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.antWeb]]];
    // Do any additional setup after loading the view.
}
-(void)addrightitem {
    UIButton * leftbtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0,40, 40)];
    [leftbtn setImage:[UIImage imageNamed:@"mayi_22"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(clickeRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.rightBarButtonItem = leftItem;
}
- (void)clickeRightBtn{
    [_webview reload];
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
