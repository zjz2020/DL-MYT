//
//  DLMyFriendsListViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <RongContactCard/RongContactCard.h>
#import "DLMyFriendsListViewController.h"
#import "DLFriendsCell.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"
#import "RCHttpTools.h"
#import "DLContactCardView.h"


NSString * const kSendContactCardMessageNotificationName = @"SendContactCardMessageNotificationName";

@interface DLMyFriendsListViewController ()<DLContactCardViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *seachArr;
@property (nonatomic, assign) BOOL isSeach;

@end

@implementation DLMyFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    
    self.tableView.tableFooterView = [UIView new];
    self.isSeach = NO;
    
    // 获取好友列表
    [self dl_networkForGetFriendsList];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"friends_15"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftitem;
}

- (void)backclick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return friendsCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLFriendsInfo *userInfo = self.isSeach ? self.seachArr[indexPath.row] : self.dataArr[indexPath.row];
    
    DLContactCardView *cardView = [DLContactCardView shareInstance];
    cardView.delegate = self;
    cardView.userInfo = userInfo;
    cardView.senderName = self.model.userName;
    [cardView popAnimationView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 自定义delegate
- (void)contactCardView:(UIView *)cardView sendFriendCardToOtherWithUserInfo:(DLFriendsInfo *)userInfo andTheNote:(NSString *)note {
    if (ISNULLSTR(note)) {
        note = @"";
    }
    RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:self.otherUserId name:self.model.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,self.model.userHeadImg]];
    NSDictionary * dic = @{
                           @"userInfo" : info,
                           @"note" : note,
                           @"accepterId" : userInfo.fid
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendContactCardMessageNotificationName object:nil userInfo:dic];
    
    [self backclick];
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
                [temp addObject:info];
            }
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
@end
