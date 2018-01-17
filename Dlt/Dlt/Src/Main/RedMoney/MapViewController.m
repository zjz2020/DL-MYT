//
//  MapViewController.m
//  Dlt
//
//  Created by Fang on 2018/1/15.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

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
#define OpenAntUrl                  @"mayi/start_mayi"//开启蚂蚁
#define GetNearbyAnt                @"mayi/georadius_user"//获取周边的蚂蚁
#define SeachIsAnt                  @"mayi/is_mayi_user"//查询是否是蚂蚁用户
#define SetAntInfoIsOpen            @"mayi/set_mayi_info_state"//设置蚂蚁用户信息是否开放
#define AntInfoState                @"mayi/mayi_user_state"//蚂蚁用户开放状态
#define ReceiveAntMoney             @"mayi/get_mayi_rp"//领取蚂蚁红包

#define userShowInfo                @"usercenter/otherUserInfo"//获取用户的展示数据

#define baiduLatitude   @"http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location="
#define baiduLontude    @"&output=json&pois=1&ak=RleBOaL1HWYYRpyKFwzleMsGT0I6yOGX"
@interface MapViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate,
                            MaYiOpenViewDelegate,DLPasswordInputViewDelegate,
                            MaYiRedPacketViewDelegate,MaYiOpenPayViewDelegate,MYSearchViewDelegate>
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)MaYiOpenView *openView;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)NSMutableArray  *dataArray2;
@property(nonatomic,strong)NSArray<MAPointAnnotation *> *AnnotationArray;
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
    // Do any additional setup after loading the view.
}

//判断是否一元开启
- (void)judeToOpenMap{
    self.openView = [[MaYiOpenView alloc] initWithFrame:self.view.bounds];
    _openView.delegate = self;
    [self.view addSubview:_openView];
}

- (void)makeUIScreen{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    MYSearchView *seachV = [MYSearchView searchViewWithFram:CGRectMake(10, 20, kScreenWidth - 20, kNewScreenHScale *47)];
    CGFloat SPace = 10;
    seachV.delegate = self;
    [self.mapView addSubview:seachV];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(SPace, [UIScreen mainScreen].bounds.size.height - 2 *SPace - 40- 44, 80, 40);
    closeBtn.selected = [self userInfoOrOpen];//yes 关闭
    [closeBtn addTarget:self action:@selector(clickeCloseShowViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"mayi_14"] forState:UIControlStateNormal];//开启
    [closeBtn setImage:[UIImage imageNamed:@"mayi_12"] forState:UIControlStateSelected];//关闭
    self.showInfoBtn = closeBtn;
    UIButton *addresBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addresBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - SPace - 40, closeBtn.frame.origin.y, 40, 40);
    [addresBtn setImage:[UIImage imageNamed:@"mayi_23"] forState:UIControlStateNormal];
    [addresBtn addTarget:self action:@selector(clickeAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:closeBtn];
    [_mapView addSubview:addresBtn];
    [_mapView setShowsCompass:NO];
    [_mapView setShowsScale:NO];
}

#pragma mark   展示地图上的点--------点点
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
        
        annotationView.image = [UIImage imageNamed:@"mayi_10"];
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
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
                    annotationView.image = [UIImage imageNamed:@"mayi_10"];
                }
                break;
                case AntTypeOther:{
                    annotationView.image = [UIImage imageNamed:@"mayi_15"];
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
            [self antGetRedMoneyWithMoneyid:pointAnnotation.rid];
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
    NSMutableArray *testArray = [NSMutableArray new];
    for (int i = 0; i < self.nearRedPacket.count; i ++){
        RedPacket *mode = self.nearRedPacket[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.annotType = AnnotationTypeMoney;
        pointAnnotation.rid = [NSString stringWithFormat:@"%zd",mode.rpid];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([mode.lat floatValue], [mode.lon floatValue]);
        [testArray addObject:pointAnnotation];
    }
    for (int i = 0; i < self.nearPeople.count; i ++){
        RedPacket *mode = self.nearPeople[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.annotType = AnnotationTypeOther;
        pointAnnotation.pid = [NSString stringWithFormat:@"%zd",mode.uid];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([mode.lat floatValue], [mode.lon floatValue]);
        [testArray addObject:pointAnnotation];
    }
    self.AnnotationArray = testArray;
    [self.mapView addAnnotations:_AnnotationArray];
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
    if ([string isEqualToString:userInfoMapHidden]) {
        return NO;
    } else {
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
    [self.navigationController pushViewController:protocolCtr animated:YES];
}
- (void)openPaySelectPayMethod:(MaYiOpenPayType)payType andPassWord:(NSString *)passWord{//支付
    NSString *type = [NSString stringWithFormat:@"%zd",payType +1];
    [self beginOpenMayiControllWithPassWord:passWord type:type];
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
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark  数据请求

//蚂蚁领红包
- (void)antGetRedMoneyWithMoneyid:(NSString *)moneyid{
    NSString *antGetRedMoney = [NSString stringWithFormat:@"%@%@",BASE_URL,ReceiveAntMoney];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"cityCode":[DLTUserCenter userCenter].cityCode,
                                @"rpid":moneyid,
                                @"uid":user.uid,
                                @"token":user.token
                                };
    [BANetManager ba_request_POSTWithUrlString:antGetRedMoney parameters:parameter successBlock:^(id response) {
        NSLog(@"GetRedMoney:%@",response);
        MaYiRedPacketView *packeV = [[MaYiRedPacketView alloc] initWithFrame:self.view.bounds];
        packeV.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:packeV];
        if ([response[@"code"] isEqual:@0]) {//手慢了
            packeV.showType = MaYiRedPacketNone;
        } else if ([response[@"code"] isEqual:@1]){//领取成功
            packeV.showType = MaYiRedPacketGet;
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"GetRedMoney:%@",error);
    } progress:nil];
}
//4获取蚂蚁用户开放状态
- (void)antInfoGet{
    NSString *isAntUserStr = [NSString stringWithFormat:@"%@%@",BASE_URL,AntInfoState];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"uid":user.uid,
                                @"token":user.token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:isAntUserStr parameters:parameter successBlock:^(id response) {
        NSDictionary *dic = response[@"data"];
        if (!dic) {
            self.showInfoBtn.selected = YES;
            return ;
        }
        BOOL isStarted = [dic booleanValueForKey:@"isStarted"];
        if (isStarted) {//开启用户状态
            self.showInfoBtn.selected = NO;
            [self saveUserInfoWithString:userInfoMapShow];
        }else{//关闭用户状态
            self.showInfoBtn.selected = YES;
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
    [DLAlert alertShowLoadStr:@"正在切换状态"];
    NSString *antInfoSet = [NSString stringWithFormat:@"%@%@",BASE_URL,SetAntInfoIsOpen];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"cityCode":[DLTUserCenter userCenter].cityCode,
                                @"uid":user.uid,
                                @"token":user.token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:antInfoSet parameters:parameter successBlock:^(id response) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [DLAlert alertShowLoadStr:@"切换状态成功"];
         self.showInfoBtn.userInteractionEnabled = YES;
        [DLAlert alertHideLoadStrWithTime:1.5];
        NSDictionary *dic = [response dictValueForKey:@"data"];
        if (!dic) {
            self.showInfoBtn.selected = YES;
            return ;
        }
        BOOL isStarted = [dic booleanValueForKey:@"isStarted"];
        NSLog(@"isStarted: %zd",isStarted);
        if (isStarted) {//开启用户状态
            [self saveUserInfoWithString:userInfoMapShow];
            self.showInfoBtn.selected = NO;
        } else {//关闭用户状态
            [self saveUserInfoWithString:userInfoMapHidden];
            self.showInfoBtn.selected = YES;
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
                                @"token":user.token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:NearbyAnt parameters:parameter successBlock:^(id response) {
        @strongify(self);
        _isAntList = YES;
        NSDictionary *dic = [response dictValueForKey:@"data"];
        [self makeNearPeopleAndRedPacketWithDic:dic];
    } failureBlock:^(NSError *error) {
        NSLog(@"NearbyAnt:%@",error);
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
                                @"token":user.token
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
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *longitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",[DLTUserCenter userCenter].coordinate.latitude];
    NSDictionary *dic = @{@"cityCode":[DLTUserCenter userCenter].cityCode,
                          @"lon":longitude,
                          @"lat":latitude,
                          @"amount":@"100",
                          @"payType":type,
                          @"payPwd":passWord,
                          @"uid":user.uid,
                          @"token":user.token
                          };
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,OpenAntUrl];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        NSNumber *code = response[@"code"];
        if ([code isEqual:@0]) {//失败
            [DLAlert alertWithText:response[@"msg"] afterDelay:2];
        } else if ([code isEqual:@1]){
            [self.payView removeFromSuperview];
            [self.openView removeFromSuperview];
        }
        //        @strongify(self)
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"--%@",error);
    } progress:nil];
}

//获取用户的展示数据
- (void)getUserInfoShowWithUid:(NSString *)uid{
    NSString *userShow = [NSString stringWithFormat:@"%@%@",BASE_URL,userShowInfo];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"uid":user.uid,
                                @"token":user.token,
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
        NSString *adCode = res[@"adcode"];
        adCode = [self makeNewAdCodeWithString:adCode];
        [DLTUserCenter userCenter].cityCode = adCode;
        NSLog(@"getADCodeWithLoction:%@",adCode);
    } failure:^(NSError *error) {
        NSLog(@"getADCodeWithLoction: %@",error);
    }];
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