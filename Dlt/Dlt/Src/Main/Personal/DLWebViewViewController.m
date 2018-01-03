//
//  DLWebViewViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLWebViewViewController.h"

@interface DLWebViewViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;


@end

@implementation DLWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蚂蚁通下载";
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]]];
}

@end
