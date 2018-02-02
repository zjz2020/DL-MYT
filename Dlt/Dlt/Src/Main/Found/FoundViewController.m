//
//  FoundViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "FoundViewController.h"
//#import "AntsgroupsViewController.h"
//#import "RecommendedViewController.h"
#import "JWShareView.h"
#import "DLThirdShare.h"
#import "DLWebViewViewController.h"
#import "STQRCodeController.h"
#import "STQRCodeAlert.h"
#import "CircleoffriendsViewController.h"
#import "FoundCell.h"
#import "GroupandStoreCell.h"
#import "DLTAntColonyAndNoviceGuideViewController.h"
#import "BaseNC.h"
#import "RCHttpTools.h"
#import "DLTransferAccountsTableViewController.h"
#import "DLDailyWageViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>
#define FoundCellIdenifer @"FoundCellIdenifer"
#define GroupandStoreCellIdenifer @"GroupandStoreCellIdenifer"

@interface FoundViewController () <
  STQRCodeControllerDelegate,BMKLocationManagerDelegate,BMKLocationAuthDelegate
>
@property (nonatomic ,strong)BMKLocationManager *locationManager;
@property (nonatomic , strong)NSString * ispromote;
@property (nonatomic , assign)int typeInt;
@end

@implementation FoundViewController
-(void)viewWillAppear:(BOOL)animated{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    
    
    NSString *url = [NSString stringWithFormat:@"%@promote/PromoterStatus",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
         dispatch_async(dispatch_get_main_queue(), ^{
             
        NSString *str = [NSString stringWithFormat:@"%@",response[@"data"][@"status"]];
        if ([str isEqualToString:@"0"]&&[[NSUserDefaults standardUserDefaults]boolForKey:@"UserIsPromoter"]) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"UserIsPromoter"];
            [self.tableView reloadData];
        }else if ([str isEqualToString:@"2"]&&![[NSUserDefaults standardUserDefaults]boolForKey:@"UserIsPromoter"]){
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"UserIsPromoter"];
            [self.tableView reloadData];
        } else if ([str isEqualToString:@"1"] || [str isEqualToString:@"3"] || [str isEqualToString:@"7"]){
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"UserIsPromoter"];
            [self.tableView reloadData];
        }
         });
    } failureBlock:^(NSError *error) {
       
    } progress:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    _typeInt = [user.type integerValue];
    NSLog(@"##########%d",_typeInt);
    [self.tableView registerClass:[FoundCell class] forCellReuseIdentifier:FoundCellIdenifer];
    [self.tableView registerClass:[GroupandStoreCell class] forCellReuseIdentifier:GroupandStoreCellIdenifer];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_typeInt >= 10) {
        return 5;
    }else{
        return 3;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 ||indexPath.row == 2 ||indexPath.row == 3 ) {
           return 64;

    }else
    {

        return 54;

        }
    
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typeInt >= 10) {
      return   [self Administrators:tableView IndexPath:indexPath];
    }else{
       return   [self noAdministrators:tableView IndexPath:indexPath];
    }
   
    return nil;
    
    
}
-(UITableViewCell *)Administrators:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    if (row == 0) {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"friends_00",@"title":@"蚂蚁圈"}];
        
        return cell;
    }else if (row ==1)
    {
        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenifer];
        if (cell == nil) {
            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenifer];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"friends_01",@"title":@"热门蚂蚁群"}];
        
        
        
        return cell;
        
    }else if (row==2)
    {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"friends_02",@"title":@"新手推荐"}];
        
        
        return cell;
        
    }else if (row==3)
    {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        
        [cell file:@{@"icon":@"friends_03",@"title":@"扫一扫"}];
        
        return cell;
        
    }else if (row==4)
    {
        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenifer];
        if (cell == nil) {
            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenifer];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserIsPromoter"]) {
            [cell file:@{@"icon":@"friends_39",@"title":@"日工资"}];
        }else{
            [cell file:@{@"icon":@"friends_426",@"title":@"申请推广员"}];
        }
        
        
        
        
        return cell;
        
        
    }
    return nil;
}
-(UITableViewCell *)noAdministrators:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    if (row == 0) {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"friends_00",@"title":@"蚂蚁圈"}];
        
        return cell;
    }else if (row ==1)
    {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        
        [cell file:@{@"icon":@"friends_03",@"title":@"扫一扫"}];
        
        return cell;
        
    }else if (row==2)
    {
        
        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenifer];
        if (cell == nil) {
            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenifer];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserIsPromoter"]) {
            [cell file:@{@"icon":@"friends_39",@"title":@"日工资"}];
        }else{
            [cell file:@{@"icon":@"friends_426",@"title":@"申请推广员"}];
        }
        
        
        
        return cell;
        
        
        
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row = indexPath.row;
    if (row ==0) {
        CircleoffriendsViewController * circle = [[CircleoffriendsViewController alloc]init];
        [self.navigationController pushViewController:circle animated:YES];

    }else if (row==1 || row == 2)
    {
        if (_typeInt >= 10) {
            DLTAntColonyAndNoviceGuideViewController *vc = [[DLTAntColonyAndNoviceGuideViewController alloc] initAntColonyAndNoviceGuideViewControllerWithType:(row == 1)? DLTAntColonyAndNoviceGuideTypeAntColony :DLTAntColonyAndNoviceGuideTypeNoviceGuide];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ( row == 1) {
                STQRCodeController *codeVC = [[STQRCodeController alloc]init];
                codeVC.delegate = self;
                BaseNC *navVC = [[BaseNC alloc]initWithRootViewController:codeVC];
                [self presentViewController:navVC animated:YES completion:nil];
            }else{
                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserIsPromoter"]) {
                [DLAlert alertShowLoad];
                     [self bmkLocation];

                 }else{
                     DLDailyWageViewController *sdView = [DLDailyWageViewController new];
                     sdView.URLSTR = @"daywage/applypromoter";
                     sdView.cityCode = @"100000";
                     [self.navigationController pushViewController:sdView animated:YES];
                     }
             

            }
        }
      
      
    }else if (row == 3){
      STQRCodeController *codeVC = [[STQRCodeController alloc]init];
      codeVC.delegate = self;
      BaseNC *navVC = [[BaseNC alloc]initWithRootViewController:codeVC];
      [self presentViewController:navVC animated:YES completion:nil];
   }
    else if(row == 4){
  //  [DLAlert alertWithText:@"该功能暂未开启"];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserIsPromoter"]) {
            [DLAlert alertShowLoad];
            [self bmkLocation];
            
        }else{
            DLDailyWageViewController *sdView = [DLDailyWageViewController new];
            sdView.URLSTR = @"daywage/applypromoter";
            sdView.cityCode = @"100000";
            [self.navigationController pushViewController:sdView animated:YES];
        }
       
    }
  
  
  
}
-(void)bmkLocation{
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"ugKIHanQLVWHNTEiITHcHkThVIYSWdQm" authDelegate:self];
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error)
        {
            [DLAlert alertHideLoad];
            DLDailyWageViewController *sdView = [DLDailyWageViewController new];
            sdView.cityCode = @"100000";
            [self.navigationController pushViewController:sdView animated:YES];
        }
        if (location) {//得到定位信息，添加annotation
            
            [DLAlert alertHideLoad];
            DLDailyWageViewController *sdView = [DLDailyWageViewController new];
            if (location.rgcData.countryCode == 0) {
                
                NSString *cody = [NSString stringWithFormat:@"%@00",[location.rgcData.adCode substringToIndex:location.rgcData.adCode.length - 2]];
                sdView.cityCode  =  cody;
                
            }else{
                sdView.cityCode  =  location.rgcData.countryCode;
            }
            [self.navigationController pushViewController:sdView animated:YES];
        }
        
    }];
}


#pragma -
#pragma - STQRCodeControllerDelegate

- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType
{
    if (resultType == STQRCodeResultTypeSuccess) {
        NSDictionary *params = [self dictionaryWithJsonString:readerScanResult];
        if (params) {
            NSString *str = params[@"action"];
            if (str && [str isEqualToString:@"transfer"]) {
                [DLAlert alertShowLoad];
                [[RCHttpTools shareInstance] getOtherUserInfoByUserId:params[@"uid"] handle:^(DLTUserProfile *userInfo) {
                    if (userInfo) {
                        [DLAlert alertHideLoad];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        DLTransferAccountsTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLTransferAccountsTableViewController"];
                        DLFriendsInfo *friendInfo = [DLFriendsInfo new];
                        friendInfo.uid = userInfo.uid;
                        friendInfo.name = userInfo.userName;
                        friendInfo.headImg = userInfo.userHeadImg;
                        friendInfo.isFriend = userInfo.isFriend;
                        friendInfo.note = userInfo.note;
                        vc.friendsInfo = friendInfo;
                        vc.toID = params[@"uid"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            } else if (str && [str isEqualToString:@"addFriend"]) {
                NSString *uid = params[@"uid"];
                [[RCHttpTools shareInstance] addFriendsWithFriendsId:uid handle:^(NSString *message) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }];
            }
        }
    } else {
        [DLAlert alertWithText:@"二维码错误，请扫面正确二维码"];
    }
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {return nil;}
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        [DLAlert alertWithText:@"获取数据失败"];
        return nil;
    }
    return dic;
}
@end
