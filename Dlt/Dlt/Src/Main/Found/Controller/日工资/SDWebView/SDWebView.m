//
//  SDWebView.m
//  YTXEducation
//
//  Created by 薛林 on 17/2/25.
//  Copyright © 2017年 YunTianXia. All rights reserved.
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

#import "SDWebView.h"
#import <Foundation/Foundation.h>
#import "SDPhotoBrowser.h"
#import "DLThirdShare.h"
#import "DLMyExtionViewController.h"
#import "DLFirstBillViewController.h"
@interface SDWebView ()<SDPhotoBrowserDelegate>{
    BOOL _displayHTML;  //  显示页面元素
    BOOL _displayCookies;// 显示页面Cookies
    BOOL _displayURL;// 显示即将调转的URL
}

//  交互对象，使用它给页面注入JS代码，给页面图片添加点击事件
@property (nonatomic, strong) WKUserScript *userScript;
@property (nonatomic , strong)NSString *nowUrl;
@end


@implementation SDWebView {
    NSString *_imgSrc;//  预览图片的URL路径
}

//  MARK: - init
- (instancetype)initWithURLString:(NSString *)urlString {
    self = [super init];
    self.URLString = urlString;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setDefaultValue];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc] init];
    configer.userContentController = [[WKUserContentController alloc] init];
    configer.preferences = [[WKPreferences alloc] init];
    configer.preferences.javaScriptEnabled = YES;
    configer.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    configer.allowsInlineMediaPlayback = YES;
    [configer.userContentController addUserScript:self.userScript];
    [configer.userContentController addScriptMessageHandler:self name:@"AppModel"];
    [configer.userContentController addScriptMessageHandler:self name:@"DaywageRecord"];
    [configer.userContentController addScriptMessageHandler:self name:@"ApplyPromote"];
    [configer.userContentController addScriptMessageHandler:self name:@"CopyTextMOdel"];
    self = [super initWithFrame:frame configuration:configer];
    return self;
}

- (void)setURLString:(NSString *)URLString {
    _URLString = URLString;
    [self setDefaultValue];
}

- (void)setDefaultValue {
    _displayHTML = YES;
    _displayCookies = YES;
    _displayURL = YES;
    self.UIDelegate = self;
    self.navigationDelegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
}

//  MARK: - 加载本地URL
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName {
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self loadHTMLString:htmlCont baseURL:baseURL];
}


- (void)setJsHandlers:(NSArray<NSString *> *)jsHandlers {
    _jsHandlers = jsHandlers;
    [jsHandlers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.configuration.userContentController addScriptMessageHandler:self name:obj];
    }];
}

//  MARK: - js调用原生方法 可在此方法中获得传递回来的参数
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        DLThirdShare *thirdShare = [DLThirdShare thirdShareInstance];
        thirdShare.shareUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,[message.body   valueForKey:@"url"]];
        thirdShare.shareTitle = [NSString stringWithFormat:@"【蚂蚁通】 %@",[message.body valueForKey:@"title"]];
        NSString *imageImage =  [NSString stringWithFormat:@"%@%@",BASE_IMGURL,[message.body valueForKey:@"img"]];;
        thirdShare.shareImage = [self handleImageWithURLStr:imageImage];
        [thirdShare shareToWechat:ShareWechatType_Circle];
       
    }
  
    //申请推广
    if ([message.name isEqualToString:@"ApplyPromote"]) {
        
        DLMyExtionViewController *sdView = [DLMyExtionViewController new];
        sdView.isApply = YES;
        sdView.isAdvertiser = _mainView.isAdvertiser;

        [_mainView.navigationController pushViewController:sdView animated:YES];
    }
    //我的账单
    if ([message.name isEqualToString:@"DaywageRecord"]) {
        DLFirstBillViewController *sdView = [DLFirstBillViewController new];
        [_mainView.navigationController pushViewController:sdView animated:YES];
    }
    //拷贝文字
    if ([message.name isEqualToString:@"CopyTextMOdel"]) {
        NSString *isSucc = @"AAA";
        NSString *js = [NSString stringWithFormat:@"akertCopyTip('%@')",isSucc];
        [self evaluateJavaScript:js completionHandler:^(id _Nullable rulest, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"错误:%@", error.localizedDescription);
//            }else{
//                NSLog(@"成功了");
//            }
            
        }];
        UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
        appPasteBoard.persistent = YES;
        [appPasteBoard setString:[message.body valueForKey:@"text"] ];
        UIAlertView *alertview =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"完成复制",nil),nil] message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alertview show];

    }

    
}

- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//- (void)evaluateJavaScript:(NSString *)javaScriptString
//
//         completionHandler:(void (^)(id, NSError *))completionHandler{
//    NSLog(@"addfadfada");
//}
//if(self.webDelegate !=nil && [self.webDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]){
//    [self.webDelegate userContentController:userContentController didReceiveScriptMessage:message];
//}
//  MARK: - 检查cookie及页面HTML元素
//页面加载完成后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //获取图片数组
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        _imgSrcArray = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"+"]];
        
        if (_imgSrcArray.count >= 2) {
            [_imgSrcArray removeLastObject];
        }
        //[_imgSrcArray removeFirstObject];
    }];
    
        self.nowUrl = webView.URL.absoluteString;
    
    [webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {}];
    
    if (_displayCookies) {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookieJar cookies]) {
            //NSLog(@"%@", cookie);
        }
    }
    if (_displayHTML) {
        NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
        [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
            //NSLog(@"%@",HTMLsource);
        }];
    }
    if (![self.webDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        return;
    }
    if([self.webDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]){
        [self.webDelegate webView:webView didFinishNavigation:navigation];
    }
    
   
}

//  MARK: - 页面开始加载就调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.webDelegate != nil && [self.webDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.webDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}
-(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}


//  MARK: - 导航每次跳转调用跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
//    NSURLRequest * request =navigationAction.request;
//
//    NSDictionary *requestHeaders = request.allHTTPHeaderFields;
//    
//    if (requestHeaders[@"token"] && requestHeaders[@"uid"] && requestHeaders[@"cityCode"]) {

        [self dlWebView:webView dlAction:navigationAction decisionHandler:decisionHandler];

    
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
//    } else {
//        
//        NSDictionary *params = @{
//                                 @"token" : [DLTUserCenter userCenter].token,
//                                 @"uid" : [DLTUserCenter userCenter].curUser.uid,
//                                 @"cityCode":_mainView.cityCode
//                                 };
//        
//        NSString *dataStr = [self convertToJsonData:params];
//        NSURL * url = [NSURL URLWithString:[navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding]];
//        
//        
//        
//        NSString * js = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",POST_JS,url,dataStr];
//        
//        [webView evaluateJavaScript:js completionHandler:nil];
//
//         [self dlWebView:webView dlAction:navigationAction decisionHandler:decisionHandler];
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
}
-(void)dlWebView:(WKWebView *)webView dlAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([url containsString:@"alipay://"]) {
        NSInteger subIndex = 23;
        NSString* dataStr=[url substringFromIndex:subIndex];
        //编码
        NSString *encodeString = [self encodeString:dataStr];
        NSMutableString* mString=[[NSMutableString alloc] init];
        [mString appendString:[url substringToIndex:subIndex]];
        [mString appendString:encodeString];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mString]];
        
    }

    //预览图片
    if ([navigationAction.request.URL.scheme isEqualToString:@"image-preview"]&&[_nowUrl containsString:@"/Ad/Addetail?adid="]) {
        NSString* path = [navigationAction.request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _imgSrc = path;
        NSString *BtnUrl = [NSString stringWithFormat:@"%@/Content/images/salary2_02@2x.png",BASE_IMGURL];
   
        if (![_imgSrcArray[0]isEqualToString:BtnUrl]) {
            //path 就是被点击图片的url
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
            
            //设置容器视图,父视图
            browser.sourceImagesContainerView = _mainView.view;
            browser.currentImageIndex = [_imgSrcArray indexOfObject:path];
            browser.imageCount = _imgSrcArray.count;
            browser.noShowAnimal = YES;
            //设置代理
            browser.delegate = self;
            
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(SDPhotoBroserShow:) object:browser];
            [self performSelector:@selector(SDPhotoBroserShow:) withObject:browser afterDelay:0.4f];
        }
        
    }
    if (_displayURL) {
        NSLog(@"-----------%@",navigationAction.request.URL.absoluteString);
        if (self.webDelegate != nil && [self.webDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
            [self.webDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        }
    }

}
-(void)SDPhotoBroserShow:(SDPhotoBrowser *)browser{
    //显示图片浏览器
    [browser show];
}
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    
    NSURL *url= [NSURL URLWithString:_imgSrcArray[index]];
    return url;
    
}
#pragma mark - 移除jsHandler
- (void)removejsHandlers {
    NSAssert(_jsHandlers, @"未找到jsHandler!无需移除");
    if (_jsHandlers) {
        for (NSString *handlerName in _jsHandlers) {
            [self.configuration.userContentController removeScriptMessageHandlerForName:handlerName];
        }
    }
}

//  MARK: - 进度条
- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self addSubview:_progressView];
    }
    return _progressView;
}
//  MARK: - 清除cookie
- (void)removeCookies {
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records) {
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                    }];
                         }
                     }];
}

- (void)removeCookieWithHostName:(NSString *)hostName {
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records) {
                             if ( [record.displayName containsString:hostName]) {
                                 [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:record.dataTypes
                                                                          forDataRecords:@[record]
                                                                       completionHandler:^{
                                                                            NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                          }];
                             }
                         }
                     }];
}

//  MARK: - 调用js方法
- (void)callJavaScript:(NSString *)jsMethodName {
    [self callJavaScript:jsMethodName handler:nil];
}

- (void)callJavaScript:(NSString *)jsMethodName handler:(void (^)(id _Nullable))handler {
    
    NSLog(@"call js:%@",jsMethodName);
    [self evaluateJavaScript:jsMethodName completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (handler) {
            handler(response);
        }
    }];
}

- (void)dealloc {
    //  这里清除或者不清除cookies 按照业务要求
//    [self removeCookies];
}



//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
//    UIImage *img = [UIImage createImageWithColor:[UIColor colorWithHexString:ThemeColor alpha:0.5]];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    imgView.frame = CGRectMake(0, 0, ScreenWidth, 200);
//    imgView.center = self.center;
//    return imgView.image;
//}



- (WKUserScript *)userScript {
    if (!_userScript) {
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        imgScr = imgScr + objs[i].src + '+';\
        };\
        return imgScr;\
        };function registerImageClickAction(){\
        var imgs=document.getElementsByTagName('img');\
        var length=imgs.length;\
        for(var i=0;i<length;i++){\
        img=imgs[i];\
        img.onclick=function(){\
        window.location.href='image-preview:'+this.src}\
        }\
        }";
        _userScript = [[WKUserScript alloc] initWithSource:jsGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    }
    return _userScript;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [_mainView presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [_mainView presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    
    [_mainView presentViewController:alertController animated:YES completion:nil];
    
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
