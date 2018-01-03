//
//  DLSeachGroupsTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLSeachGroupsTableViewController.h"
#import "DLSeachGroupsCell.h"
#import "DLSeachPeopleHeadView.h"
#import "DltUICommon.h"
#import "DLGroupsModel.h"
#import "DLCreatGroupViewController.h"
#import "ConversationViewController.h"
#import "DLGroupDetailViewController.h"

#define kHeaderViewH   119
#define kEnterBtnTag   1000


@interface DLSeachGroupsTableViewController ()<DLSeachPeopleHeadViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation DLSeachGroupsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DLSeachPeopleHeadView *headView = [[DLSeachPeopleHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewH)];
    headView.isSeachPeople = NO;
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
    DLSeachGroupsCell *peopleCell = [DLSeachGroupsCell creatSeachGroupCellWithTableView:tableView];
    peopleCell.infoModel = self.dataArr[indexPath.row];
    return peopleCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLGroupsInfo *info = self.dataArr[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLGroupDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupDetailViewController"];
    vc.groupsInfo = info;
    vc.isJoined = info.isMember;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 自定义delegate
- (void)seachPeopleHeadView:(DLSeachPeopleHeadView *)headView seachWithPhoneNumber:(NSString *)phoneNumber {
    [self dl_networkForSeachGroupsByParams:phoneNumber];
}
- (void)seachPeopleHeadViewToShowMyQRCode {
    DLCreatGroupViewController *groupVC = [[DLCreatGroupViewController alloc] init];
    [self.navigationController pushViewController:groupVC animated:YES];
}

#pragma mark - 网络请求
- (void)dl_networkForSeachGroupsByParams:(NSString *)groupParams {
    if (ISNULLSTR(groupParams)) {
        [self.dataArr removeAllObjects];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@Group/serachGroups",BASE_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    params[@"token"] = [DLTUserCenter userCenter].token;
    params[@"uid"] = user.uid;
    if ([self deptNumInputShouldNumber:groupParams]) {
        params[@"groupId"] = groupParams;
    } else {
        params[@"groupName"] = groupParams;
    }
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        DLGroupsModel *model = [DLGroupsModel modelWithJSON:response];
        if ([model.code isEqualToString:@"1"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:model.data];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


// 判断字符串时候为纯数字
- (BOOL)deptNumInputShouldNumber:(NSString *)str {
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
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

@end
