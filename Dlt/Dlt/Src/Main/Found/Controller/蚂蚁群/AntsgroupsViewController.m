//
//  AntsgroupsViewController.m
//  Dlt
//
//  Created by USER on 2017/5/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "AntsgroupsViewController.h"
#import "AntsgroupsCell.h"
#import "DltUICommon.h"
#import "DLGroupsModel.h"
#import "ZWBucket.h"
#import "DLGroupsModel.h"
#import "DLGroupDetailViewController.h"


#define AntsgroupsCellIdenifer @"AntsgroupsCellIdenifer"

NSString *const kDltAntsgroupsModels = @"dlt_antsgroups_models";

@interface AntsgroupsViewController ()

@end

@implementation AntsgroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门蚂蚁群";
    [self back:@"friends_15"];
    
  // Do any additional setup after loading the view.
  NSArray *models = ZWBucket.userDefault.get(kDltAntsgroupsModels);
  if (models) [self.dataArray addObjectsFromArray:models];
  self.tableView.separatorStyle = NO;
  self.tableView.tableFooterView = [UIView new];
  
  [self dl_networkForHotGroupsList];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   DLGroupsInfo *model = self.dataArray[indexPath.row];
  AntsgroupsCell * cell = [tableView dequeueReusableCellWithIdentifier:AntsgroupsCellIdenifer];
  if (cell== nil) {
    cell = [[AntsgroupsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AntsgroupsCellIdenifer];
    @weakify(self);
    cell.applyToGroup_block_t = ^(){
      @strongify(self);
      [self applyToGroup:model];
    };
    cell.clickGroupAvatar_block_t = ^(){
      @strongify(self);
      [self clickGroupAvatar:model];
    };
  }
  
  [cell configurationCellForModel:model];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  DLGroupsInfo *model = self.dataArray[indexPath.row];
  [self clickGroupAvatar:model];
}

- (void)applyToGroup:(DLGroupsInfo *)model{
    DLGroupsInfo *info = [DLGroupsInfo new];
    info.groupId = model.groupId;
    info.name = model.groupName;
    info.headImg = model.headImg;
    info.isMember = model.isMember;
    info.note = model.note;
    info.createTime = model.createTime;
    info.imgs = model.imgs;
    info.count = model.count;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLGroupDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupDetailViewController"];
    vc.groupsInfo = info;
    vc.isJoined = info.isMember;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickGroupAvatar:(DLGroupsInfo *)model{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  DLGroupDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupDetailViewController"];
  vc.groupsInfo = model;
  vc.isJoined = model.isMember;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - 网络请求

- (void)dl_networkForHotGroupsList{
  NSString *url = [NSString stringWithFormat:@"%@Group/hotGroups",BASE_URL];
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
                            DLGroupsInfo *info = [DLGroupsInfo modelWithDictionary:item];
                             [models addObject:info];
                           }
        
                           if (models) {
                            [self.dataArray removeAllObjects];
                             [self.dataArray addObjectsFromArray:models];
                             [self.tableView reloadData];
                             
                             [ZWBucket.userDefault removeItemForKey:kDltAntsgroupsModels];
                             [ZWBucket.userDefault setItem:[models mutableCopy] forKey:kDltAntsgroupsModels];
                           }
                         }                   
                         
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:@"网络故障稍后重试"];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
}

@end
