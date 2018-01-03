//
//  DLChooseFriendsTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLChooseFriendsTableViewController.h"
#import "DLFriendsCell.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"
#import "RCHttpTools.h"
#import "DLTransferAccountsTableViewController.h"

@interface DLChooseFriendsTableViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *seachArr;
@property (nonatomic, assign) BOOL isSeach;
@end

@implementation DLChooseFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择好友";
    
    self.tableView.tableFooterView = [UIView new];
    self.isSeach = NO;
    
    self.tableView.tableHeaderView = [self creatSeachHeadView];
    
    
    // 获取好友列表
    [self dl_networkForGetFriendsList];

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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLTransferAccountsTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLTransferAccountsTableViewController"];
    vc.friendsInfo = userInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
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

#pragma mark - UI
- (UIView *)creatSeachHeadView {
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 55)];
    head.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(30, 12.5, head.frame.size.width - 60, 30)];
    [head addSubview:backView];
    [backView ui_setCornerRadius:6 withBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageV.image = [UIImage imageNamed:@"friend_seach"];
    [backView addSubview:imageV];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 10, 0, backView.frame.size.width - 40, 30)];
    textField.placeholder = @"搜索好友";
    textField.font = [UIFont systemFontOfSize:12];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:textField];
    
    return head;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (ISNULLSTR(textField.text)) {
        self.isSeach = NO;
        [self.tableView reloadData];
        return YES;
    }
    [self.seachArr removeAllObjects];
    for (DLFriendsInfo *info in self.dataArr) {
        if ([info.name containsString:textField.text]) {
            [self.seachArr addObject:info];
        }
    }
    self.isSeach = YES;
    [self.tableView reloadData];
    return YES;
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
