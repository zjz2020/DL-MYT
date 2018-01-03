//
//  DLAdverAgreementViewController.m
//  Dlt
//
//  Created by USER on 2017/10/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLAdverAgreementViewController.h"

@interface DLAdverAgreementViewController ()
@property (nonatomic , strong)UIWebView *webView;
@property(nonatomic,strong)UIButton * backBtn;
@end

@implementation DLAdverAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    // Do any additional setup after loading the view.
    [self addMianView];
    if (_isLogin) {
        [self.view addSubview:self.backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.mas_equalTo(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+2);
            make.width.height.mas_equalTo(24);
        }];

    }else if (_isApply){
         self.navigationItem.title = @"申请推广须知";
    }
    else{
         self.navigationItem.title = @"申请开户协议书";
    }
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
-(void)addMianView{
    _webView = [UIWebView new];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    [_webView setOpaque:NO];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    
    NSString *detailUrl;
    if (_isLogin) {
        detailUrl  = [NSString stringWithFormat:@"%@/Content/html/regiest_protocol.html",BASE_IMGURL];
    }else if (_isApply){
        detailUrl  = [NSString stringWithFormat:@"%@/Content/html/ApplyPromoter.html",BASE_IMGURL];
    }
    else{
        detailUrl  = [NSString stringWithFormat:@"%@/Content/html/ApplyAderProtocol.html",BASE_IMGURL];
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailUrl]]];
    [self.view addSubview:_webView];
    _webView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    if (_isLogin) {
        _webView.sd_layout.topSpaceToView(self.view, 60);
    }else{
        _webView.sd_layout.topSpaceToView(self.view, NAVIH);
    }
}
@end
