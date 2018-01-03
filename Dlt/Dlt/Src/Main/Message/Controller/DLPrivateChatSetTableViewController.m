//
//  DLPrivateChatSetTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/17.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLPrivateChatSetTableViewController.h"

@interface DLPrivateChatSetTableViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) UISwitch *messageDisturbSwitch;
@property (nonatomic, strong) UISwitch *messageTopSwitch;
@property (nonatomic, assign) BOOL isDistrub;

@end

@implementation DLPrivateChatSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天详情";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"privateChat"];
    self.tableView.tableFooterView = [UIView new];
    
    [self startLoadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateChat"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"444444"];
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"消息免打扰";
            [cell.contentView addSubview:self.messageDisturbSwitch];
        }
            break;
        case 1: {
            cell.textLabel.text = @"会话置顶";
            [cell.contentView addSubview:self.messageTopSwitch];
        }
            break;
        default: {
            cell.textLabel.text = @"清除聊天记录";
        }
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"确定清除聊天记录？"
                                    delegate:self
                           cancelButtonTitle:@"取消"
                      destructiveButtonTitle:@"确定"
                           otherButtonTitles:nil];
        
        [actionSheet showInView:self.view];
    }
    
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [DLAlert alertShowLoad];
        [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_PRIVATE targetId:self.targetId success:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               [DLAlert alertWithText:@"聊天记录清除成功"];
           });
        } error:^(RCErrorCode status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"聊天记录清除失败"];
            });
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHistoryMsg" object:nil];
    }
}
#pragma mark - 事件
- (void)messageDisturbSwitchAction:(UISwitch *)sender {
    [[RCIMClient sharedRCIMClient]
     setConversationNotificationStatus:ConversationType_PRIVATE
     targetId:self.targetId
     isBlocked:sender.on
     success:^(RCConversationNotificationStatus nStatus) {
         
     }
     error:^(RCErrorCode status){
         
     }];
}

- (void)messageTopSwitchAction:(UISwitch *)sender {
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE
                                               targetId:self.targetId
                                                  isTop:sender.on];
}

#pragma mark - 本类的私有方法
- (void)startLoadView {
    RCConversation *currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:self.targetId];
    self.messageTopSwitch.on = currentConversation.isTop;
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_PRIVATE targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
         self.isDistrub = NO;
         if (nStatus == NOTIFY) {
             self.isDistrub = YES;
         }
         [self.tableView reloadData];
     }
     error:^(RCErrorCode status){
         
     }];
}

#pragma mark - 懒加载
- (UISwitch *)messageDisturbSwitch {
    if (!_messageDisturbSwitch) {
        _messageDisturbSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width - 15 - 50, 10, 78, 32)];
        _messageDisturbSwitch.on = !self.isDistrub;
        [_messageDisturbSwitch addTarget:self action:@selector(messageDisturbSwitchAction:) forControlEvents:UIControlEventValueChanged];
        _messageDisturbSwitch.onTintColor = [UIColor colorWithHexString:@"0089F1"];
    }
    return _messageDisturbSwitch;
}

- (UISwitch *)messageTopSwitch {
    if (!_messageTopSwitch) {
        _messageTopSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width - 15 - 50, 10, 78, 32)];
        _messageTopSwitch.on = NO;
        [_messageTopSwitch addTarget:self action:@selector(messageTopSwitchAction:) forControlEvents:UIControlEventValueChanged];
        _messageTopSwitch.onTintColor = [UIColor colorWithHexString:@"0089F1"];
    }
    return _messageTopSwitch;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClearHistoryMsg" object:nil];
}
@end
