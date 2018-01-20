//
//  ProtocalViewController.m
//  Dlt
//
//  Created by USER on 2017/7/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ProtocalViewController.h"


@interface ProtocalViewController ()

@end

@implementation ProtocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蚂蚁通钱包协议";
    
    // 1.创建webview，并设置大小，"20"为状态栏高度
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *urlStr = [NSString stringWithFormat:@"%@/Content/html/dlt_wallet_legal.html", BASE_IMGURL];
    if (self.protol) {
        urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,self.protol];
        self.title = @"蚂蚁条款";
    }
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    // 3.加载网页
    [webView loadRequest:request];
    
    // 最后将webView添加到界面
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
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
