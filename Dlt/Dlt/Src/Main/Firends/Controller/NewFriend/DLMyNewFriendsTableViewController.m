//
//  DLMyNewFriendsTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLMyNewFriendsTableViewController.h"
#import "DLMyNewFriendsCell.h"
#import "DLTUserCenter.h"
#import "DLMyNewFriendModel.h"
#import "DltUICommon.h"
#import "DLUserInfDetailViewController.h"


NSString * const kHandleRequestNotificationName = @"HandleRequestNotificationName";

@interface DLMyNewFriendsTableViewController ()<DLMyNewFriendsCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DLMyNewFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dl_networkForMyNewFriendsRecord];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return self.dataArr.count;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLMyNewFriendsCell *cell = [DLMyNewFriendsCell creatCellWithTableView:tableView];
    cell.infoModel = self.dataArr[indexPath.section];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    }
    return 0;
}

#pragma mark - 网络请求
- (void)dl_networkForMyNewFriendsRecord {
    [DLAlert alertShowLoad];
    DLTUserCenter *user = [DLTUserCenter userCenter];
    NSDictionary *params = @{
                             @"uid" : user.curUser.uid,
                             @"token" : [DLTUserCenter userCenter].token
                             };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/newFriendsRecord",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [self.dataArr removeAllObjects];
            NSArray *models = response[@"data"];
            int nub = 10;
            if (models.count > nub) {
                for (int i = 0; i < nub; i++) {
                    DLMyNewFriendModel *model = [DLMyNewFriendModel modelWithJSON:models[i]];
                    [self.dataArr addObject:model];
                }
            }else{
                for (NSDictionary *dic in models) {
                    DLMyNewFriendModel *model = [DLMyNewFriendModel modelWithJSON:dic];
                
                    [self.dataArr addObject:model];
                }
            }
            
            [DLAlert alertHideLoad];
            [self.tableView reloadData];
        }else{
            [DLAlert alertWithText:response[@"msg"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)dl_networkForAddFriendsWithCode:(NSString *)code andReuestId:(NSString *)requestId {
    [DLAlert alertShowLoad];
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/addFriendResponse",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"requestId" : requestId,
                             @"code" : code
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        if ([response[@"code"] integerValue] == 1) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [DLAlert alertWithText:@"操作成功"];
               [self dl_networkForMyNewFriendsRecord];
               [[NSNotificationCenter defaultCenter] postNotificationName:kHandleRequestNotificationName object:nil];
           });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"操作失败"];
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

#pragma mark - 自定义delegate
/// 拒绝
- (void)myNewFriendCell:(DLMyNewFriendsCell *)cell clickRefuseButtonWtihModel:(DLMyNewFriendModel *)model {
    [self dl_networkForAddFriendsWithCode:@"201" andReuestId:model.requestId];
}

/// 同意
- (void)myNewFriendCell:(DLMyNewFriendsCell *)cell clickRAgreeButtonWtihModel:(DLMyNewFriendModel *)model {
     [self dl_networkForAddFriendsWithCode:@"200" andReuestId:model.requestId];
}

- (void)myNewFriendCell:(DLMyNewFriendsCell *)cell clickHeadImageSeeUserInfomation:(DLMyNewFriendModel *)model {
    DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
    vc.otherUserId = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHandleRequestNotificationName object:nil];
}
@end
