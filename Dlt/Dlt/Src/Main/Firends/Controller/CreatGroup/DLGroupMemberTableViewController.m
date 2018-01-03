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


@interface DLGroupMemberTableViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *sectionDic;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) DLGroupMemberInfo *infoModel;
@end

@implementation DLGroupMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self dl_networkForGetGroupMembers];
    
    self.tableView.tableFooterView = [UIView new];
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
    self.textField = textField;
    textField.returnKeyType = UIReturnKeySearch;
    [backView addSubview:textField];
}

#pragma mark - tableView/ delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"群主"];
            return temp.count;
        }
            break;
        case 1: {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"管理员"];
            return temp.count;
        }
            break;
        default: {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
            return temp.count;
        }
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   DLGroupMemberCell *cell = [DLGroupMemberCell creatGroupMemberCellWith:tableView];
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
        default: {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
            cell.infoModel = temp[indexPath.row];
        }
            break;
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
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    [sectionView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [sectionView addSubview:line];
    
    switch (section) {
        case 0:
            label.text = @"群主";
            break;
        case 1:
            label.text = @"管理员";
            break;
        default:
            label.text = @"成员";
            break;
    }
    return sectionView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        if (indexPath.section == 2) {
            NSMutableArray *temp = [self.sectionDic objectForKey:@"成员"];
            DLGroupMemberInfo *info = temp[indexPath.row];
            [self showAlert:[NSString stringWithFormat:@"转让给%@后，你将失去群主身份",info.Remrk]];
            self.targetId = info.Uid;
            return;
        }
        return;
    }
    if (indexPath.section == 0) return;
    NSMutableArray *temp;
    NSString *oneStr;
    if (indexPath.section == 1) {
      temp = [self.sectionDic objectForKey:@"管理员"];
        oneStr = @"取消管理员";
    } else {
        temp = [self.sectionDic objectForKey:@"成员"];
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
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
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
