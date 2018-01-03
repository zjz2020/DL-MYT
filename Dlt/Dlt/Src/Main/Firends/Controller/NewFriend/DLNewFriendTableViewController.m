//
//  DLNewFriendTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLNewFriendTableViewController.h"
#import "DLNewFriendCell.h"
#import "DLOtherUserModel.h"
#import "DLSeachViewController.h"
#import "UIViewController+DltUI.h"
#import "RCHttpTools.h"
#import "DltUICommon.h"

static NSString * const kRequestRecord = @"RequestRecord";


@interface DLNewFriendTableViewController ()<DLNewFriendCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) DLTUserProfile *userInfo;
@end

@implementation DLNewFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"群加入";
    [self back];
    [self rightItem:@"friends_32"];
    self.tableView.tableFooterView = [UIView new];
    @weakify(self)
    [[RCHttpTools shareInstance] getOtherUserInfoByUserId:self.requestUserId handle:^(DLTUserProfile *userInfo) {
        @strongify(self)
        self.userInfo = userInfo;
        [self.tableView reloadData];
    }];
}

- (void)back {
    UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"friends_15"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftitem;
}
- (void)backclick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLNewFriendCell *cell = [DLNewFriendCell creatNewFriendCellWithTableView:tableView];
    cell.agreeBtn.tag = 1000 + indexPath.row;
    cell.refuseBtn.tag = 10000 + indexPath.row;
    cell.delegate = self;
    if (self.isGroupRequest) {
        cell.detail.text = [NSString stringWithFormat:@"申请加入群[%@]",self.groupName];
    }
    cell.nickName.text = self.userInfo.userName;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,self.userInfo.userHeadImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    BOOL isFinish = [[NSUserDefaults standardUserDefaults] boolForKey:self.requestUserId];
    if (isFinish) {
        [cell.agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
        cell.agreeBtn.hidden = YES;
        cell.refuseBtn.hidden = YES;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}

// 点击➕号 添加好友
- (void)rightclick {
    DLSeachViewController *seachVC = [[DLSeachViewController alloc] init];
    seachVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seachVC animated:YES];
   
}

- (void)dl_friendCell:(DLNewFriendCell *)cell clickButtonWithTag:(NSInteger)tag {
    if (self.isGroupRequest) {
        NSString *code;
        if (tag >= 10000) {
            code = @"201";
        } else {
            code = @"200";
        }
        [DLAlert alertShowLoad];
        @weakify(self)
    
        [[RCHttpTools shareInstance] handleGroupRequestByRequestId:self.recordId stateCode:code handle:^(NSString *operation) {
             @strongify(self)
            if ([operation isEqualToString:@"YES"]) {
                                [DLAlert alertWithText:@"操作成功"];
                                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                [user setBool:YES forKey:self.requestUserId];
                                [user synchronize];
                                [self.tableView reloadData];
                                [self backclick];
            }else if ([operation isEqualToString:@"该用户已经是群成员了"]){
                [DLAlert alertWithText:operation];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setBool:YES forKey:self.requestUserId];
                [user synchronize];
                [self.tableView reloadData];
                [self backclick];
            }else{
                [DLAlert alertWithText:operation];
            }
        }];
        return;
    }
    if (tag >= 10000) {
        [self dl_networkForAddFriendsWithCode:@"201"];
    } else {
        [self dl_networkForAddFriendsWithCode:@"200"];
    }
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)dl_networkForAddFriendsWithCode:(NSString *)code {
    
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/addFriendResponse",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"requestId" : self.recordId,
                             @"code" : code
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        [self showHUD:response[@"msg"] block:NO];
        if ([response[@"code"] integerValue] == 1) {
            [self.tableView reloadData];
            [self backclick];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

@end
