//
//  RecommendedViewController.m
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RecommendedViewController.h"
#import "RecommendedCell.h"
#import "DltUICommon.h"
#import "ConversationViewController.h"
#import "SearchFriendsViewController.h"
#import "ZWBucket.h"
#import "DLUserInfDetailViewController.h"

#define RecommendedCellIdeifer @"RecommendedCellIdeifer"

NSString *const kDltRecommendedModels = @"dlt_recommended_models";

@interface RecommendedViewController () <
 RecommendedCellDelegate
>

@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新手推荐";
    [self back:@"friends_15"];
  
  // Do any additional setup after loading the view.
  NSArray *models = ZWBucket.userDefault.get(kDltRecommendedModels);
  if (models) [self.dataArray addObjectsFromArray:models];
  
  self.tableView.tableFooterView = [UIView new];
  self.tableView.separatorStyle = NO;
  [self dl_networkForNewUserRecommend];
}

- (void)backclick{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 95;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
     DLTRecommendModel *model = self.dataArray[indexPath.row];
  
    RecommendedCell * cell = [tableView dequeueReusableCellWithIdentifier:RecommendedCellIdeifer];
    if (cell == nil) {
        cell = [[RecommendedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecommendedCellIdeifer];
      cell.delegate = self;
    }
  
    [cell configurationCellForModel:model];
  
    return cell;
}


#pragma mark -
#pragma mark - RecommendedCellDelegate

- (void)recommendedCell:(RecommendedCell *)cell didClickButton:(DLTRecommendedEventType)eventType{
    DLTRecommendModel *model = cell.model;
  if (eventType == DLTRecommendedEventTypeAddFriends) {
      // 发送添加好友请求
      [self dl_networkForAddNewFriendsWithFriendId:model.uid];
  }
  if (eventType == DLTRecommendedEventTypeSendMessage) {
//    NSLog(@"请求发送好友消息");
    ConversationViewController *conversation = [[ConversationViewController alloc] init];
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = model.uid;
    conversation.title = model.name;
    [self.navigationController pushViewController:conversation animated:YES];
  }
  
  if (eventType == DLTRecommendedEventTypeClickAvatar) { // 点击头像
    DLUserInfDetailViewController *userVC = [DLUserInfDetailViewController new];
    userVC.otherUserId = model.uid;
    [self.navigationController pushViewController:userVC animated:YES];
  }
}

#pragma mark -
#pragma mark - 网络请求

- (void)dl_networkForNewUserRecommend{
  NSString *url = [NSString stringWithFormat:@"%@UserCenter/newUserRecommend",BASE_URL];
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  NSDictionary *params = @{@"token" : userCenter.token,
                           @"uid"   : userCenter.curUser.uid
                           };
  
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {                                                 
                         @strongify(self);
                         if ([response[@"code"] intValue] == 1) {
                           NSArray *result = response[@"data"];
                           NSMutableArray *models = [NSMutableArray new];
                           for (NSDictionary *item in result){
                             DLTRecommendModel *model = [DLTRecommendModel modelWithJSON:item];
                             [models addObject:model];
                           }
                           
                            if (models) {
                              [self.dataArray removeAllObjects];
                              [self.dataArray addObjectsFromArray:models];
                              [self.tableView reloadData];
                              
                              [ZWBucket.userDefault removeItemForKey:kDltRecommendedModels];
                              [ZWBucket.userDefault setItem:[models mutableCopy] forKey:kDltRecommendedModels];
                            }
                         }
                         
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:error.localizedDescription];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
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
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@",error);
    } progress:nil];
}


@end
