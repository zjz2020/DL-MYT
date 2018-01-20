//
//  CircleoffriendsViewController.m
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "CircleoffriendsViewController.h"
#import "CircleoffriendCell.h"
#import "DLTCircleofFriendDynamicModel.h"  

#import "SDRefresh.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineRefreshHeader.h"

#import "DLTCircleoffriendDetailViewController.h"
#import "DLTPublishDynamicViewController.h"
#import "RCDNavigationViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "ZWBucket.h"

#define kDLT_CircleoffriendCellIdenifer @"DltCircleoffriendCellIdenifer"

NSString *const kDltCircleofFriendModels = @"dlt_circleofFriend_models";

@interface CircleoffriendsViewController () <
 DLTCircleoffriendCellDelegate,
 DLTCircleoffriendDetailDelegate,
 DLTPublishDynamicDelegate
>
{
    CGFloat _lastScrollViewOffsetY;
  
  ;
   CGFloat _totalKeybordHeight;
//   NSIndexPath *_currentEditingIndexthPath;
}

@property (nonatomic, assign) NSInteger curIndexs;
@property (nonatomic, assign) BOOL      isClick;  //防止多次快速点击
@property (nonatomic, assign) NSIndexPath   * selectPath; //选中的cell

@end

@implementation CircleoffriendsViewController

- (void)dealloc{

}

- (NSArray *)resultMapForJson:(NSArray *)result{
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *modelDic in result){
        DLTCircleofFriendDynamicModel *model = [DLTCircleofFriendDynamicModel modelWithJSON:modelDic];
        if(model.likes && model.likes.count > 0){
            for(DLTCircleofFriendDynamicLikeModel * likeModel in model.likes){
                if([likeModel.uid isEqualToString:[DLTUserCenter userCenter].curUser.uid]){
                    model.liked = YES;
                    break;
                }
            }
        }
        [temp addObject:model];
    }
    return [temp copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蚂蚁圈";
    [self back:@"friends_15"];
    [self rightItem:@"friends_16"];

  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  

  @weakify(self);
  NSArray *models = [self resultMapForJson:ZWBucket.userDefault.get(kDltCircleofFriendModels)];
  if (models) {
    [self.dataArray addObjectsFromArray:models]; 
    [self loadLastDataRefresh:YES]; // 刷新数据
  }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelectCell:) name:@"reloadComments" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [self.tableView registerClass:[CircleoffriendCell class] forCellReuseIdentifier:kDLT_CircleoffriendCellIdenifer];
  self.tableView.tableFooterView = [UIView new];
  self.tableView.separatorStyle = NO;
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

- (void)reloadSelectCell:(NSNotification *)notity{
    DLTCircleofFriendDynamicModel * model = (DLTCircleofFriendDynamicModel *)[notity object];
    [self.dataArray replaceObjectAtIndex:_selectPath.row withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[_selectPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)loadLastDataRefresh:(BOOL)isHeader{
  if (isHeader) { self->_curIndexs = 1;}
  
  @weakify(self);
  [self dl_networkForCircleofFriendListWithIndexs:_curIndexs
                                     successBlock:^(NSArray <DLTCircleofFriendDynamicModel *>*models) {
                                       @strongify(self);
                                       if (models) {
                                         NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:models];
                                         if (isHeader) { //如果下拉
                                           [self.dataArray removeAllObjects];
                                         }
                                         [self.dataArray addObjectsFromArray:temp];
                                         [self.tableView reloadData];
                                       }
                                        [self endRefreshing:isHeader];
                                         
                                       if (models.count < 10) { // 服务器默认没页返回10条
                                         [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                       }
                                       else{self->_curIndexs++;}
                                     } failureBlock:^{
                                       @strongify(self);
                                       [self endRefreshing:isHeader];
                                     }];
}

- (void)endRefreshing:(BOOL)isHeader{
  if (isHeader) {[self.tableView.mj_header endRefreshing];}
  else{[self.tableView.mj_footer endRefreshing];}
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
    CircleoffriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kDLT_CircleoffriendCellIdenifer];
    cell.circleFriendsDelegate = self;
    DLTCircleofFriendDynamicModel *model = self.dataArray[indexPath.row];
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
    return [self.tableView cellHeightForIndexPath:indexPath
                                            model:model
                                          keyPath:@"model"
                                        cellClass:[CircleoffriendCell class]
                                 contentViewWidth:[self cellContentViewWith]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLTCircleofFriendDynamicModel *model = self.dataArray[indexPath.row];
    _selectPath = indexPath;
    [self pushCircleoffriendDetailViewController:model];
}

- (void)pushCircleoffriendDetailViewController:(DLTCircleofFriendDynamicModel *)model{
  DLTCircleoffriendDetailViewController *viewController = [[DLTCircleoffriendDetailViewController alloc] initWithCircleoffriendDetailViewController:model];
  viewController.delegate = self;
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
    _selectPath = indexPath;
    if (index == 10086) {
        if(_isClick){
            return;
        }
        _isClick = YES;
        [self dl_networkForModel:model curIndex:indexPath];
    }
  
    if (index == 10087) {
        NSLog(@"请求评论 Event");
        [self pushCircleoffriendDetailViewController:model];
    }
  
}

- (void)circleoffriendCell:(CircleoffriendCell *)cell didMoreClick:(NSIndexPath *)indexPath{
    [self pushCircleoffriendDetailViewController:cell.model];
}

#pragma mark -
#pragma mark - DLTCircleoffriendDetailDelegate

- (void)circleoffriendDetailDelegate:(DLTCircleoffriendDetailViewController *)viewController circleofFriendModel:(DLTCircleofFriendDynamicModel *)model{

}

#pragma mark -
#pragma mark - DLTPublishDynamicDelegate  -DINIT_SCRIPTING_BACKEND=1

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
                                     //[MBProgressHUD showSuccess:@"操作成功"];
                                 });
                             }
                             
                             else{ //[MBProgressHUD showError:@"操作失败"];
                                 
                             }
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 self.isClick = NO;
                             });
                             
                         } failureBlock:^(NSError *error) {
                             
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 self.isClick = NO;
                             });
                             //[MBProgressHUD showError:@"操作失败"];
                         } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                             
                         }];
  
}

- (void)dl_networkForCircleofFriendListWithIndexs:(NSInteger)index successBlock:(void (^)(NSArray *))success failureBlock:(dispatch_block_t)failure{
  NSString *url = [NSString stringWithFormat:@"%@Article/articleList",BASE_URL];
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  NSDictionary *params = @{@"token" : userCenter.token,
                           @"uid"   : userCenter.curUser.uid,
                           @"index" : [NSString stringWithFormat:@"%d",(int)index]
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
                           
                           // 暂时缓存最前面的10 json
                           if (self->_curIndexs == 1) {
                             [ZWBucket.userDefault removeItemForKey:kDltCircleofFriendModels];
                             [ZWBucket.userDefault setItem:[result mutableCopy] forKey:kDltCircleofFriendModels];
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


@end
