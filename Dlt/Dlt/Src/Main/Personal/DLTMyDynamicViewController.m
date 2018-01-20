//
//  DLTMyDynamicViewController.m
//  Dlt
//
//  Created by Gavin on 2017/6/12.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTMyDynamicViewController.h"
#import "DltUICommon.h"
#import "CircleoffriendCell.h"
#import "DLTPublishDynamicViewController.h"
#import "RCDNavigationViewController.h"
#import "DLTCircleoffriendDetailViewController.h"
#import "ZWBucket.h"
#import <MJRefresh/MJRefresh.h>
#import "DLThirdShare.h"
NSString *const kDltMyDynamicModels = @"dlt_mydynamic_models";

#define kDLT_MyDynamicViewCellIdenifer @"MyDynamicViewCellIdenifer"

@interface DLTMyDynamicViewController () <
  DLTCircleoffriendCellDelegate,
  DLTCircleoffriendDetailDelegate,
  DLTPublishDynamicDelegate
>

@property (nonatomic, assign) NSInteger curIndexs;

@end

@implementation DLTMyDynamicViewController

- (void)dealloc{
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.title = @"我的动态";
  [self back:@"friends_15"];
  [self rightItem:@"friends_16"];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  @weakify(self);
  NSArray *models = [self resultMapForJson:ZWBucket.userDefault.get(kDltMyDynamicModels)];
  if (models) {
    [self.dataArray addObjectsFromArray:models];
    [self loadLastDataRefresh:YES]; // 刷新数据
  }
  
  self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [self.tableView registerClass:[CircleoffriendCell class] forCellReuseIdentifier:kDLT_MyDynamicViewCellIdenifer];
  self.tableView.tableFooterView = [UIView new];
  
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{ // 下拉刷新
    @strongify(self);
    [self loadLastDataRefresh:YES];
  }];
  
  self.tableView.mj_header.automaticallyChangeAlpha = YES;
  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{// 上拉刷新
    @strongify(self);
    [self loadLastDataRefresh:NO];
  }];
  
  if (!self.dataArray.count)
  {[self.tableView.mj_header beginRefreshing];}
}

- (NSArray *)resultMapForJson:(NSArray *)result{
  NSMutableArray *temp = [NSMutableArray new];
  for (NSDictionary *modelDic in result){
    DLTCircleofFriendDynamicModel *model = [DLTCircleofFriendDynamicModel modelWithJSON:modelDic];
    model.hiddenOperationMoreButton = NO;
    [temp addObject:model];
  }
  return [temp copy];
}


- (void)backclick{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma makr - rightclick

- (void)rightclick{
  DLTPublishDynamicViewController *dynamicVC = [DLTPublishDynamicViewController new];
  dynamicVC.delegate = self;
  RCDNavigationViewController *nav = [[RCDNavigationViewController alloc] initWithRootViewController:dynamicVC];
  [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  CircleoffriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kDLT_MyDynamicViewCellIdenifer];
  cell.circleFriendsDelegate = self;
  cell.indexPath = indexPath;
  cell.model = self.dataArray[indexPath.row];
  return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)cellContentViewWith{
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  
  // 适配ios7
  if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
    width = [UIScreen mainScreen].bounds.size.height;
  }
  return width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
  id model = self.dataArray[indexPath.row];
  return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleoffriendCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  DLTCircleofFriendDynamicModel *model = self.dataArray[indexPath.row];
  [self pushCircleoffriendDetailViewController:model];
}

- (void)pushCircleoffriendDetailViewController:(DLTCircleofFriendDynamicModel *)model{
  DLTCircleoffriendDetailViewController *viewController = [[DLTCircleoffriendDetailViewController alloc] initWithCircleoffriendDetailViewController:model];
  viewController.delegate = self;
    viewController.isMine = YES;
  [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark - DLTCircleoffriendCellDelegate

- (DLTCircleofFriendDynamicModel *)userRequestThumbup:(DLTCircleofFriendDynamicModel *)oldModel{
  DLTCircleofFriendDynamicModel *likeModel = [oldModel copy];
  
  if (oldModel.isLiked) { // 取消 liked
    //
    NSMutableArray *newLikes = [likeModel.likes mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", DLT_USER_CENTER.curUser.uid];
    NSArray *predicateArr = [newLikes filteredArrayUsingPredicate:predicate];
    if (predicateArr.count) {
      DLTCircleofFriendDynamicLikeModel *zan = predicateArr.firstObject;
      if ([newLikes containsObject:zan]) {
        [newLikes removeObject:zan];
      }
    }
    
    likeModel.likes = newLikes;
  }else{
    DLTCircleofFriendDynamicLikeModel *zan = [DLTCircleofFriendDynamicLikeModel new];
    zan.uid = DLT_USER_CENTER.curUser.uid;
    zan.userName = DLT_USER_CENTER.curUser.userName;
    [likeModel.likes addObject:zan];
  }
  
  likeModel.liked = !oldModel.isLiked;
  return likeModel;
}

- (void)circleoffriendCell:(CircleoffriendCell *)cell didClickIndex:(CGFloat)index{
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  DLTCircleofFriendDynamicModel *model = self.dataArray[indexPath.row];
  
  if (index == 10086) {
    [self dl_networkForModel:model curIndex:indexPath];
  }
  
  if (index == 10087) {
//    NSLog(@"请求评论 Event");
    [self pushCircleoffriendDetailViewController:model];
  }
  
  if (index == 10088) { // more
   [self showMoreUI:indexPath];
  }
}

- (void)circleoffriendCell:(CircleoffriendCell *)cell didMoreClick:(NSIndexPath *)indexPath{
  [self pushCircleoffriendDetailViewController:cell.model];
}

- (void)showMoreUI:(NSIndexPath *)indexPath{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
  @weakify(self);
  UIAlertAction *sendFriendAction = [UIAlertAction actionWithTitle:@"朋友圈分享"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                             @strongify(self);
                                                               [self sendFriendAction:indexPath];
                                                           }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action){
                                
                                                               [alertController dismissViewControllerAnimated:YES completion:nil];
                                                            }];
//
  UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                          @strongify(self);
                                                          [self deleteAction:indexPath];
                                                       }];
    
//    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消AAAA" style:UIAlertActionStyleCancel handler:nil];
    
  [alertController addAction:sendFriendAction];
//  [alertController addAction:collectionAction];
  [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}
//发送给朋友
- (void)sendFriendAction:(NSIndexPath *)indexPath{
    DLTCircleofFriendDynamicModel *model = self.dataArray[indexPath.row];
    DLThirdShare  * object = [DLThirdShare thirdShareInstance];
    object.shareTitle = @"蚂蚁通分享";
    object.shareText  = model.text;
    object.shareUrl = @"http://mayiton.com/";
    object.shareImage = [UIImage imageNamed:@"shareImg"];
    [object shareToWechat:ShareWechatType_Circle];
}

- (void)collectionAction{
  
}

- (void)deleteAction:(NSIndexPath *)indexPath{
  DLTCircleofFriendDynamicModel *model = self.dataArray[indexPath.row];

  NSString *url = [NSString stringWithFormat:@"%@Article/delArticle",BASE_URL];
  DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
  NSDictionary *params = @{
                           @"token" : [DLTUserCenter userCenter].token,
                           @"uid"   : user.uid,
                           @"articleId" : model.articleId
                           };
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         @strongify(self);
                         if ([response[@"code"] intValue] == 1) {
                            [MBProgressHUD showError:@"删除成功"];
                            [self.tableView.mj_header beginRefreshing];
                         }
                         else{
                           [MBProgressHUD showError:@"删除失败"];
                         }
                         
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:@"删除失败"];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
}


#pragma mark -
#pragma mark - DLTCircleoffriendDetailDelegate

- (void)circleoffriendDetailDelegate:(DLTCircleoffriendDetailViewController *)viewController circleofFriendModel:(DLTCircleofFriendDynamicModel *)model{
  
}

#pragma mark -
#pragma mark - DLTPublishDynamicDelegate

- (void)publishDynamicViewController:(DLTPublishDynamicViewController *)viewController
           didPublishDynamicMessages:(NSString *)content
                    publishedDynamic:(BOOL)isSuccessful
{
  if (isSuccessful) {
    [self.tableView.mj_header beginRefreshing];
  }
}



#pragma mark -
#pragma mark - 网络请求

- (void)endRefreshing:(BOOL)isHeader{
  if (isHeader) {[self.tableView.mj_header endRefreshing];}
  else{[self.tableView.mj_footer endRefreshing];}
}


- (void)loadLastDataRefresh:(BOOL)isHeader{
    if (isHeader) { self->_curIndexs = 1;}
  
  @weakify(self);
  [self dl_networkForMyDynamicWithIndexs:_curIndexs
                                     successBlock:^(NSArray <DLTCircleofFriendDynamicModel *>*models) {
                                       @strongify(self);
                                       if (models.count < 10) { // 服务器默认没页返回10条
                                         [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                       }
                                       else{self->_curIndexs++;}
                                       
                                       if (models) {
                                         NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:models];
                                         if (isHeader) { //如果下拉
                                           [self.dataArray removeAllObjects];
                                         }
                                         [self.dataArray addObjectsFromArray:temp];
                                         [self.tableView reloadData];
                                       }
                                       
                                       [self endRefreshing:isHeader];
                                       
                                     } failureBlock:^{
                                       @strongify(self);
                                       [self endRefreshing:isHeader];
                                     }];
}


- (void)dl_networkForMyDynamicWithIndexs:(NSInteger)count
                            successBlock:(void (^)(NSArray *))success
                            failureBlock:(dispatch_block_t)failure
{
  NSString *url = [NSString stringWithFormat:@"%@Article/myArticles",BASE_URL];
  DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
  NSDictionary *params = @{
                           @"token" : [DLTUserCenter userCenter].token,
                           @"uid"   : user.uid,
                           @"index"  : [NSString stringWithFormat:@"%d",(int)count]
                           };
  
  
  
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         
                         
                         @strongify(self);
                         if ([response[@"code"] intValue] == 1) {
                           NSArray *result = response[@"data"];
                           NSArray *models = [self resultMapForJson:result];
//                            暂时缓存最前面的10 json
                           if (self->_curIndexs == 1) {
                             [ZWBucket.userDefault removeItemForKey:kDltMyDynamicModels];
                             [ZWBucket.userDefault setItem:[result mutableCopy] forKey:kDltMyDynamicModels];
                           }
                           
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                             if (success) {success([models copy]);}
                           });
                         }
                         
                         else{ if (failure)failure();}
                         
                       } failureBlock:^(NSError *error) {
                         if (failure)failure();
                         [MBProgressHUD showError:error.localizedDescription];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
}

- (void)dl_networkForModel:(DLTCircleofFriendDynamicModel *)model curIndex:(NSIndexPath *)indexPath{
  NSString *url = [NSString stringWithFormat:@"%@Article/dianZan",BASE_URL];
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  NSDictionary *params = @{@"token" : userCenter.token,
                           @"uid"   : userCenter.curUser.uid,
                           @"articleId" : model.articleId
                           };
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         @strongify(self);
                         if ([response[@"code"] intValue] == 1) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                             @strongify(self);
                             DLTCircleofFriendDynamicModel *likeModel = [self userRequestThumbup:model];
                             [self.dataArray replaceObjectAtIndex:indexPath.row withObject:likeModel];
                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             [MBProgressHUD showSuccess:@"操作成功"];
                           });
                         }
                         
                         else{ [MBProgressHUD showError:@"操作失败"];}
                         
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:@"操作失败"];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
  
}

@end
