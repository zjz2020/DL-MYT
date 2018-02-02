//
//  DLGroupMemberTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
// 群成员界面

#import "DLGroupMemberTableViewController.h"
#import "DLGroupMemberCell.h"
#import "DLGroupManagerTableViewController.h"
#import "DLFriendsModel.h"
#import "DLGroupMemberModel.h"
#import "DltUICommon.h"
#import "RCHttpTools.h"
#import "DLUserInfDetailViewController.h"
#import "NSString+PinYin.h"
#import <MJRefresh/MJRefresh.h>

@interface DLGroupMemberTableViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *sectionDic;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) DLGroupMemberInfo *infoModel;
//将群成员分组
@property (nonatomic, strong)NSMutableDictionary *friendsList;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchArray;

//所有的成员数组
@property (nonatomic, strong) NSMutableArray *allMembers;
@end

@implementation DLGroupMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self dl_networkForGetGroupMembers];
    self.title = _NTitle;
    [self makeTableViewSet];
}
- (void)makeTableViewSet{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(makeMJRefresh)];
}
#pragma mark -UI
- (void)initUI {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width , 55);
    headerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    self.tableView.tableHeaderView = headerView;
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, 12.5, self.view.frame.size.width - 60, 30);
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    backView.layer.masksToBounds = YES;
    [headerView addSubview:backView];
    
    UIImageView *seach = [[UIImageView alloc] init];
    seach.frame = CGRectMake(10, 5, 20, 20);
    seach.image = [UIImage imageNamed:@"friend_02"];
    [backView addSubview:seach];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(CGRectGetMaxX(seach.frame) + 10, 0, backView.frame.size.width - 50, 30);
    textField.placeholder = @"群成员搜索";
    textField.font = [UIFont systemFontOfSize:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField = textField;
    _textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    [backView addSubview:textField];
}
//mj刷新
- (void)makeMJRefresh{
    _isSearch = NO;
    [self dl_networkForGetGroupMembers];
}
#pragma mark - tableView/ delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isSearch?1:3 + self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return self.searchArray.count;
    }
    switch (section) {
        case 0: {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"群主"];
            return temp.count;
        }
            break;
        case 1: {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"管理员"];
            return temp.count;
        } case 2 : {
//            NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
//            return temp.count;
            return 0;
        }
            break;
        default: {
            NSString *key = self.listArray[section - 3];
            NSMutableArray *array = [self.friendsList objectForKey:key];
            return array.count;
        }
            break;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *newArray = [NSMutableArray arrayWithObjects:@"群主",@"管理员",@"成员", nil];
    [newArray addObjectsFromArray:self.listArray];
    if (_isSearch) {
        return @[];
    }
//    return self.listArray;
    return self.listArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableArray *newArray = [NSMutableArray arrayWithObjects:@"群主",@"管理员",@"成员", nil];
    [newArray addObjectsFromArray:self.listArray];
    
    return _isSearch?@"搜索到":newArray[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   DLGroupMemberCell *cell = [DLGroupMemberCell creatGroupMemberCellWith:tableView];
    if (_isSearch) {
        cell.infoModel = self.searchArray[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: {
                NSMutableArray *temp = [self.sectionDic objectForKey:@"群主"];
                cell.infoModel = temp[indexPath.row];
            }
                break;
            case 1: {
                NSMutableArray *temp = [self.sectionDic objectForKey:@"管理员"];
                cell.infoModel = temp[indexPath.row];
            }
                break;
            case 2: {
                NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
                cell.infoModel = temp[indexPath.row];
            }
                break;
            default: {
                NSString *key = self.listArray[indexPath.section - 3];
                NSMutableArray *array = [self.friendsList objectForKey:key];
                //            NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
                cell.infoModel = array[indexPath.row];
            }
                break;
        }
    }
    cell.headImgBlock = ^(DLGroupMemberInfo *info) {
        DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
        vc.otherUserId = info.Uid;
        [self.navigationController pushViewController:vc animated:YES];
    };
   return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isSearch) {
        return 40;
    }
    if (section > 2) {
        return 20;
    }
    return 40;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    sectionView.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
//    [sectionView addSubview:label];
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, self.view.frame.size.width, 0.5)];
//    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
//    [sectionView addSubview:line];
//
//    switch (section) {
//        case 0:
//            label.text = @"群主";
//            break;
//        case 1:
//            label.text = @"管理员";
//            break;
//        default:
//            label.text = @"成员";
//            break;
//    }
//    return sectionView;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        
    } else {
        
    }
    if (!self.isManager) {
        if (indexPath.section == 0) {
            [DLAlert alertWithText:@"你已经是群主了"];
            return;
        }
        if (indexPath.section == 1) {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"管理员"];
            DLGroupMemberInfo *info = temp[indexPath.row];
            [self showAlert:[NSString stringWithFormat:@"转让给%@后，你将失去群主身份",info.Remrk]];
            self.targetId = info.Uid;
            return;
        }
        if (indexPath.section >= 2) {
//            NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
            NSString *key = self.listArray[indexPath.section - 3];
            NSMutableArray *temp = [self.friendsList objectForKey:key];
            DLGroupMemberInfo *info = temp[indexPath.row];
            [self showAlert:[NSString stringWithFormat:@"转让给%@后，你将失去群主身份",info.Remrk]];
            self.targetId = info.Uid;
            return;
        }
        return;
    }
    
    if (self.isSearch) {
        self.infoModel = self.searchArray[indexPath.row];
        NSInteger num = [self.infoModel.Role integerValue];
        NSString *oneStr = @"";
        switch (num) {
            case 1: {//成员
                oneStr = @"设置管理员";
                if (_isAdmin) {
                    [self showUiAction:@"移除成员" twoStr:nil];
                }
            }
                break;
            case 2: {//管理员
                oneStr = @"取消管理员";
            }
                break;
                
            default: {//群主
                
            }
                break;
        }
        if (_isMainGrouper) {
            [self showUiAction:oneStr twoStr:@"移除成员"];
        }
    } else {
        if (indexPath.section == 0) return;
        NSMutableArray *temp;
        NSString *oneStr;
        if (indexPath.section == 1) {
            temp = [self.sectionDic objectForKey:@"管理员"];
            oneStr = @"取消管理员";
        } else {
            //        temp = [self.sectionDic objectForKey:@"成员"];
            NSString *key = self.listArray[indexPath.section - 3];
            temp = [self.friendsList objectForKey:key];
            oneStr = @"设置管理员";
            if (_isAdmin) {
                [self showUiAction:@"移除成员" twoStr:nil];
            }
        }
        self.infoModel = temp[indexPath.row];
        if (_isMainGrouper) {
            [self showUiAction:oneStr twoStr:@"移除成员"];
        }
    }
    
}
-(void)showUiAction:(NSString *)oneStr twoStr:(NSString *)twoStr{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"群成员设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:oneStr,twoStr, nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (_isAdmin) {
            @weakify(self)
            
            [[RCHttpTools shareInstance] removeGroupMembersByGroupId:self.groupId toUser:self.infoModel.Uid handle:^(BOOL isSuccess) {
                
                @strongify(self)
                if (isSuccess) {
                    
                    [DLAlert alertWithText:@"移除成功"];
                    [self dl_networkForGetGroupMembers];
                }
            }];
            return;
        }
        if ([self.infoModel.Role integerValue] == 2) {
            @weakify(self)
            [[RCHttpTools shareInstance] groupMgrCancleManagerByGroupId:self.groupId toUser:self.infoModel.Uid handle:^(BOOL isSuccess) {
                @strongify(self)
                if (isSuccess) {
                    [DLAlert alertWithText:@"设置成功"];
                    [self dl_networkForGetGroupMembers];
                }
            }];
            return;
        }
        @weakify(self)
        [[RCHttpTools shareInstance] setGroupManagerByGroupId:self.groupId toUser:self.infoModel.Uid handle:^(BOOL isSuccess) {
            @strongify(self)
            if (isSuccess) {
                [DLAlert alertWithText:@"设置成功"];
                [self dl_networkForGetGroupMembers];
            }
        }];
        return;
    }
    if (buttonIndex == 1) {
        if (_isMainGrouper) {
            @weakify(self)
            
            [[RCHttpTools shareInstance] removeGroupMembersByGroupId:self.groupId toUser:self.infoModel.Uid handle:^(BOOL isSuccess) {
                
                @strongify(self)
                if (isSuccess) {
                    
                    [DLAlert alertWithText:@"移除成功"];
                    [self dl_networkForGetGroupMembers];
                }
            }];
            return;
        }
        
    }
}


- (void)dl_networkForGetGroupMembers {
    NSString *url = [NSString stringWithFormat:@"%@Group/groupMembers",BASE_URL];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"groupId" : self.groupId
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        DLGroupMemberModel *model = [DLGroupMemberModel modelWithJSON:response];
        if ([model.code integerValue] == 1) {
            NSMutableArray *temp1 = [self.sectionDic objectForKey:@"成员"];
            NSMutableArray *temp2 = [self.sectionDic objectForKey:@"管理员"];
            NSMutableArray *temp3 = [self.sectionDic objectForKey:@"群主"];
            [temp1 removeAllObjects];
            [temp2 removeAllObjects];
            [temp3 removeAllObjects];
            for (DLGroupMemberInfo *info in model.data) {
                switch ([info.Role intValue]) {
                    case 1: {
                        [temp1 addObject:info];
                    }
                        break;
                    case 2: {
                        [temp2 addObject:info];
                    }
                        break;
                    default: {
                        [temp3 addObject:info];
                    }
                        break;
                }
            }
        }
        NSMutableArray *members = [self.sectionDic objectForKey:@"成员"];
        [self makeMembesListWithArray:members];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } progress:nil];
}
//将所有成员放入数组
- (void)makeAllMembersToArray{
    [self.allMembers removeAllObjects];
    NSMutableArray *temp1 = [self.sectionDic objectForKey:@"成员"];
    NSMutableArray *temp2 = [self.sectionDic objectForKey:@"管理员"];
    NSMutableArray *temp3 = [self.sectionDic objectForKey:@"群主"];
    for (DLGroupMemberInfo *info in temp1) {
        info.firstLetter = [NSString getFirstNameWithText:info.Remrk];
    }
    for (DLGroupMemberInfo *info in temp2) {
        info.firstLetter = [NSString getFirstNameWithText:info.Remrk];
    }
    for (DLGroupMemberInfo *info in temp3) {
        info.firstLetter = [NSString getFirstNameWithText:info.Remrk];
    }
    [self.allMembers addObjectsFromArray:temp1];
    [self.allMembers addObject:temp2];
    [self.allMembers addObject:temp3];
}
//处理成员数据
- (void)makeMembesListWithArray:(NSArray *)membes{
     [self makeAllMembersToArray];
    [self.friendsList removeAllObjects];
    [self.listArray removeAllObjects];
    for (DLGroupMemberInfo *info in membes) {
        info.firstLetter = [NSString getFirstNameWithText:info.Remrk];
    }
    for (DLGroupMemberInfo *friendInfo in membes) {
        if ([self.friendsList.allKeys containsObject:friendInfo.firstLetter]) {//包含  添加到mArray;
            NSMutableArray *gFriendArray = [self.friendsList objectForKey:friendInfo.firstLetter];
            [gFriendArray addObject:friendInfo];
        } else {
            NSMutableArray *mArray = [NSMutableArray new];
            [mArray addObject:friendInfo];
            [self.friendsList setObject:mArray forKey:friendInfo.firstLetter];
        }
    }
    self.listArray = [[[self.friendsList allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
}
- (void)showAlert:(NSString *)subMsg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"转让" message:subMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (ISNULLSTR(self.targetId)) return;
        [[RCHttpTools shareInstance] transferGrouperByGroupId:self.groupId toUser:self.targetId handle:^(BOOL isSuccess) {
            if (isSuccess) {
                [DLAlert alertWithText:@"转让成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _isSearch = YES;
    [textField resignFirstResponder];
    
    self.isSearch = ISNULLSTR(textField.text) ? NO : YES;
    [self.searchArray removeAllObjects];
    for (DLGroupMemberInfo *info in self.allMembers) {
        if ([info isKindOfClass:[NSArray class]]) {
            NSArray *list = (NSArray *)info;
            DLGroupMemberInfo *memberInfo = [list firstObject];
            if ([memberInfo.Remrk containsString:textField.text]) {
                [self.searchArray addObject:memberInfo];
            } else if ([[NSString getStringNameWithHYName:info.Remrk] containsString:textField.text]  && ![self.searchArray containsObject:info]){
                [self.searchArray addObject:info];
            }
        } else {
            if ([info.Remrk containsString:textField.text]) {
                [self.searchArray addObject:info];
            } else if ([[NSString getStringNameWithHYName:info.Remrk] containsString:textField.text]  && ![self.searchArray containsObject:info]){
                [self.searchArray addObject:info];
            }
        }
        
    }
    if (self.searchArray.count == 0) {
        self.isSearch = NO;
        [DLAlert alertWithText:@"没有搜索到成员"];
    }
    [self.tableView reloadData];
    
    return YES;
}


#pragma mark 群组管理
- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray new];
    }
    return _searchArray;
}
- (NSMutableDictionary *)friendsList {
    if (!_friendsList) {
        _friendsList = [NSMutableDictionary dictionary];
    }
    return _friendsList;
}
- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)allMembers {
    if (!_allMembers) {
        _allMembers = [NSMutableArray new];
    }
    return _allMembers;
}

- (NSMutableDictionary *)sectionDic {
    if (!_sectionDic) {
        _sectionDic = [NSMutableDictionary dictionary];
        [_sectionDic setObject:[NSMutableArray array] forKey:@"群主"];
        [_sectionDic setObject:[NSMutableArray array] forKey:@"管理员"];
        [_sectionDic setObject:[NSMutableArray array] forKey:@"成员"];
    }
    return _sectionDic;
}

@end
