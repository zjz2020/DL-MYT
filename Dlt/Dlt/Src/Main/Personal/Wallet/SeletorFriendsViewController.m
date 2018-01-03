//
//  SeletorFriendsViewController.m
//  Dlt
//
//  Created by USER on 2017/6/2.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SeletorFriendsViewController.h"
#import "DLSeachPeopleCell.h"
#import "SelectorView.h"
#import "DLShowMyQRCodeView.h"
#import "DLFriendsModel.h"
#import "DltUICommon.h"
#import "ConversationViewController.h"
#import "TransferViewController.h"


#define kAddBtnTag     1000
#define kHeaderViewH   55
@interface SeletorFriendsViewController ()<DLSeachPeopleHeadViewDelegate,DLSeachPeopleCellDelegate>
@property(nonatomic, strong) UISearchController *seleCtorbar;
@property (nonatomic, strong) NSMutableArray *dataArr;

//账号
@property (nonatomic, copy) NSString *accountNumber;
@end

@implementation SeletorFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SelectorView *headView = [[SelectorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewH)];
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLSeachPeopleCell *peopleCell = [DLSeachPeopleCell creatSeachPeopleCellWithTableView:tableView];
    peopleCell.addBtn.tag = indexPath.row + kAddBtnTag;
    peopleCell.delegate = self;
    peopleCell.infoModel = self.dataArr[indexPath.row];
    return peopleCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLFriendsInfo *info = self.dataArr[indexPath.row];
    if (info.isFriend) {
//        ConversationViewController *conversation = [[ConversationViewController alloc] init];
//        conversation.conversationType = ConversationType_PRIVATE;
//        conversation.targetId = info.fid;
//        conversation.hidesBottomBarWhenPushed = YES;
//        conversation.title = info.name;
//        [self.navigationController pushViewController:conversation animated:YES];
        TransferViewController * trans = [[TransferViewController alloc]init];
        trans.friendsName = info.name;
        trans.toid = info.fid;
        NSString * str =[NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg];
        trans.heardimage = str;
        [self.navigationController pushViewController:trans animated:YES];
    } else {
        [self dl_networkForAddNewFriendsWithFriendId:info.fid];
    }
}
/// 添加好友
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
        [self showMessageWarningWithMessage:response[@"msg"]];
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@",error);
    } progress:nil];
}
- (void)seachPeopleHeadView:(SelectorView *)headView seachWithPhoneNumber:(NSString *)phoneNumber {
    [self dl_networkSeachPeopleWithPhoneNumber:phoneNumber];
}
- (void)seachPeopleCell:(DLSeachPeopleCell *)seachCell clickAddFriendWithIndx:(NSInteger)indx {
    DLFriendsInfo *info = self.dataArr[indx - kAddBtnTag];
    if (info.isFriend) {
         //去聊天
        ConversationViewController *conversation = [[ConversationViewController alloc] init];
        conversation.conversationType = ConversationType_PRIVATE;
        conversation.targetId = info.fid;
        conversation.hidesBottomBarWhenPushed = YES;
        conversation.title = info.name;
        [self.navigationController pushViewController:conversation animated:YES];
        

        
        
    }
//    [self dl_networkForAddNewFriendsWithFriendId:info.fid];
}
/// 搜索好友
- (void)dl_networkSeachPeopleWithPhoneNumber:(NSString *)phoneNumber {
    NSString *url = [NSString stringWithFormat:@"%@userCenter/searchUser",BASE_URL];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid,
                             @"friendAccount" : phoneNumber
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        DLFriendsModel *model = [DLFriendsModel modelWithJSON:response];
        if ([model.code isEqualToString:@"1"]) {
            [self.dataArr removeAllObjects];
            self.accountNumber = phoneNumber;
            [self.dataArr addObjectsFromArray:model.data];
        } else {
            [self showMessageWarningWithMessage:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

// alert
- (void)showMessageWarningWithMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UISearchController *)seleCtorbar
//{
//    if (_seleCtorbar ==nil) {
//        _seleCtorbar = [[UISearchController alloc]initWithSearchResultsController:nil];
//        
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
