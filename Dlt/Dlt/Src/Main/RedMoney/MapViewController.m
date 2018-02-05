//
//  MapViewController.m
//  Dlt
//
//  Created by Fang on 2018/1/15.
//  Copyright © 2018年 mr_chen. All rights reserved.
//   蚂蚁地图红包

#import "MapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "MAPointAnnotation+Type.h"
#import "DataModel.h"
#import "BANetManager.h"
#import "MaYiOpenView.h"
#import "DLWalletPayModel.h"
#import "DLPasswordInputView.h"
#import "RCHttpTools.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZCAFNHelp.h"
#import "RedPacket.h"
#import "MaYiRedPacketView.h"
#import "MaYiRedPacketDetailController.h"
#import "MaYiPersonalCardView.h"
#import "MaYiOpenPayView.h"
#import "MYSearchView.h"
#import "MYWebViewController.h"
#import "UIImage+Scale.h"
#import "WSRewardConfig.h"
#import "WSRedPacketView.h"
#import "OpenRdeVC.h"
#import "MYGetRedPageVC.h"
#define OpenAntUrl                  @"mayi/start_mayi"//开启蚂蚁
#define GetNearbyAnt                @"mayi/georadius_user"//获取周边的蚂蚁
#define SeachIsAnt                  @"mayi/is_mayi_user"//查询是否是蚂蚁用户
#define SetAntInfoIsOpen            @"mayi/set_mayi_info_state"//设置蚂蚁用户信息是否开放
#define AntInfoState                @"mayi/mayi_user_state"//蚂蚁用户开放状态
//#define ReceiveAntMoney             @"mayi/get_mayi_rp"//领取蚂蚁红包

#define userShowInfo                @"usercenter/otherUserInfo"//获取用户的展示数据
#define antSearchUrlStr                   @"temp/mayi_search_url"//蚂蚁搜索

#define baiduLatitude   @"http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location="
#define baiduLontude    @"&output=json&pois=1&ak=RleBOaL1HWYYRpyKFwzleMsGT0I6yOGX"
#define antSearch       @"www.mayiton.com"
@interface MapViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate,
                            MaYiOpenViewDelegate,DLPasswordInputViewDelegate,
                            MaYiRedPacketViewDelegate,MaYiOpenPayViewDelegate,MYSearchViewDelegate>
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)MaYiOpenView *openView;
//@property(nonatomic,strong)NSMutableArray   *dataArray;
//@property(nonatomic,strong)NSMutableArray  *dataArray2;
@property(nonatomic,strong)NSArray<MAPointAnnotation *> *AnnotationArray;
@property(nonatomic,strong)NSArray<MAPointAnnotation *> *AnnotationRedArray;
//是否显示展示信息
@property(nonatomic,assign,getter=showInfo) BOOL orShowInfo;
@property(nonatomic,assign)BOOL orShowData2;
//支付模型
@property (nonatomic, strong) DLWalletPayModel *paymodel;
//余额所剩余的钱
@property (nonatomic, strong) NSString *currentBalance;
//是否获取蚂蚁列表
@property(nonatomic, assign,getter=antList) BOOL isAntList;
//信息开关
@property(nonatomic, strong)UIButton *showInfoBtn;
//附近的人
@property(nonatomic, strong)NSMutableArray *nearPeople;
//附近的红包
@property(nonatomic, strong)NSMutableArray *nearRedPacket;
//payview
@property(nonatomic,strong)MaYiOpenPayView *payView;
@property (nonatomic, copy) NSString *headImageStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, strong)MYSearchView *seachV;
@end

@implementation MapViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self stopLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatLocationManager];
    [self makeUIScreen];
    [self judeToOpenMap];
    //判断是否是蚂蚁用户
    [self judementIsAntUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requstNumWithNotification:) name:VersionNotificationC object:nil];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if ([currentVersion isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:RequsetVerion]]) {
        if (self.openView) {
            [self.openView removeFromSuperview];
        }
        if (self.payView) {
            [self.payView removeFromSuperview];
        }
    }
    // Do any additional setup after loading the view.
}
//版本号通知
- (void)requstNumWithNotification:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if ([currentVersion isEqualToString:[dic stringValueForKey:@"version"]]) {
        if (self.openView) {
            [self.openView removeFromSuperview];
        }
        if (self.payView) {
            [self.payView removeFromSuperview];
        }
        
    }
}
//判断是否一元开启
- (void)judeToOpenMap{
    self.openView = [[MaYiOpenView alloc] initWithFrame:self.view.bounds];
    _openView.delegate = self;
    if ([self orShowRedPage]) {
        [self.view addSubview:_openView];
    }
}

- (void)makeUIScreen{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:14];
    [self.mapView
     performSelector:@selector(setShowsWorldMap:) withObject:@YES];//打开海外版定位
    [self.view addSubview:_mapView];
    CGFloat seachY = 20;
    if ([self isIphoneX]) {
        seachY = 40;
    }
    MYSearchView *seachV = [MYSearchView searchViewWithFram:CGRectMake(10, seachY, kScreenWidth - 20, kNewScreenHScale *47)];
    CGFloat SPace = 10;
    seachV.delegate = self;
    [self.mapView addSubview:seachV];
    self.seachV = seachV;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat closeY = [UIScreen mainScreen].bounds.size.height - 2 *SPace - 40- 44;
    if ([self isIphoneX]) {
        closeY = [UIScreen mainScreen].bounds.size.height - 2 *SPace - 40- 44 - 30;
    }
    closeBtn.frame = CGRectMake(SPace, closeY, 80, 40);
    closeBtn.selected = [self userInfoOrOpen];//yes 关闭
    [closeBtn addTarget:self action:@selector(clickeCloseShowViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"mayi_14"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"mayi_12"] forState:UIControlStateSelected];
    self.showInfoBtn = closeBtn;
    UIButton *addresBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addresBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - SPace - 40, closeBtn.frame.origin.y, 40, 40);
    [addresBtn setImage:[UIImage imageNamed:@"mayi_23"] forState:UIControlStateNormal];
    [addresBtn addTarget:self action:@selector(clickeAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (![self orShowRedPage]) {
        closeBtn.hidden = YES;
    }
    [_mapView addSubview:closeBtn];
    [_mapView addSubview:addresBtn];
    [_mapView setShowsCompass:NO];
    [_mapView setShowsScale:NO];
    [self getAntSearchUrl];
}

#pragma mark   展示地图上的点--------点点   MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    NSLog(@"%f",mapView.zoomLevel);
    if (mapView.zoomLevel < 12) {//隐藏红包
        [self.mapView removeAnnotations:self.AnnotationRedArray];
    } else {//展示红包
        [self.mapView addAnnotations:self.AnnotationRedArray];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    // 自定义userLocation对应的annotationView
    NSLog(@"viewForAnnotation  %@",[annotation class]);
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
            NSLog(@"%@",NSStringFromCGRect(annotationView.frame));
        }
        DLTUserProfile * user = DLT_USER_CENTER.curUser;
        NSString *imagestr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,user.userHeadImg];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imagestr] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                annotationView.image = [image scaleToSize:image size:CGSizeMake(30, 30)];
            });
        }];
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        aView.backgroundColor = [UIColor redColor];
        annotationView.leftCalloutAccessoryView = aView;
        //        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAPointAnnotation *pointA = (MAPointAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        switch (pointA.annotType) {
                case AntTypeSelf:{
//                    annotationView.image = [UIImage imageNamed:@"mayi_15"];
                }
                break;
                case AntTypeOther:{
                     NSString *imagestr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,pointA.rpUserIcon];
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imagestr] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            annotationView.image = [image scaleToSize:image size:CGSizeMake(30, 30)];
                        });
                    }];
                    annotationView.image = [UIImage imageNamed:@"mayi_10"];
                    
                }
                break;
                case AntTypeMoney:{
                    annotationView.image = [UIImage imageNamed:@"mayi_11"];
                    NSLog(@"%@",NSStringFromCGPoint(annotationView.centerOffset));
                }
                break;
            default:
                break;
        }
        
        //        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
//    NSLog(@"获取位置坐标%f  %f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAPointAnnotation *pointAnnotation = (MAPointAnnotation *)view.annotation;
        if (pointAnnotation.annotType == AntTypeSelf  && self.showInfo) {
            
            MaYiPersonalCardView *personView = [[MaYiPersonalCardView alloc] initWithFrame:self.view.bounds];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:personView];
            
        }else if (pointAnnotation.annotType == AntTypeOther){
             [self getUserInfoShowWithUid:pointAnnotation.pid];
        }else if(pointAnnotation.annotType == AntTypeMoney) {//红包
            //开始抢红包
            [self.mapView removeAnnotation:pointAnnotation];
            _headImageStr = pointAnnotation.rpUserIcon;
            _nameStr = pointAnnotation.rpUserName;
             [self openRedPacketActionSucess:YES headImage:pointAnnotation.rpUserIcon redName:pointAnnotation.rpUserName rid:pointAnnotation.rid];
//            [self antGetRedMoneyWithMoneyid:pointAnnotation.rid userName:pointAnnotation.rpUserName userImageStr:pointAnnotation.rpUserIcon];
        }
    } else if ([view.annotation isKindOfClass:[MAUserLocation class]]){
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        [self getUserInfoShowWithUid:user.uid];
    }
    [mapView deselectAnnotation:view.annotation animated:YES];//非选中状态
}

//进行附近的人添加到地图
- (void)addNearSourceToMap{
    [self.mapView removeAnnotations:_AnnotationArray];
    [self.mapView removeAnnotations:_AnnotationRedArray];
    NSMutableArray *testArray = [NSMutableArray new];
    for (int i = 0; i < self.nearRedPacket.count; i ++){
        RedPacket *mode = self.nearRedPacket[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.annotType = AnnotationTypeMoney;
        pointAnnotation.rid = [NSString stringWithFormat:@"%zd",mode.rpid];
        pointAnnotation.rpUserIcon = mode.rpUserIcon;
        pointAnnotation.rpUserName = mode.rpUserName;
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([mode.lat floatValue], [mode.lon floatValue]);
        [testArray addObject:pointAnnotation];
    }
    self.AnnotationRedArray = [self orShowRedPage]?[testArray mutableCopy]:@[];
    [testArray removeAllObjects];
    for (int i = 0; i < self.nearPeople.count; i ++){
        RedPacket *mode = self.nearPeople[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.annotType = AnnotationTypeOther;
        pointAnnotation.pid = [NSString stringWithFormat:@"%zd",mode.uid];
        pointAnnotation.rpUserIcon = mode.userIcon;
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([mode.lat floatValue], [mode.lon floatValue]);
        [testArray addObject:pointAnnotation];
    }
    self.AnnotationArray = [testArray mutableCopy];
    [self.mapView addAnnotations:_AnnotationArray];
    [self.mapView addAnnotations:_AnnotationRedArray];
}
//点击关闭弹出
- (void)clickeCloseShowViewAction:(UIButton *)btn{
    [self antInfoSet];
}
//点击定位按钮
- (void)clickeAddressBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self judementNearbyAnt];
}
//停止定位
- (void)stopLocation{
    [self.locationManager stopUpdatingLocation];
    
    [self.mapView
     performSelector:@selector(setShowsWorldMap:) withObject:@NO];//关闭海外定位
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark  开启红包
- (void)openRedPacketActionSucess:(BOOL)sucess headImage:(NSString *)headImage redName:(NSString *)name rid:(NSString *)rid
{
    NSString *content = @"快拆开看看,是神马";
    if (!sucess) {
        content = @"不要气馁,再接再励!";
    }
    
    WSRewardConfig *info = ({
        WSRewardConfig *info   = [[WSRewardConfig alloc] init];
        info.money         = 100.0;
        info.avatarImageStr    = headImage;
        info.content = content;
        info.userName  = name;
        info.GedRed =  sucess;
        info.redID = rid;
        info;
    });
    
    __block typeof(self)weakSelf = self;
    [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
        NSLog(@"取消领取");
    } finishBlock:^(float money) {
        MYGetRedPageVC *redVc = [[MYGetRedPageVC alloc] init];
        redVc.nameStr = _nameStr;
        redVc.headImageStr = _headImageStr;
        if (money < 0) {//抢红包失败
            redVc.haveOrNO = NO;
        } else  {//抢红包成功
            redVc.haveOrNO = YES;
        }
        [UIView animateWithDuration:1 animations:^{
            
        } completion:^(BOOL finished) {
//            OpenRdeVC *redVc = [[OpenRdeVC alloc] init];
            [weakSelf.navigationController pushViewController:redVc animated:YES];
        }];
        NSLog(@"领取金额：%f",money);
    }];
}
//创建定位管理者
- (void)creatLocationManager{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置最新距离过滤
    self.locationManager.distanceFilter = 1000;
    //是否开启返回逆地理信息  默认为NO
    [self.locationManager setLocatingWithReGeocode:YES] ;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        [DLTUserCenter userCenter].cityCode = [self makeNewAdCodeWithString:regeocode.adcode];
    }];
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark AMapLocationManagerDelegate
//接受位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    [DLTUserCenter userCenter].coordinate = location.coordinate;
    if (reGeocode){
        [DLTUserCenter userCenter].cityCode = [self makeNewAdCodeWithString:reGeocode.adcode];
    } else if(![DLTUserCenter userCenter].cityCode) {
        
        [self getADCodeWithLoction:location];
    }
}

- (NSString *)makeNewAdCodeWithString:(NSString *)adCode{
    if (!adCode || adCode.length <4) {
        return nil;
    }
    adCode = [adCode substringToIndex:4];
    adCode = [adCode stringByAppendingString:@"00"];
    return adCode;
}

//存储用户展示状态
- (void)saveUserInfoWithString:(NSString *)saveStr{
    [[NSUserDefaults standardUserDefaults] setObject:saveStr forKey:userInfoMapKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取用户展示状态
- (BOOL)userInfoOrOpen{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:userInfoMapKey];
    if ([string isEqualToString:userInfoMapHidden]) {//默认灰色
        return NO;
    } else {//选中 蓝色
        return YES;
    }
}
#pragma mark MaYiRedPacketViewDelegate

- (void)redPacketCheckBtnClick{//点击列表
    MaYiRedPacketDetailController *list = [[MaYiRedPacketDetailController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark MaYiOpenPayViewDelegate

- (void)openPayJumpProtocalCtr:(ProtocalViewController *)protocolCtr{//跳转到协议
    protocolCtr.protol = @"Content/html/mayiprotocol.html";
    [self.navigationController pushViewController:protocolCtr animated:YES];
}
- (void)openPaySelectPayMethod:(MaYiOpenPayType)payType andPassWord:(NSString *)passWord{//支付
    if (payType == MaYiOpenPayALiPay) {
        [self alipayTransfer];
    } else if (payType == MaYiOpenPayBalance) {
        NSString *type = [NSString stringWithFormat:@"%zd",payType +1];
        [self beginOpenMayiControllWithPassWord:passWord type:type];
    }
}
#pragma mark MaYiOpenViewDelegate
- (void)openViewBtnClick{
    //判断是否需要重新定位
    if ([DLTUserCenter userCenter].cityCode.length < 4) {
         _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [DLAlert alertWithText:@"正在定位,请稍后再试" afterDelay:3];
    }
    //跳转到支付界面
    self.payView = [[MaYiOpenPayView alloc] initWithFrame:self.view.bounds];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _payView.delegate = self;
    [window addSubview:_payView];
    [_payView show];
}

#pragma mark MYSearchViewDelegate
- (void)mySearchClicke{
    MYWebViewController *web = [[MYWebViewController alloc] init];
    web.antWeb = self.seachV.searchLabel.text;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark  数据请求


//4获取蚂蚁用户开放状态
- (void)antInfoGet{
    NSString *isAntUserStr = [NSString stringWithFormat:@"%@%@",BASE_URL,AntInfoState];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"uid":user.uid,
                                @"token":[DLTUserCenter userCenter].token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:isAntUserStr parameters:parameter successBlock:^(id response) {
        NSDictionary *dic = response[@"data"];
        if (!dic) {
            self.showInfoBtn.selected = YES;
            return ;
        }
        BOOL isStarted = [dic[@"isStarted"] boolValue];
        if (isStarted) {//开启用户状态
            self.showInfoBtn.selected = YES;
            [self saveUserInfoWithString:userInfoMapShow];
        }else{//关闭用户状态
            self.showInfoBtn.selected = NO;
            [self saveUserInfoWithString:userInfoMapHidden];
        }
    } failureBlock:^(NSError *error) {
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self antInfoGet];
        });
    } progress:nil];
}
//3.设置蚂蚁用户信息开放状态
- (void)antInfoSet{
    self.showInfoBtn.userInteractionEnabled = NO;
//    [DLAlert alertShowLoadStr:@"正在切换状态"];
    if (![self judeCityCode]) {
        [MBProgressHUD hideHUD];
        return;
    }
    NSString *antInfoSet = [NSString stringWithFormat:@"%@%@",BASE_URL,SetAntInfoIsOpen];
    NSString *longitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.latitude];
    NSString *status = [NSString stringWithFormat:@"%zd",![self userInfoOrOpen]];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"cityCode":[DLTUserCenter userCenter].cityCode,
                                @"uid":user.uid,
                                @"token":[DLTUserCenter userCenter].token,
                                @"lat":latitude,
                                @"lon":longitude,
                                @"status":status
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:antInfoSet parameters:parameter successBlock:^(id response) {
        @strongify(self);
//        [MBProgressHUD hideHUD];
        NSNumber *code = response[@"code"];
        NSString *msg = response[@"msg"];
        if ([code isEqual:@1]) {//设置成功
            if ([self userInfoOrOpen]) {
                [self saveUserInfoWithString:userInfoMapHidden];
                self.showInfoBtn.selected = NO;
                [DLAlert alertWithText:@"关闭个人信息显示成功"];
//                [DLAlert alertShowLoadStr:@"关闭个人信息显示成功"];
            } else {
                [self saveUserInfoWithString:userInfoMapShow];
                self.showInfoBtn.selected = YES;
                [DLAlert alertWithText:@"设置个人信息显示成功"];
//                [DLAlert alertShowLoadStr:@"设置个人信息显示"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSLog(@"设置失败");
            
            if (msg  && [self orShowRedPage]) {
                [DLAlert alertWithText:msg];
            }
        }
        
//        [DLAlert alertWithText:response[@"msg"]];
         self.showInfoBtn.userInteractionEnabled = YES;
        [DLAlert alertHideLoadStrWithTime:1.5];
        if (![self orShowRedPage]) {
            self.showInfoBtn.selected = !self.showInfoBtn.selected;
        }
    } failureBlock:^(NSError *error) {
        //        NSLog(@"antInfoSet:%@",error);
        [DLAlert alertShowLoadStr:@"切换状失败"];
        [DLAlert alertHideLoadStrWithTime:1.5];
         self.showInfoBtn.userInteractionEnabled = YES;
    } progress:nil];
   
}
//2.获取周边蚂蚁
- (void)judementNearbyAnt{
    NSString *NearbyAnt = [NSString stringWithFormat:@"%@%@",BASE_URL,GetNearbyAnt];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *longitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.latitude];
    if (![DLTUserCenter userCenter].cityCode) {
        [DLAlert alertWithText:@"未获取到定位信息 请稍后"];
        return;
    }
    NSDictionary *parameter = @{
                                @"cityCode":[DLTUserCenter userCenter].cityCode,
                                @"lon":longitude,
                                @"lat":latitude,
                                @"uid":user.uid,
                                @"token":[DLTUserCenter userCenter].token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:NearbyAnt parameters:parameter successBlock:^(id response) {
        @strongify(self);
        _isAntList = YES;
        NSNumber *code = response[@"code"];
        NSString *msg_msg = response[@"msg"];
        if ([code isEqual:@0] && msg_msg) {
            [DLAlert alertWithText:msg_msg];
        }
        NSDictionary *dic = [response dictValueForKey:@"data"];
        [self makeNearPeopleAndRedPacketWithDic:dic];
    } failureBlock:^(NSError *error) {
        NSLog(@"NearbyAnt:%@",error);
        [DLAlert alertWithText:@"操作失败" afterDelay:3];
    } progress:nil];
}
//处理附近的人
- (void)makeNearPeopleAndRedPacketWithDic:(NSDictionary *)dic{
    NSArray *redPackets = [dic arrayValueForKey:@"redPackets"];
    NSArray *antUsers = [dic arrayValueForKey:@"users"];
    [self.nearRedPacket removeAllObjects];
    [self.nearPeople removeAllObjects];
    for (NSDictionary *redDic in redPackets) {
        RedPacket *redP = [RedPacket showRedPacket];
        [redP setValuesForKeysWithDictionary:redDic];
        [self.nearRedPacket addObject:redP];
    }
    for (NSDictionary *redDic in antUsers) {
        RedPacket *redP = [RedPacket showRedPacket];
        [redP setValuesForKeysWithDictionary:redDic];
        [self.nearPeople addObject:redP];
    }
    [self addNearSourceToMap];
}
//1. 是否是蚂蚁用户
- (void)judementIsAntUser{
    NSString *isAntUserStr = [NSString stringWithFormat:@"%@%@",BASE_URL,SeachIsAnt];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"uid":user.uid,
                                @"token":[DLTUserCenter userCenter].token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:isAntUserStr parameters:parameter successBlock:^(id response) {
        @strongify(self);
        NSLog(@"IsAntUser:%@",response);
        NSDictionary *dic = [response dictValueForKey:@"data"];
        NSNumber *isMayiUser = [dic numberValueForKey:@"isMayiUser"];
        if ([isMayiUser isEqual:@1]) {//是蚂蚁用户
            [self.openView removeFromSuperview];//移除开启视图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self judementNearbyAnt];//获取周边蚂蚁
                [self antInfoGet];//获取蚂蚁状态
            });
        }  else {//不是蚂蚁用户
            
        }
    } failureBlock:^(NSError *error) {
        @strongify(self);
        [DLAlert alertWithText:@"数据请求失败 请稍后"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self judementIsAntUser];
        });
    } progress:nil];
}
//
- (void)beginOpenMayiControllWithPassWord:(NSString *)passWord type:(NSString *)type{
    if (![self judeCityCode]) {
        return;
    }
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *longitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.latitude];
    NSDictionary *dic = @{@"cityCode":[DLTUserCenter userCenter].cityCode,
                          @"lon":longitude,
                          @"lat":latitude,
                          @"amount":@"100",
                          @"payPwd":passWord,
                          @"payType":type,
                          @"uid":user.uid,
                          @"token":[DLTUserCenter userCenter].token
                          };
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,OpenAntUrl];
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        NSNumber *code = response[@"code"];
        if ([code isEqual:@0]) {//失败
            [DLAlert alertWithText:response[@"msg"] afterDelay:2];
        } else if ([code isEqual:@1]){
            @strongify(self);
            [self.payView removeFromSuperview];
            [self.openView removeFromSuperview];
            [self judementNearbyAnt];
        }
        //        @strongify(self)
        
        
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"操作失败" afterDelay:3];
    } progress:nil];
}

//获取用户的展示数据
- (void)getUserInfoShowWithUid:(NSString *)uid{
    NSString *userShow = [NSString stringWithFormat:@"%@%@",BASE_URL,userShowInfo];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"uid":user.uid,
                                @"token":[DLTUserCenter userCenter].token,
                                @"toId":uid
                                };
    
    [BANetManager ba_request_POSTWithUrlString:userShow parameters:parameter successBlock:^(id response) {
        NSLog(@"userShow:%@",response);
        if([response[@"code"] integerValue]== 1){
            NSDictionary * dic = response[@"data"];
            if(dic){
                MaYiPersonalCardModel * model = [[MaYiPersonalCardModel alloc] initWithDic:dic];
                MaYiPersonalCardView *personView = [[MaYiPersonalCardView alloc] initWithFrame:self.view.bounds];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:personView];
                personView.model = model;
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"userShow:%@",error);
    } progress:nil];
}

//数据请求 地理编码
- (void)getADCodeWithLoction:(CLLocation *)location{
    
    NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];//26
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];//119
    NSString *baiduUrl = [NSString stringWithFormat:@"%@%@,%@%@",baiduLatitude,latitude,longitude,baiduLontude];
    
    [ZCAFNHelp getWithPath:baiduUrl params:nil success:^(id json) {
        NSString *receiveStr = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
        receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"renderReverse&&renderReverse(" withString:@""];
        receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *res = jsonDict[@"result"][@"addressComponent"];
        NSString *adCode =  [res stringValueForKey:@"adcode"];
        adCode = [self makeNewAdCodeWithString:adCode];
        [DLTUserCenter userCenter].cityCode = adCode;
        NSLog(@"getADCodeWithLoction:%@",adCode);
    } failure:^(NSError *error) {
        NSLog(@"getADCodeWithLoction: %@",error);
    }];
}
//请求蚂蚁搜一搜数据
- (void)getAntSearchUrl{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *paramter = @{
                             @"uid":user.uid,
                             @"token":[DLTUserCenter userCenter].token
                             };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,antSearchUrlStr] parameters:paramter successBlock:^(id response) {
        @strongify(self);
        NSDictionary *dic = [response dictValueForKey:@"data"];
        NSString *urlStr = [dic stringValueForKey:@"url"];
        if (urlStr) {
            self.seachV.searchLabel.text = urlStr;
        }
    } failureBlock:^(NSError *error) {
        @strongify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getAntSearchUrl];
        });
    } progress:nil];
}
#pragma mark 阿里支付
-(void)alipayTransfer{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *longitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.latitude];
    if (![self judeCityCode]) {
        return;
    }
    NSDictionary *dic = @{@"cityCode":[DLTUserCenter userCenter].cityCode,
                          @"lon":longitude,
                          @"lat":latitude,
                          @"amount":@"100",
                          @"payType":@"2",
                          @"uid":user.uid,
                          @"token":[DLTUserCenter userCenter].token
                          };
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,OpenAntUrl];
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        NSNumber *code = response[@"code"];
        if ([code isEqual:@0]) {//失败
            [DLAlert alertWithText:response[@"msg"] afterDelay:2];
        } else if ([code isEqual:@1]){
            if ([response[@"code"] integerValue] == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *body = response[@"data"];
                    [[AlipaySDK defaultService] payOrder:body fromScheme:@"alipaysdk" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        NSInteger orderState=[resultDic[@"resultStatus"]integerValue];
                        if (orderState==9000) {
                            @strongify(self);
                            [_payView removeFromSuperview];
                            [_openView removeFromSuperview];
                            [DLAlert alertWithText:@"支付成功"];
                            [self judementNearbyAnt];

                        } else {
                            [DLAlert alertWithText:resultDic[@"memo"]];
                        }
                    }];
                });
            }
        
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"操作失败" afterDelay:3];
    } progress:nil];
}
//判断是否有cityCode
- (BOOL)judeCityCode{
    if (![DLTUserCenter userCenter].cityCode || [DLTUserCenter userCenter].cityCode.length < 4) {
        [DLAlert alertWithText:@"蚂蚁未获取到你的定位,请重试" afterDelay:3];
        return NO;
    }
    return YES;
}
//判断是否是iphonX
- (BOOL)isIphoneX{
    if (kScreenHeight == 812) {
        return YES;
    }
    return NO;
}

//返回 是否显示红包
- (BOOL)orShowRedPage{
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:showMYKey];
    if ([key isEqualToString:showMYKeyYes]) {
        return YES;
    }
    return NO;
}

#pragma mark 数据初始化

- (NSMutableArray *)nearPeople{
    if (!_nearPeople) {
        self.nearPeople = [NSMutableArray array];
    }
    return _nearPeople;
}
- (NSMutableArray *)nearRedPacket{
    if (!_nearRedPacket) {
        self.nearRedPacket = [NSMutableArray array];
    }
    return _nearRedPacket;
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
