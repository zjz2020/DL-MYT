//
//  DLDetailTaskViewController.m
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLDetailTaskViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIImage+CompressImage.h"
#import "DLListViewController.h"
#import "DLListStatus.h"
#import <MJExtension/MJExtension.h>
#import "SDPhotoBrowser.h"
#import "PhotosContainerView.h"
@interface DLDetailTaskViewController ()<UIWebViewDelegate,SDPhotoBrowserDelegate>
@property (nonatomic , assign)BOOL isTextAndImage;
@property (nonatomic , strong)UIScrollView *mainView;
@property (nonatomic , strong)UILabel *balanceDown;
@property (nonatomic , strong)UIButton *operationBtn;
@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)PhotosContainerView *taskImage;
@property (nonatomic , strong)UIWebView *webView;
@property (nonatomic , strong)NSArray *listArray;
@property (nonatomic , strong)UILabel *stateLable;
@property (nonatomic , strong)NSMutableArray *imgSrcArray;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation DLDetailTaskViewController
#pragma clang diagnostic pop
-(NSMutableArray *)imgSrcArray{
    if (_imgSrcArray == nil) {
        _imgSrcArray = [NSMutableArray array];
    }return _imgSrcArray;
}
-(NSArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSArray array];
    }return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"任务详情";
    _mainView = [UIScrollView new];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .rightSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
      [self addHeardView];
}
-(void)addHeardView{
    UIView *heardView = [UIView new];
    UILabel *balanceTop = [UILabel new];
    balanceTop.text = @"广告余额";
    UIColor *backGroundColor = UICOLORRGB(232, 232, 232, 1.0);
    _balanceDown = [UILabel new];
    _balanceDown.text = [NSString stringWithFormat:@"%.2f",[_status.remainMonery integerValue]/100.0];
    _balanceDown.font = [UIFont systemFontOfSize:30];
    _operationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _stateLable= [UILabel new];
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.text = _status.pubTime;
    UIView *lineTop = [UIView new];
    lineTop.backgroundColor = backGroundColor;
    UILabel *listLabel = [UILabel new];
    listLabel.text = @"推手列表";
    listLabel.font = [UIFont systemFontOfSize:16];
    UIImageView *arrowImage = [UIImageView new];
    arrowImage.image = [UIImage imageNamed:@"wallet_01.png"];
    UIView *lineMid = [UILabel new];
    lineMid.backgroundColor = backGroundColor;
    UIView *iconView = [UIView new];
    [self setUpIcomView:iconView];
    UIView *lineDown = [UIView new];
    lineDown.backgroundColor = backGroundColor;
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [listBtn addTarget:self action:@selector(upListButton) forControlEvents:UIControlEventTouchUpInside];
    [heardView sd_addSubviews:@[balanceTop,_balanceDown,_operationBtn,_timeLabel,lineTop,listLabel,arrowImage,lineMid,iconView,lineDown,listBtn,_stateLable]];
    balanceTop.sd_layout
    .topSpaceToView(heardView, 25)
    .heightIs(20)
    .leftSpaceToView(heardView, 10);
    [balanceTop setSingleLineAutoResizeWithMaxWidth:200];
    _balanceDown.sd_layout
    .topSpaceToView(balanceTop, 15)
    .leftEqualToView(balanceTop)
    .heightIs(50);
    [_balanceDown setSingleLineAutoResizeWithMaxWidth:200];
    _stateLable.textColor = [UIColor grayColor];
    _stateLable.text = @"已下架";
    if ([_status.status isEqualToString:@"1"] && !_status.adStatus) {
        [_operationBtn setTitle:@"下架" forState:0];
        _operationBtn.layer.masksToBounds = YES;
        _operationBtn.layer.cornerRadius = 5;
        _operationBtn.layer.borderWidth = 1;
        _operationBtn.layer.borderColor = UICOLORRGB(145, 145, 145, 1.0).CGColor;
        [_operationBtn setTitleColor:[UIColor blackColor] forState:0];
        [_operationBtn addTarget:self action:@selector(upOperationButton) forControlEvents:UIControlEventTouchUpInside];
        _operationBtn.backgroundColor = backGroundColor;
        _operationBtn.sd_layout
        .topEqualToView(balanceTop)
        .rightSpaceToView(heardView, 15);
        [_operationBtn setupAutoSizeWithHorizontalPadding:20 buttonHeight:28];
        _stateLable.hidden = YES;
    }else if([_status.adStatus isEqualToString:@"1"]){
        _stateLable.hidden = NO;
        _stateLable.textColor = [UIColor redColor];
        _stateLable.text = @"进行中";
    }else{
        _stateLable.hidden = NO;
    }
    _stateLable.sd_layout
    .topEqualToView(balanceTop)
    .rightSpaceToView(heardView, 15)
    .heightIs(20);
    [_stateLable setSingleLineAutoResizeWithMaxWidth:200];
    _timeLabel.sd_layout
    .topSpaceToView(_operationBtn, 10)
    .rightEqualToView(_operationBtn)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    lineTop.sd_layout
    .topSpaceToView(heardView, 120)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0)
    .heightIs(10);
    listLabel.sd_layout
    .topSpaceToView(lineTop, 12)
    .heightIs(20)
    .leftEqualToView(balanceTop);
    [listLabel setSingleLineAutoResizeWithMaxWidth:200];
    arrowImage.sd_layout
    .centerYEqualToView(listLabel)
    .rightSpaceToView(heardView, 10)
    .heightIs(20)
    .widthIs(20);
    lineMid.sd_layout
    .topSpaceToView(listLabel, 12)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0)
    .heightIs(1);
    iconView.sd_layout
    .topSpaceToView(lineMid, 0)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0)
    .heightIs(60);
    listBtn.sd_layout
    .topSpaceToView(lineTop, 0)
    .rightSpaceToView(heardView, 0)
    .leftSpaceToView(heardView, 0)
    .bottomEqualToView(iconView);
    lineDown.sd_layout
    .topSpaceToView(iconView, 0)
    .leftSpaceToView(heardView, 0)
    .rightSpaceToView(heardView, 0)
    .heightIs(10);
    [heardView setupAutoHeightWithBottomView:lineDown bottomMargin:0];
    [_mainView addSubview:heardView];
    heardView.sd_layout
    .topSpaceToView(_mainView, 0)
    .leftSpaceToView(_mainView, 0)
    .rightSpaceToView(_mainView, 0);
    
//    if ([_status.type isEqualToString:@"2"]) {
//        [self addTextAndImageView:heardView];
//    }else{
    [DLAlert alertShowLoad];
        [self addLinkView:heardView];
   // }
}
//推手列表数据
-(void)setUpIcomView:(UIView *)iconView{
    NSString *adID;
    if (_status.adid) {
        adID= _status.adid;
    }else{
        adID = _status.ID;
    }
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/PromoterList",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"adid":adID,
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        self.listArray =[DLListStatus mj_objectArrayWithKeyValuesArray:[response valueForKey:@"data"]];
        [self addListView:iconView];
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"网络延迟稍后重试"];
    } progress:nil];

}
-(void)addListView:(UIView *)iconView{
    UIScrollView *listView = [UIScrollView new];
    [iconView addSubview:listView];
    CGFloat length = 30;
    CGFloat edge =0;
    CGFloat h =15;
   
    for (int i =0; i< self.listArray.count; i++) {
        UIImageView *icon =[UIImageView new];
        [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,[_listArray valueForKey:@"headImg"][i]]]];
        icon.frame =CGRectMake(edge+15, h, length, length);
        edge = icon.frame.size.width +icon.frame.origin.x;
        
        [listView addSubview:icon];
        
        if (i == self.listArray.count - 1) {
            [listView setupAutoContentSizeWithRightView:icon rightMargin:15];
        }
        
    }
    listView.sd_layout
    .topSpaceToView(iconView, 0)
    .rightSpaceToView(iconView, 0)
    .leftSpaceToView(iconView, 0)
    .bottomSpaceToView(iconView, 0);

}
// 图文详情
-(void)addTextAndImageView:(UIView *)heardView{
    UIView *detailView = [UIView new];
    _titleLabel = [UILabel new];
    NSArray *array = [_status.text componentsSeparatedByString:@"{{"];
    _titleLabel.text = array[0];
    _taskImage = [PhotosContainerView new];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < array.count; i++) {
         NSString *imgStr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,array[i]];
        imgStr =  [imgStr stringByReplacingOccurrencesOfString:@"}}" withString:@""];
        [imageArray addObject:imgStr];
    }
    __weak typeof(self)weakSelf = self;
     [detailView sd_addSubviews:@[_titleLabel,_taskImage]];
    _titleLabel.sd_layout
    .topSpaceToView(detailView, 20)
    .leftSpaceToView(detailView, 10)
    .rightSpaceToView(detailView, 10)
    .autoHeightRatio(0);
    
    _taskImage.urlPhotoArray  = imageArray  ;
    _taskImage.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftSpaceToView(detailView, 10)
    .rightSpaceToView(detailView, 10);
    [weakSelf.mainView layoutSubviews];

   [detailView setupAutoHeightWithBottomView:_taskImage bottomMargin:10];
    [_mainView addSubview:detailView];
    detailView.sd_layout
    .topSpaceToView(heardView, 0)
    .rightSpaceToView(_mainView, 0)
    .leftSpaceToView(_mainView, 0);
    [_mainView setupAutoContentSizeWithBottomView:detailView bottomMargin:10];
    

}
//链接详情
-(void)addLinkView:(UIView *)heardView{
    _webView = [UIWebView new];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:NO];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    _webView.scrollView.scrollEnabled = NO;
    NSString *detailUrl;
    if (_status.adid) {
      detailUrl  = [NSString stringWithFormat:@"%@/ad/addetail?adid=%@",BASE_IMGURL,_status.adid];
    }else{
       detailUrl = [NSString stringWithFormat:@"%@/ad/addetail?adid=%@",BASE_IMGURL,_status.ID];
    }
   
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailUrl]]];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_mainView addSubview:_webView];
    _webView.sd_layout
    .topSpaceToView(heardView, 0)
    .leftSpaceToView(_mainView, 0)
    .rightSpaceToView(_mainView, 0)
    .heightIs(100);
 [_mainView setupAutoContentSizeWithBottomView:_webView bottomMargin:10];
}
-(void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"contentSize"]){
        
        CGSize fittSize = [_webView sizeThatFits:CGSizeZero];
       
        _webView.sd_layout.heightIs(fittSize.height);
        [_mainView setupAutoContentSizeWithBottomView:_webView bottomMargin:10];
        
    }
}

//点击了下架按钮
-(void)upOperationButton{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认下架该广告？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self OperationYes];
        
    }];
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
   
    [alert addAction:action1];
    
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}
-(void)OperationYes{
    NSString *adID;
    if (_status.adid) {
        adID= _status.adid;
    }else{
        adID = _status.ID;
    }
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/UnloadAD",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"adid" :adID
                             };
    
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",[response valueForKey:@"code"]];
        if ([str isEqualToString:@"1"]) {
            [DLAlert alertWithText:@"下架成功"];
            _operationBtn.hidden = YES;
            _stateLable.hidden = NO;
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
         
            [center postNotificationName:@"RELOADTABLEVIEWDATA" object:nil];
            NSNotificationCenter *centerLBT = [NSNotificationCenter defaultCenter];
            [centerLBT postNotificationName:@"TIXIANSUCCESS" object:@"LBT"];
        }
        
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"网络延迟稍后重试"];
    } progress:nil];

}
//点击了推手列表
-(void)upListButton{
    DLListViewController *sdView = [DLListViewController new];
    if (_status.adid) {
        sdView.adID= _status.adid;
    }else{
        sdView.adID = _status.ID;
    }
    [self.navigationController pushViewController:sdView animated:YES];
}
-(void)webViewDidStartLoad:(UIWebView*)webView {
    [DLAlert alertHideLoad];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    //注入JS方法
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];
    //获取到了网页上所有的图片
    NSString *resurlt =  [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    if (resurlt.length) {
        NSArray *urlArr = [resurlt componentsSeparatedByString:@"+"];
        
        self.imgSrcArray = [NSMutableArray arrayWithArray:urlArr];
        if ([_imgSrcArray containsObject:@""]) {
            [_imgSrcArray removeObject:@""];
        }
        
    }
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
            path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
                //path 就是被点击图片的url
                SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
                
                //设置容器视图,父视图
                browser.sourceImagesContainerView = _webView;
                browser.currentImageIndex = [_imgSrcArray indexOfObject:path];
                browser.imageCount = _imgSrcArray.count;
                browser.noShowAnimal = YES;
                //设置代理
                browser.delegate = self;
                //显示图片浏览器
                [browser show];
        });
        return NO;
    }
    
    return YES;
}
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSURL *url= [NSURL URLWithString:_imgSrcArray[index]];
    return url;
}
@end
