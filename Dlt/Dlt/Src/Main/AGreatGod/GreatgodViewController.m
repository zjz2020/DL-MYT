//
//  GreatgodViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "GreatgodViewController.h"
#import "SQMenuShowView.h"
#import "STQRCodeController.h"
#import "STQRCodeAlert.h"
#import "XTPopView.h"
#import "DLTGreatgodTableViewCell.h"
#import "DLTGreatgodModel.h"
#import "ZWBucket.h"
#import "MSSBrowseNetworkViewController.h"
#import "SearchFriendsViewController.h"
#import "DltUICommon.h"
#import "ConversationViewController.h"
#import "BaseNC.h"
#import "DLCreatGroupViewController.h"
#import "DLSeachViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "DLUserInfDetailViewController.h"
#import "RCHttpTools.h"
#import "DLTransferAccountsTableViewController.h"
#import <Photos/PHPhotoLibrary.h>
#define kDLT_GreatgodCellIdenifer @"DltGreatgodCellIdenifer"

NSString *const kDltGreatgoddModels = @"dlt_greatgod_models";

@interface GreatgodViewController () <
  selectIndexPathDelegate,
  STQRCodeControllerDelegate,
  DLTGreatgodTableViewCellDelegate
>
{
    UIButton * rightbtn;
    XTPopView *PopView;
}
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@end

@implementation GreatgodViewController
-(void)viewWillAppear:(BOOL)animated{
        //[self upNewApp];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self isHaveNew];
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:@"99999999" name:@"蚂蚁通" portrait:nil];
    [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:@"99999999"];
    [self addrightitem];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
//        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alart show];
       
        
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        
//        if ([[UIApplication sharedApplication]canOpenURL:url]) {
//            
//            [[UIApplication sharedApplication]openURL:url];
//            
//        }
        
    }
    self.tabBarController.navigationItem.title = @"大神在此";
  // get cache
  NSArray <DLTGreatgodModel *>*models = ZWBucket.userDefault.get(kDltGreatgoddModels);
  if (models)  [self.dataArray addObjectsFromArray:models];
  
    // Do any additional setup after loading the view.
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;

  self.tableView.tableFooterView = [UIView new];
  self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
  [self.tableView registerClass:[DLTGreatgodTableViewCell class] forCellReuseIdentifier:kDLT_GreatgodCellIdenifer];
  
   @weakify(self);
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{ // 下拉刷新
    @strongify(self);
      [self dl_networkForGreatgod];
  }];
    [self httpExpressGifImage];
}
-(void)httpExpressGifImage{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@temp/customimgs",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    NSLog(@"%@",user.uid);
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        
      NSArray *imgArray = [[response valueForKey:@"data"]valueForKey:@"imgs"];
         NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:imgArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ExpressGif"];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
    
    NSDictionary *paramImage = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    NSString *urlImage = [NSString stringWithFormat:@"%@UserCenter/userInfo",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:urlImage parameters:paramImage successBlock:^(id response) {
        
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.uid name:response[@"data"][@"userName"] portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,[response valueForKey:@"data"][@"userHeadImg"]]];
        
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:user.uid];
        [RCIM sharedRCIM].currentUserInfo = userInfo;
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];

    
}
-(void)isHaveNew{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isHaveNewCurVersion"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (!str) {
        
        [self ScavengingCaching:appCurVersion];
    }else{
        if (![str isEqualToString:appCurVersion]) {
            [self ScavengingCaching:appCurVersion];
        }
    }
    
}
-(void)ScavengingCaching:(NSString *)appCurVersion{
    [[NSUserDefaults standardUserDefaults]setObject:appCurVersion forKey:@"isHaveNewCurVersion"];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(
                                                                                 NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files =
                       [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                   });
}
-(void)addrightitem{
    rightbtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    [rightbtn setImage:[UIImage imageNamed:@"Okami_00"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
}

- (void)rightClick{
    CGPoint point = CGPointMake(WIDTH -30, 64 + 5);
    PopView = [[XTPopView alloc] initWithOrigin:point
                                          Width:115
                                         Height:120
                                           Type:XTTypeOfUpRight
                                          Color:[UIColor whiteColor]];
    PopView.dataArray = @[@"发起群聊",@"添加好友", @"扫一扫"];
    PopView.fontSize = 13;
    PopView.row_height = 40;
    PopView.titleTextColor = [UIColor blackColor];
    PopView.delegate = self;
    [PopView popView];

}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  [self dl_networkForGreatgod];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
    [PopView dismiss];
}
- (void)selectIndexPathRow:(NSInteger )index
{
    switch (index) {
        case 0: {
            DLCreatGroupViewController *vc = [DLCreatGroupViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            DLSeachViewController *vc = [DLSeachViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [PopView dismiss];
}

#pragma mark - --- 2.delegate 视图委托 ---
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


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}

- (DLTGreatgodTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  DLTGreatgodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDLT_GreatgodCellIdenifer];
  cell.greatgodDelegate = self;
  [cell configureCellWithGreatgodModel:self.dataArray[indexPath.row]];
  
  return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return [DLTGreatgodTableViewCell sizeThatFits];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark -
#pragma mark - DLTGreatgodTableViewCellDelegate

/**
 点击Cell Button 事件
 
 @param cell self
 @param eventType 事件类型
 */
- (void)greatgodTableViewCell:(DLTGreatgodTableViewCell *)cell didClickButton:(DLTGreatgodEventType)eventType{
  
  if (eventType == DLTGreatgodEventTypeAddFriends) {
      DLTGreatgodModel *model = cell.model;
      [self dl_networkForAddNewFriendsWithFriendId:model.uid];
  }

  if (eventType == DLTGreatgodEventTypeSendMessage) {
     NSLog(@"请求发送好友消息");
    DLTGreatgodModel *model = cell.model;
    ConversationViewController *conversation = [[ConversationViewController alloc] init];
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = model.uid;
    conversation.title = model.name;
    [self.navigationController pushViewController:conversation animated:YES];
  }
}


- (void)pushSerchFriendViewController{
  SearchFriendsViewController * addfriend = [[SearchFriendsViewController alloc]init];
  [self.navigationController pushViewController:addfriend animated:YES];
}

/**
 点击Photo 浏览视图 放大图片
 
 @param cell       self
 @param photos     photos图片数据模型
 @param imageViews 使用Pic生成的UIImageView数据
 @param index      当前点击的下标
 */
- (void)greatgodTableViewCell:(DLTGreatgodTableViewCell *)cell
                cellForPhotos:(NSArray <NSString *>*)photos
            cellForImageViews:(NSArray <UIImageView *>*)imageViews
                didClickIndex:(NSInteger )index{
  
  NSMutableArray *browseItemArray = @[].mutableCopy;  
  for(int i = 0; i < photos.count; i++) {
    UIImageView *imageView = imageViews[i];
      NSString *imgUrl =photos[i];

    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc] init];
      if ([imgUrl containsString:@"thumb"]) {
          NSArray *imgArray = [imgUrl componentsSeparatedByString:@"thumb"];
    
          NSArray *childArray = [imgArray[1] componentsSeparatedByString:@"/"];
          imgUrl = [NSString stringWithFormat:@"%@%@",imgArray[0],childArray[childArray.count - 1]];
 
      }
      
      
      browseItem.bigImageUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,imgUrl];
    browseItem.smallImageView = imageView;// 小图
    [browseItemArray addObject:browseItem];
  }
  
  MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
  // bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
  [bvc showBrowseViewController];
}

- (void)greatgodTableViewCell:(DLTGreatgodTableViewCell *)cell didTapAvatarView:(DLTGreatgodModel *)model{
  DLUserInfDetailViewController *userVC = [DLUserInfDetailViewController new];
  userVC.otherUserId = model.uid;
  [self.navigationController pushViewController:userVC animated:YES];
}

#pragma makr -
#pragma makr - network


- (void)dl_networkForGreatgod{
  NSString *url = [NSString stringWithFormat:@"%@UserCenter/dashenList",BASE_URL];
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  NSDictionary *params = @{@"token" : userCenter.token,
                           @"uid"   : userCenter.curUser.uid
                           };
  
          @weakify(self)
         [BANetManager ba_request_POSTWithUrlString:url
                                         parameters:params
                                       successBlock:^(id response) {
                                         @strongify(self);
                                         if ([response[@"code"] intValue] == 1){
                                           NSArray *models = [self resultMapForJson:response[@"data"]];
                                           
                                           if (models) {
                                            [self.dataArray removeAllObjects];
                                             [self.dataArray addObjectsFromArray:models];
                                             [self.tableView reloadData];
                                             [ZWBucket.userDefault removeItemForKey:kDltGreatgoddModels];
                                             [ZWBucket.userDefault setItem:[models mutableCopy] forKey:kDltGreatgoddModels];
                                           }
                                         }
                                         else{
                                           NSLog(@"----error---");
                                         }
                                         
                                          [self endRefreshing];
                                         
                                       } failureBlock:^(NSError *error) {
                                         @strongify(self);
                                         [self endRefreshing];
                                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                         
                                       }];
  
}

- (void)endRefreshing{
 [self.tableView.mj_header endRefreshing];
}

- (NSArray *)resultMapForJson:(NSArray *)result{
  NSMutableArray *temp = [NSMutableArray new];
  for (NSDictionary *item in result) {
    DLTGreatgodModel *model = [DLTGreatgodModel modelWithJSON:item];
    [temp addObject:model];
  }
  return [temp copy];
}

- (void)dl_networkForAddNewFriendsWithFriendId:(NSString *)friendsId {
    if (ISNULLSTR(friendsId)) return;
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/addFriendRequest",BASE_URL];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid,
                             @"fid" : friendsId
                             };
    //    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"发送成功"];
            });
        }
        else{
          [DLAlert alertWithText:[NSString stringWithFormat:@"%@",response[@"msg"]]];
        }
      
    } failureBlock:^(NSError *error) {
       [DLAlert alertWithText:@"发送请求失败"];
//        NSLog(@"error : %@",error);
    } progress:nil];
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
