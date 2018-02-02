//
//  DLGroupListTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//  群组列表

#import "DLGroupListTableViewController.h"
#import "DLGroupsCell.h"
#import "DLCreatGroupViewController.h"
#import "DLGroupsModel.h"
#import "ConversationViewController.h"
#import "RCDataBaseManager.h"
#import "RCHttpTools.h"
#import "DLGroupSetupViewController.h"
#import "DLFriendsHeadView.h"
#import "NSString+PinYin.h"
#import <MJRefresh/MJRefresh.h>
#define kHeaderViewH   119 - 74
@interface DLGroupListTableViewController ()<DLFriendsHeadViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
//是否是查找事件
@property (nonatomic, assign)BOOL isSeach;
@property (nonatomic, strong)DLFriendsHeadView *headView;
@property (nonatomic, strong) NSMutableArray *seachArr;
@end

@implementation DLGroupListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dl_networkForGetGroupList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    self.isSeach = NO;
    DLFriendsHeadView *headView = [[DLFriendsHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewH)];
    self.headView = headView;
    headView.bottomView.hidden = YES;
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    
    //mj刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(makeMJRefresh)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupList) name:kCreatGroupSuccessNitificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupList) name:kMainGrouperDeletGroupNitificationName object:nil];
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.isSeach) {
        return @"搜索到";
    }
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.isSeach?30:10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSeach?self.seachArr.count:self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLGroupsCell *groupCell = [DLGroupsCell creatGroupCellWithTableView:tableView];
    groupCell.groupInfo = self.isSeach?self.seachArr[indexPath.row]:self.dataArr[indexPath.row];
    return groupCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
#pragma mark  MJ刷新
- (void)makeMJRefresh{
    self.isSeach = NO;
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
        [self.tableView.mj_header endRefreshing];
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
        [self.tableView.mj_header endRefreshing];
    } progress:nil];
}
#pragma mark DLFriendsHeadViewDelegate
//搜索事件
- (void)seachYourSelfFriendsWithNickName:(NSString *)nickName {
    self.isSeach = ISNULLSTR(nickName) ? NO : YES;
    [self.seachArr removeAllObjects];
    for (DLGroupsInfo *info in self.dataArr) {
        if ([info.groupName containsString:nickName]) {
            [self.seachArr addObject:info];
        } else if ([[NSString getStringNameWithHYName:info.groupName] containsString:nickName] && ![self.seachArr containsObject:info]){
            [self.seachArr addObject:info];
        }
        
    }
    if (self.seachArr.count == 0) {
        self.isSeach = NO;
        [DLAlert alertWithText:@"没有搜索到群组"];
    }
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)seachArr {
    if (!_seachArr) {
        _seachArr = [NSMutableArray array];
    }
    return _seachArr;
}

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
