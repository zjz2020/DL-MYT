//
//  DLFriendsSetTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLFriendsSetTableViewController.h"
#import "DLFriendsModel.h"
#import "ConversationViewController.h"
#import "DltUICommon.h"
#import "UINavigationBar+Awesome.h"
#import <RongContactCard/RongContactCard.h>
#import "DLMyFriendsListViewController.h"
#import "BaseNC.h"

NSString * const kRefreshFriendsListNoticationName = @"RefreshFriendsListNoticationName";

static NSString * const kFriendSetTableViewCellId = @"FriendSetTableViewCellId";


@interface DLFriendsSetTableViewController ()<
  UIAlertViewDelegate,
  UITableViewDelegate,
  UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISwitch *otherSwitch;
@property (nonatomic, strong) UISwitch *mySwitch;

@end

@implementation DLFriendsSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友设置";
//  [RCContactCardKit shareInstance].contactsDataSource = RCDDataSource;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
   
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kFriendSetTableViewCellId];
    
    [self dl_networkForSeeFriendInfo];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(0);
        make.left.right.mas_equalTo(self.view).with.offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 4;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        }
            break;
        case 1: {
            return 2;
        }
            break;
        case 2: {
            return 1;
        }
            break;
        default: {
            return 2;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendSetTableViewCellId];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"444444"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = @"设置备注名";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"不看对方的朋友圈";
                [cell.contentView addSubview:self.otherSwitch];
            } else {
                cell.textLabel.text = @"不让对方看我的朋友圈";
                [cell.contentView addSubview:self.mySwitch];
            }
        }
            break;
        case 2: {
            cell.textLabel.text = @"发送该名片";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default: {
            if (indexPath.row == 0) {
            cell.textLabel.text = @"删除好友";
            }else{
                if (_isBlackFriend) {
                    cell.textLabel.text = @"取消拉黑";
                }else{
                    cell.textLabel.text = @"拉黑好友";
                }
            
            }
        }
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            /// 设置备注名
            [self setRemarksName];
        }
            break;
        case 1: {
    
        }
            break;
        case 2: {
            /// 发送名片
            [self sendThisFriendNameCard];
        }
            break;
        case 3: {
            if (indexPath.row == 0) {
                /// 删除该好友
                [self deleteThisFriend];
            }else{
                //拉黑
                [self pullTheBlack];
            }
            
        }
            break;
        default: {
            /// 发起聊天
            [self initiateChat];
        }
            break;
    }
}

/// 设置备注名
- (void)setRemarksName {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置备注名" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请备注名称";
    [alert show];
}

/// 发送名片
- (void)sendThisFriendNameCard {
    DLMyFriendsListViewController *listVC = [DLMyFriendsListViewController new];
    listVC.model = self.model;
    listVC.otherUserId = self.otherUserId;
    BaseNC *navi = [[BaseNC alloc] initWithRootViewController:listVC];
    [self presentViewController:navi animated:YES completion:nil];
}


/// 删除该好友
- (void)deleteThisFriend {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确定删除该好友" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    [alertView show];
}
//拉黑
-(void)pullTheBlack{
    if (_isBlackFriend) {
        [self cancleBlkack];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确定拉黑该好友" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 520;
        [alertView show];

    }}
//取消拉黑
-(void)cancleBlkack{

    [DLAlert alertShowLoad];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"targetId"   : self.otherUserId,
                          
                          };
    NSString *url = [NSString stringWithFormat:@"%@usercenter/cancleBlack",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        
                if ([response[@"code"] integerValue] == 1) {
        
                                dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                    [DLAlert alertWithText:[response valueForKey:@"msg"]];
                                     NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:3];
                                    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
                                    cell.textLabel.text = @"拉黑好友";
                                    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                                    [center postNotificationName:@"RELOASBLACKXELLCENTER" object:nil];
                                   
                                    
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [DLAlert alertWithText:@"操作失败"];
                                });
               }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];
    
}


/// 发起聊天
- (void)initiateChat {
    
}

#pragma mark - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self dl_networkForDeleteFriend];
        }
        return;
    }
    if (alertView.tag == 520) {
        if (buttonIndex == 1) {
            
            [self pullBlack];
        }
        return;
    }

    if (buttonIndex == 1) {
         UITextField *txt = [alertView textFieldAtIndex:0];
        if (ISNULLSTR(txt.text)) {
            [DLAlert alertWithText:@"请输入备注名"];
            return;
        }
        [self dl_networkForSetReamrksWithNewRemark:txt.text];
    }
}
//点击拉黑好友
-(void)pullBlack{
    [DLAlert alertShowLoad];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"targetId"   : self.otherUserId,
                         
                          };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/pullBlack",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
                 if ([response[@"code"] integerValue] == 1) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:[response valueForKey:@"msg"]];
                NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:3];
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
                cell.textLabel.text = @"取消拉黑";
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"RELOASBLACKXELLCENTER" object:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置失败"];
            });
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];

}
#pragma mark -网络请求

/// 修改备注
- (void)dl_networkForSetReamrksWithNewRemark:(NSString *)remark {
    [DLAlert alertShowLoad];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"fid"   : self.otherUserId,
                          @"remark": remark
                          };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/modifyFriendRemark",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshFriendsListNoticationName object:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置失败"];
            });
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];
}

/// 不看他的动态
- (void)dl_networkForDidNotSeeDynamic:(BOOL)switchOn {
    [DLAlert alertShowLoad];
    NSString *status = switchOn ? @"0" : @"1";
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"status"   : status,
                          @"fid"   : self.otherUserId
                          };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/notseefriendArticle",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置成功"];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置失败"];
            });
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];
}
/// 不让他看我的动态
- (void)dl_networkForDidNotSeeMyDynamic:(BOOL)switchOn {
    [DLAlert alertShowLoad];
    NSString *status = switchOn ? @"0" : @"1";
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"status"   : status,
                          @"fid"   : self.otherUserId
                          };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/notGetfriendArticle",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置成功"];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"设置失败"];
            });
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];
}

/// 删除好友
- (void)dl_networkForDeleteFriend {
    [DLAlert alertShowLoad];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"toId"   : self.otherUserId,
                          };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/delFriend",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_PRIVATE targetId:self.otherUserId success:^{
                   dispatch_async(dispatch_get_main_queue(), ^{
                      [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearHistoryMsg" object:nil];
                       [DLAlert alertWithText:@"删除成功"];
                   });
                } error:^(RCErrorCode status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [DLAlert alertWithText:@"删除失败"];
                    });
                }];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"删除失败"];
            });
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];
}

/// 查看好友状态
- (void)dl_networkForSeeFriendInfo {
    [DLAlert alertShowLoad];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"fid"   : self.otherUserId,
                          };
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/friendInfo",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        NSLog(@"%@",response);
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mySwitch.on = ([response[@"data"][@"isGetSee"] integerValue] == 0) ? YES : NO;
                self.otherSwitch.on = ([response[@"data"][@"isSee"] integerValue] == 0) ? YES : NO;
            });
        }
        [DLAlert alertHideLoad];
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];
}




- (void)otherSwitchAction:(UISwitch *)sender {
    [self dl_networkForDidNotSeeDynamic:sender.on];
}
- (void)mySwitchAction:(UISwitch *)sender {
    [self dl_networkForDidNotSeeMyDynamic:sender.on];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshFriendsListNoticationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClearHistoryMsg" object:nil];
}

#pragma mark - 懒加载
- (UISwitch *)otherSwitch {
    if (!_otherSwitch) {
        _otherSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width - 15 - 50, 10, 78, 32)];
        _otherSwitch.on = NO;
        [_otherSwitch addTarget:self action:@selector(otherSwitchAction:) forControlEvents:UIControlEventValueChanged];
        _otherSwitch.onTintColor = [UIColor colorWithHexString:@"0089F1"];
    }
    return _otherSwitch;
}

- (UISwitch *)mySwitch {
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width - 15 - 50, 10, 78, 32)];
        _mySwitch.on = NO;
        [_mySwitch addTarget:self action:@selector(mySwitchAction:) forControlEvents:UIControlEventValueChanged];
        _mySwitch.onTintColor = [UIColor colorWithHexString:@"0089F1"];
    }
    return _mySwitch;
}


@end
