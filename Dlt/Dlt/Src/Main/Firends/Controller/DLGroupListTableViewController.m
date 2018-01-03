//
//  DLGroupListTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupListTableViewController.h"
#import "DLGroupsCell.h"
#import "DLCreatGroupViewController.h"
#import "DLGroupsModel.h"
#import "ConversationViewController.h"
#import "RCDataBaseManager.h"
#import "RCHttpTools.h"
#import "DLGroupSetupViewController.h"


@interface DLGroupListTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DLGroupListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dl_networkForGetGroupList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupList) name:kCreatGroupSuccessNitificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupList) name:kMainGrouperDeletGroupNitificationName object:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLGroupsCell *groupCell = [DLGroupsCell creatGroupCellWithTableView:tableView];
    groupCell.groupInfo = self.dataArr[indexPath.row];
    return groupCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLGroupsInfo *userInfo = self.dataArr[indexPath.row];
    ConversationViewController *conversation = [[ConversationViewController alloc] init];
    conversation.conversationType = ConversationType_GROUP;
    conversation.targetId = userInfo.groupId;
    conversation.hidesBottomBarWhenPushed = YES;
    conversation.title = userInfo.groupName;
    [self.navigationController pushViewController:conversation animated:YES];
}


- (void)reloadGroupList {
    [self dl_networkForGetGroupList];
}

#pragma mark - 网络请求
- (void)dl_networkForGetGroupList {
    
    // 先从数据库里面取
//    NSArray *groupArr = [[RCDataBaseManager shareInstance] getGroupList];
//    if (groupArr.count > 0) {
//        [self.dataArr removeAllObjects];
//        for (RCGroup *group in groupArr) {
//            DLGroupsInfo *info = [DLGroupsInfo new];
//            info.headImg = group.portraitUri;
//            info.groupName = group.groupName;
//            info.groupId = group.groupId;
//            [self.dataArr addObject:info];
//        }
//        [self.tableView reloadData];
//        return;
//    }
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSString *url = [NSString stringWithFormat:@"%@Group/myGroups",BASE_URL];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        DLGroupsModel *groupModel = [DLGroupsModel modelWithJSON:response];
        if ([groupModel.code integerValue] == 1) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:groupModel.data];
            
            NSMutableArray *temp = [NSMutableArray array];
            for (DLGroupsInfo *info in groupModel.data) {
                RCGroup *group = [[RCGroup alloc] initWithGroupId:info.groupId groupName:info.groupName portraitUri:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg]];
                [temp addObject:group];
            }
            [[RCDataBaseManager shareInstance] insertGroupListToDB:temp];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCreatGroupSuccessNitificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMainGrouperDeletGroupNitificationName object:nil];
}
@end
