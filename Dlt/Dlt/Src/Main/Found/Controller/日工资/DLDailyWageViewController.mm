//
//  DLDailyWageViewController.m
//  Dlt
//
//  Created by USER on 2017/11/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#define POST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"


#import "DLDailyWageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SDWebView.h"
@interface DLDailyWageViewController ()


@property (strong, nonatomic) CALayer *progresslayer;
@property (nonatomic , strong)SDWebView *webView;

@end

@implementation DLDailyWageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpIsPromoterData];
    //self.navigationItem.hidesBackButton = YES;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    
    btn.adjustsImageWhenHighlighted = NO;
    
    [btn  setTitle:@"返回" forState:0];
    [btn setTintColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(leftTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -12;
    
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
   
   

    _webView = [[SDWebView alloc]initWithFrame:CGRectMake(0, NAVIH, WIDTH, HEIGHT- NAVIH-40-SafeAreaBottomHeight)];
    NSString *str;
    _webView.mainView = self;
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    if (_URLSTR) {
        str = [NSString stringWithFormat:@"%@/%@",BASE_IMGURL,_URLSTR];
    }else{
        str  = [NSString stringWithFormat:@"%@/daywage",BASE_IMGURL];}
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"cityCode":_cityCode
                             };

    NSString *dataStr = [self convertToJsonData:params];
    NSURL * url = [NSURL URLWithString:str];
  
 
  
    NSString * js = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",POST_JS,url,dataStr];
  
    [_webView evaluateJavaScript:js completionHandler:nil];
    
    [self.view addSubview:_webView];
    
}
//是否广告主
-(void)httpIsPromoterData{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    
    NSString *advUrl;
    
        advUrl = [NSString stringWithFormat:@"%@promote/IsAder",BASE_URL];
    
    
    [BANetManager ba_request_POSTWithUrlString:advUrl parameters:params successBlock:^(id response) {
        
        NSString *STR = [NSString stringWithFormat:@"%@",[response valueForKey:@"data"][@"isAder"]];
        if ([STR isEqualToString:@"0"]) {
            _isAdvertiser = NO;
            
        }else{
            _isAdvertiser = YES;
            
        }
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[SDWebView class]]) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.webView.progressView.hidden = YES;
                [self.webView.progressView setProgress:0 animated:NO];
            }else {
                self.webView.progressView.hidden = NO;
                [self.webView.progressView setProgress:newprogress animated:YES];
            }
        }
        if ([keyPath isEqualToString:@"title"]) {
            if (self.webView.title.length > 13) {
                self.navigationItem.title = [self.webView.title substringToIndex:14];
            } else {
                self.navigationItem.title = self.webView.title;
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}






-(void)leftTouchUpInside{
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [_webView removeCookies];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
@end
