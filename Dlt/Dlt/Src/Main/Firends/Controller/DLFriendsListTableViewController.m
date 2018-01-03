//
//  DLFriendsListTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLFriendsListTableViewController.h"
#import "DLFriendsHeadView.h"
#import "DLFriendsCell.h"
#import "RCDataManager.h"
#import "ConversationViewController.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"
#import "RCHttpTools.h"
#import "RCDataBaseManager.h"
#import "DLMyNewFriendsTableViewController.h"
#import "DLFriendsSetTableViewController.h"
#import "DLUserInfDetailViewController.h"

#define kHeaderViewH   119

@interface DLFriendsListTableViewController ()<DLFriendsHeadViewDelegate>

@property (nonatomic, strong) DLFriendsHeadView *headView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *seachArr;
@property (nonatomic, assign) BOOL isSeach;
@end

@implementation DLFriendsListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dl_networkForGetFriendsList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.isSeach = NO;
    DLFriendsHeadView *headView = [[DLFriendsHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewH)];
    self.headView = headView;
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    
    // 获取好友列表
//    [self dl_networkForGetFriendsList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dl_networkForGetFriendsList) name:kRefreshFriendsListNoticationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dl_networkForGetFriendsList) name:kHandleRequestNotificationName object:nil];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSeach) {
        return self.seachArr.count;
    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLFriendsCell *friendsCell = [DLFriendsCell creatFriendsCellWithTableView:tableView];
    friendsCell.frinedsInfo = self.isSeach ? self.seachArr[indexPath.row] : self.dataArr[indexPath.row];
    
    @weakify(self)
    friendsCell.clickBlock = ^(DLFriendsInfo *userInfo) {
        @strongify(self)
        DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
        vc.otherUserId = userInfo.fid;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return friendsCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLFriendsInfo *userInfo = self.isSeach ? self.seachArr[indexPath.row] : self.dataArr[indexPath.row];
    ConversationViewController *conversation = [[ConversationViewController alloc] init];
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = userInfo.fid;
    conversation.hidesBottomBarWhenPushed = YES;
    conversation.title = userInfo.name;
    [_mainView.navigationController pushViewController:conversation animated:YES];
}
#pragma mark - 自定义代理
- (void)seachYourSelfFriendsWithNickName:(NSString *)nickName {
    self.isSeach = ISNULLSTR(nickName) ? NO : YES;
    [self.seachArr removeAllObjects];
    for (DLFriendsInfo *info in self.dataArr) {
        if ([info.name containsString:nickName]) {
            [self.seachArr addObject:info];
        }
    }
    [self.tableView reloadData];
}

- (void)checkYourSelfNewFriends {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLMyNewFriendsTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLMyNewFriendsTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)cancleSearchFriends {
    self.isSeach = NO;
    [self.tableView reloadData];
}
#pragma mark - 网络请求
- (void)dl_networkForGetFriendsList {
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/myFriends",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        DLFriendsModel *friendsModel = [DLFriendsModel modelWithJSON:response];
        if ([friendsModel.code integerValue] == 1) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:friendsModel.data];
            NSMutableArray *temp = [NSMutableArray array];
            for (DLFriendsInfo *model in friendsModel.data) {
                RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:model.fid name:model.name portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg]];
                [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:model.fid];
                
                [temp addObject:info];
            }
            [[RCDataBaseManager shareInstance] insertUserListToDB:temp];
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
- (NSMutableArray *)seachArr {
    if (!_seachArr) {
        _seachArr = [NSMutableArray array];
    }
    return _seachArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshFriendsListNoticationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHandleRequestNotificationName object:nil];
}

@end
