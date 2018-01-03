//
//  DLInvitationNewMemberVC.m
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLInvitationNewMemberVC.h"
#import "RCHttpTools.h"
#import "DLGroupMemberModel.h"
#import "DltUICommon.h"
#import "DLFriendsModel.h"

static NSString * const kInvitationNewMemberCellId = @"InvitationNewMemberCellId";


@interface DLInvitationNewMemberVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *invitationArr;
@property (nonatomic, strong) NSMutableArray *seachArr;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL isSeachFriends;

@end

@implementation DLInvitationNewMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSeachFriends = NO;
    self.tableView.tableFooterView = [UIView new];
    [self getAllFriendsMembers];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"9c9c9c"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(invitationFriendsJoinGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.textField.delegate = self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSeachFriends) {
        return self.seachArr.count;
    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLInvitationNewMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:kInvitationNewMemberCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLInvitationNewMemberVC" owner:nil options:nil] lastObject];
    }
    DLFriendsInfo *info;
    if (self.isSeachFriends) {
        info = self.seachArr[indexPath.row];
    } else {
        info = self.dataArr[indexPath.row];
    }
    cell.selectedImg.image = [UIImage imageNamed:@"group_choose"];
    if (info.isJoined) {
        cell.selectedImg.image = [UIImage imageNamed:@"choose_end"];
    }
    if (info.isSelectedMember) {
        cell.selectedImg.image = [UIImage imageNamed:@"group_choose_selected"];
    }
    cell.nickName.text = info.name;
    cell.detailLabel.text = @"";
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLFriendsInfo *info = self.isSeachFriends ? self.seachArr[indexPath.row]: self.dataArr[indexPath.row];
    if (info.isJoined) return;
    if (!info.isSelectedMember) {
        info.isSelectedMember = YES;
        [self.invitationArr addObject:info];
    } else {
        info.isSelectedMember = NO;
        [self.invitationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DLFriendsInfo *model = (DLFriendsInfo *)obj;
            if ([info.fid isEqualToString:model.fid]) {
                [self.invitationArr removeObject:model];
            }
        }];
    }
    [self setRightButtonState];
    [self.tableView reloadData];
}

- (void)invitationFriendsJoinGroup:(UIButton *)sender {
    if (self.invitationArr.count <= 0) return;
    NSMutableArray *temp = [NSMutableArray array];
    for (DLFriendsInfo *model in self.invitationArr) {
        [temp addObject:model.fid];
    }
    NSString *userIds = [temp componentsJoinedByString:@";"];
    [DLAlert alertShowLoad];
    @weakify(self)
    [[RCHttpTools shareInstance] invitationNewMemberJoinGroupWithGroupId:self.groupId targetUserId:userIds handle:^(BOOL isSuccess) {
        @strongify(self)
        if (isSuccess) {
            [DLAlert alertWithText:@"邀请成功"];
            if (self.successBlock) {
                self.successBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [DLAlert alertWithText:@"邀请失败"];
        }
    }];
}

- (void)setRightButtonState {
    if (self.invitationArr.count >= 1) {
        [self.rightBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)self.invitationArr.count] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"9c9c9c"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

// 获取所有好友
- (void)getAllFriendsMembers {
    @weakify(self)
    [[RCHttpTools shareInstance] getUserFriendsList:^(NSArray *friendArr) {
        @strongify(self)
        [self.dataArr removeAllObjects];
        for (DLGroupMemberInfo *member in self.membersArr) {
            for (DLFriendsInfo *info in friendArr) {
                if ([info.fid isEqualToString:member.Uid]) {
                    info.isJoined = YES;
                }
            }
        }
        [self.dataArr addObjectsFromArray:friendArr];
        [self.tableView reloadData];
    }];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)invitationArr {
    if (!_invitationArr) {
        _invitationArr = [NSMutableArray array];
    }
    return _invitationArr;
}
- (NSMutableArray *)seachArr {
    if (!_seachArr) {
        _seachArr = [NSMutableArray array];
    }
    return _seachArr;
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (ISNULLSTR(textField.text)) {
        self.isSeachFriends = NO;
        return NO;
    }
    [self.seachArr removeAllObjects];
    for (DLFriendsInfo *info in self.dataArr) {
        if ([info.name containsString:textField.text]) {
            [self.seachArr addObject:info];
        }
    }
    self.isSeachFriends = YES;
    [self.tableView reloadData];
    return YES;
}
@end





@implementation DLInvitationNewMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImg ui_setCornerRadius:4];
}

@end





