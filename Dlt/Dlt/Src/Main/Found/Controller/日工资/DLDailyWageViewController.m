//
//  DLDailyWageViewController.m
//  Dlt
//
//  Created by USER on 2017/11/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLDailyWageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface DLDailyWageViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>


@property (nonatomic ,strong)NJKWebViewProgressView *webViewProgressView;
@property (nonatomic ,strong)NJKWebViewProgress *webViewProgress;
@property (nonatomic , strong)UIWebView *webView;
@end

@implementation DLDailyWageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //self.navigationItem.hidesBackButton = YES;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    
    btn.adjustsImageWhenHighlighted = NO;
    
    [btn  setTitle:@"返回" forState:0];
    [btn setTintColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(leftTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -12;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    self.navigationItem.title = @"日工资";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _webView = [UIWebView new];
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    //判断是否沙盒中是否有这个值
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        //获取cookies：程序起来之后，uiwebview加载url之前获取保存好的cookies，并设置cookies，
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
    }

    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];

    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
    NSString *postStr = [NSString stringWithFormat:@"uid=%@&token=%@&cityCode=%@",[DLTUserCenter userCenter].curUser.uid,[DLTUserCenter userCenter].token,_cityCode];
    postStr = [postStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
   
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    [_webView setOpaque:NO];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    NSString *str;
    if (_dailWageUrl) {
        str = _dailWageUrl;
    }else{
       str  = [NSString stringWithFormat:@"%@/daywage",BASE_IMGURL];
    }
    
    NSURL * url = [NSURL URLWithString:str];
    NSMutableURLRequest * re = [[NSMutableURLRequest alloc]initWithURL:url];
    [re setHTTPMethod:@"POST"];
    NSData * postData1 = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [re setHTTPBody:postData1];
   
 
    [_webView loadRequest:re];

    [self.view addSubview:_webView];
    _webView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .topSpaceToView(self.view, NAVIH);
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

    NSHTTPCookie *cookie;
    for (id c in nCookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            if ([cookie.name isEqualToString:@"BAIDUID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
                break;
            }
        }
    }
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    
    if (_dailWageUrl  && ![_dailWageUrl isEqualToString:request.URL.absoluteString]) {
        DLDailyWageViewController *sdView = [DLDailyWageViewController new];
        sdView.cityCode = _cityCode;
        sdView.dailWageUrl = request.URL.absoluteString;
        [self.navigationController pushViewController:sdView animated:YES];
        return NO;

    }else{
        
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        
        NSDictionary *requestHeaders = request.allHTTPHeaderFields;
        
        if (requestHeaders[@"token"] && requestHeaders[@"uid"] && requestHeaders[@"cityCode"]) {
            _dailWageUrl = @"a";
            return YES;
        } else {
            NSString *token = [DLTUserCenter userCenter].token;
            token = [token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
            [mutableRequest setValue:token forHTTPHeaderField:@"token"];
            
            [mutableRequest setValue:[DLTUserCenter userCenter].curUser.uid forHTTPHeaderField:@"uid"];
            [mutableRequest setValue:_cityCode forHTTPHeaderField:@"cityCode"];
            
            request = [mutableRequest copy];
            
            [webView loadRequest:request];
            
            return NO;
        }

        
    }
    
}
-(void)leftTouchUpInside{
  
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
