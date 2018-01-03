//
//  WalleatViewController.m
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "WalleatViewController.h"
#import "WalletCell.h"
#import "WalletbalanceCell.h"
#import "GroupandStoreCell.h"
#import "WalleatotherCell.h"
#import "CollectmoneyViewController.h"
#import "TransferViewController.h"
#import "MKQRCode.h"
#import "WithdrawalViewController.h"
#import "XTPopView.h"
#import "SetupPasswordViewController.h"
#import "SeletorFriendsViewController.h"
#import "ChangepayViewController.h"
#import "FoundCell.h"
#import "WalletModel.h"
#import "RCHttpTools.h"
#import "RegisterPersonDataViewController.h"
#import "STQRCodeController.h"
#import "BaseNC.h"
#import "DLTransationRecordViewController.h"
#import "DLTransferAccountsTableViewController.h"
#import "DLChooseFriendsTableViewController.h"
#import "DLDailyWageViewController.h"
#import "ChangepayViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>

#define WalletCellInderifer @"WalletCellInderifer"
#define WalletbalanceCellInderifer @"WalletbalanceCellInderifer"
#define GroupandStoreCellInderifer @"GroupandStoreCellInderifer"
#define WalleatotherCellInderifer @"WalleatotherCellInderifer"
#define FoundCellIdenifer @"FoundCellIdenifer"

@interface WalleatViewController ()<BMKLocationManagerDelegate,BMKLocationAuthDelegate,selectIndexPathDelegate,STQRCodeControllerDelegate>
{
    XTPopView *PopView;
    WalletCell* wallet;
    NSString * password;
    BOOL isSetPaypwd;
    WalletModel *model;
    NSString * balances;
    NSString * istrue;

}
@property (nonatomic ,strong)BMKLocationManager *locationManager;
@end

@implementation WalleatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
    [self back:@"friends_15"];
    [self rightTitle:@"更多"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WalletCell class] forCellReuseIdentifier:WalletCellInderifer];
    [self.tableView registerClass:[WalletbalanceCell class] forCellReuseIdentifier:WalletbalanceCellInderifer];
     [self.tableView registerClass:[GroupandStoreCell class] forCellReuseIdentifier:GroupandStoreCellInderifer];
    [self.tableView registerClass:[WalleatotherCell class] forCellReuseIdentifier:WalleatotherCellInderifer];
        [self.tableView registerClass:[FoundCell class] forCellReuseIdentifier:FoundCellIdenifer];
}
-(void)rightclicks {
    
    CGPoint point = CGPointMake(WIDTH-40,self.view.frame.origin.y + 74);
    PopView = [[XTPopView alloc] initWithOrigin:point Width:130 Height:120 Type:XTTypeOfRightUp Color:[UIColor colorWithHexString:@"7f7f7f"]];
    PopView.dataArray = @[@"交易记录",@"支付管理", @"扫一扫"];
    PopView.fontSize = 13;
    PopView.row_height = 40;
    PopView.titleTextColor = [UIColor whiteColor];
    PopView.delegate = self;
    [PopView popView];

}
-(void)backclick
{
    if (_result) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [PopView dismiss];
}
- (void)selectIndexPathRow:(NSInteger )index
{
    switch (index) {
        case 0:
        {
            DLTransationRecordViewController * transcation = [DLTransationRecordViewController new];
            [self.navigationController pushViewController:transcation animated:YES];
            break;
        }
        case 1:
        {
            ChangepayViewController * changepay = [[ChangepayViewController alloc]init];
            changepay.seleType = model.IsSetPaypwd;
            [self.navigationController pushViewController:changepay animated:YES];
            break;
        }
        case 2:
        {
            STQRCodeController *codeVC = [[STQRCodeController alloc]init];
            codeVC.delegate = self;
            BaseNC *navVC = [[BaseNC alloc]initWithRootViewController:codeVC];
            [self presentViewController:navVC animated:YES completion:nil];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary * dic= @{
                          @"token":[DLTUserCenter userCenter].token,
                          @"uid":user.uid
                          };
    NSString * url = [NSString stringWithFormat:@"%@Wallet/isSetPaypwd",BASE_URL];
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        @strongify(self);
       self-> model = [WalletModel modelWithJSON:response[@"data"]];
        istrue = model.IsSetPaypwd ? @"true" : @"false";
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    [[RCHttpTools shareInstance] checkMyBalances:^(NSString *myBalances) {
        balances = [NSString stringWithFormat:@"%.2f",[myBalances floatValue]/100];
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([istrue isEqualToString:@"false"]) {
        return 5;
    }else
    {
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ([istrue isEqualToString:@"false"]) {
        if (row==0) {
            return 40;
        }else if (row==1)
        {
            return 130;
        }else if (row==2)
        {
            return 54;
        }else if (row==3)
        {
            return 64;
        }
        else
        {
            return 100;
        }

    } else {
        
         if (row==0)
        {
            return 130;
        }else if (row==1||row==2)
        {
            return 54;
        }else
        {
            return 100;
        }

    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    if ([istrue isEqualToString:@"false"]) {
        if (row ==0) {
            wallet = [tableView dequeueReusableCellWithIdentifier:WalletCellInderifer];
            if (wallet==nil) {
                wallet = [[WalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WalletCellInderifer];
            }
            wallet.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return wallet;
        }else if (row==1)
        {
            WalletbalanceCell * cell = [tableView dequeueReusableCellWithIdentifier:WalletbalanceCellInderifer];
            if (cell == nil) {
                cell =[[WalletbalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WalletbalanceCellInderifer];
            }
         
            
            cell.moneyLabel.text = balances;
            
            
            return cell;
        }else if (row==2)
        {
            GroupandStoreCell * cell =[tableView dequeueReusableCellWithIdentifier:GroupandStoreCellInderifer];
            if (cell == nil) {
                cell =[[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellInderifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"icon":@"wallet_02",@"title":@"支付管理"}];
            return cell;
        }else if (row==3)
        {
            FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
            if (cell == nil) {
                cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"icon":@"wallet_03",@"title":@"提现"}];
            return cell;
        }else if (row==4)
        {
            WalleatotherCell * cell = [tableView dequeueReusableCellWithIdentifier:WalleatotherCellInderifer];
            if (cell == nil) {
                cell = [[WalleatotherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WalleatotherCellInderifer];
            }
            cell.transferClick = ^(UIButton *btn) {
                CollectmoneyViewController * collect = [[CollectmoneyViewController alloc]init];
                [self.navigationController pushViewController:collect animated:YES];
                
            };
            // 转账
            cell.topupClick = ^(UIButton *btn) {
                DLChooseFriendsTableViewController * selectorfriend = [[DLChooseFriendsTableViewController alloc]init];
                [self.navigationController pushViewController:selectorfriend animated:YES];
            };
            //日工资
            cell.wageClick = ^(UIButton *btn) {
                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(bmkLocation) object:nil];
                
                [self performSelector:@selector(bmkLocation) withObject:nil afterDelay:0.4f];
            };
            
            return cell;
        }

    }else
    {
        
        if (row==0)
        {
            WalletbalanceCell * cell = [tableView dequeueReusableCellWithIdentifier:WalletbalanceCellInderifer];
            if (cell == nil) {
                cell =[[WalletbalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WalletbalanceCellInderifer];
            }
                cell.moneyLabel.text = balances;
            return cell;
        }else if (row==1)
        {
            GroupandStoreCell * cell =[tableView dequeueReusableCellWithIdentifier:GroupandStoreCellInderifer];
            if (cell == nil) {
                cell =[[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellInderifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"icon":@"wallet_02",@"title":@"支付管理"}];
            return cell;
        }else if (row==2)
        {
            GroupandStoreCell * cell =[tableView dequeueReusableCellWithIdentifier:GroupandStoreCellInderifer];
            if (cell == nil) {
                cell =[[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellInderifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"icon":@"wallet_03",@"title":@"提现"}];
            return cell;
        }else if (row==3)
        {
            WalleatotherCell * cell = [tableView dequeueReusableCellWithIdentifier:WalleatotherCellInderifer];
            if (cell == nil) {
                cell = [[WalleatotherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WalleatotherCellInderifer];
            }
            @weakify(self)
            cell.transferClick = ^(UIButton *btn) {
                @strongify(self)
                CollectmoneyViewController * collect = [[CollectmoneyViewController alloc]init];
                [self.navigationController pushViewController:collect animated:YES];
            };
            
            cell.topupClick = ^(UIButton *btn) {
                @strongify(self)
                DLChooseFriendsTableViewController * selectorfriend = [[DLChooseFriendsTableViewController alloc]init];
                [self.navigationController pushViewController:selectorfriend animated:YES];
            };
            cell.wageClick = ^(UIButton *btn) {
                [DLAlert alertShowLoad];
                [self bmkLocation];
            };
            return cell;
        }
    }
    return nil;
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
            if (location.rgcData) {
                DLDailyWageViewController *sdView = [DLDailyWageViewController new];
                sdView.cityCode  =  location.rgcData.adCode;
                [self.navigationController pushViewController:sdView animated:YES];
                
                
                
            }
        }
        
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([istrue isEqualToString:@"false"]) {
        if (indexPath.row==2) {
            ChangepayViewController * topup = [[ChangepayViewController alloc]init];
            topup.seleType = model.IsSetPaypwd;
            [self.navigationController pushViewController:topup animated:YES];
        }else if (indexPath.row==3)
        {
            WithdrawalViewController * withdraw = [[WithdrawalViewController alloc]init];
            [self.navigationController pushViewController:withdraw animated:YES];
            
        }else if (indexPath.row==0)
        {
            SetupPasswordViewController * setuppassword = [[SetupPasswordViewController alloc]init];
            [self.navigationController pushViewController:setuppassword animated:YES];
        }
    }else
    {
        if (indexPath.row==1) {
            ChangepayViewController * topup = [[ChangepayViewController alloc]init];
            topup.seleType = model.IsSetPaypwd;
            [self.navigationController pushViewController:topup animated:YES];

        }else if (indexPath.row==2)
        {
            WithdrawalViewController * withdraw = [[WithdrawalViewController alloc]init];
            [self.navigationController pushViewController:withdraw animated:YES];
            
        }else if (indexPath.row==0)
        {
//            self.hidesBottomBarWhenPushed = YES;
//            RegisterPersonDataViewController * withdraw = [[RegisterPersonDataViewController alloc]init];
//            [self.navigationController pushViewController:withdraw animated:YES];
        }
        
    }

}
#pragma mark - 扫一扫代理
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType {
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
