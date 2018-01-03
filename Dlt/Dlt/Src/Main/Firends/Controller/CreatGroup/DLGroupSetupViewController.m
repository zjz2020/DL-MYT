//
//  DLGroupSetupViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupSetupViewController.h"
#import "DltUICommon.h"
#import "DLInvitationNewMemberVC.h"
#import "RCHttpTools.h"
#import "DLGroupMemberModel.h"
#import "DLGroupHeadImg.h"
#import "DLGroupManagerTableViewController.h"
#import "DLGroupModel.h"
#import "DLUserInfDetailViewController.h"
#import "DLSeeMembersTableViewController.h"
#import "DLGroudNoticeViewController.h"

NSString * const kMainGrouperDeletGroupNitificationName = @"MainGrouperDeletGroupNitificationName";


@interface DLGroupSetupViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    BOOL enableNotification;
    RCConversation *currentConversation;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutW;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *groupCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *groupCard;
@property (weak, nonatomic) IBOutlet UIView *groupCardView;
@property (nonatomic, strong) NSArray *memberArr;

// 群主有的权限，管理员不一定有，管理员有的，群主一定有
@property (nonatomic, assign) BOOL isMainGrouper;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) NSString *myGroupCard;
@property (weak, nonatomic) IBOutlet UISwitch *msgSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *topSwitch;

@end

static NSString * const kgroupMemberItemId = @"groupMemberItemId";

@implementation DLGroupSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self getGroupMembers];
    
    self.title = @"群设置";
    self.deleteBtn.layer.cornerRadius = 5;
    self.deleteBtn.layer.masksToBounds = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.groupCardView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeMyGroupCard)];
    [self.groupCardView addGestureRecognizer:tapGes];
    
    [self.collectionView registerClass:[DLGroupImageCell class] forCellWithReuseIdentifier:kgroupMemberItemId];
    
    /*
     1是普通成员
     2是管理
     3是群主
     */
    self.deleteBtn.hidden = YES;
    @weakify(self)
    [[RCHttpTools shareInstance] getGroupInfoForUsByGroupId:self.groupId handle:^(DLGroupInfo *groupInfo) {
        self.deleteBtn.hidden = NO;
        @strongify(self)
         dispatch_async(dispatch_get_main_queue(), ^{
        switch ([groupInfo.role integerValue]) {
            case 1: {
                self.isAdmin = NO;
                self.isMainGrouper = NO;
            }
                break;
            case 2: {
                self.isAdmin = YES;
            }
                break;
            default: {
                self.isMainGrouper = YES;
                [self.deleteBtn setTitle:@"解散群组" forState:UIControlStateNormal];
            }
                break;
        }
         });
        self.groupCard.text = groupInfo.remark;
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.backViewLayoutW.constant = kScreenSize.width;
    self.backViewLayoutH.constant = kScreenSize.height + 10;
}

#pragma mark - collectionview / delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {return 1;}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.memberArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DLGroupImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kgroupMemberItemId forIndexPath:indexPath];
    DLGroupMemberInfo *info = self.memberArr[indexPath.item];
    NSString *headImg = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLGroupMemberInfo *info = self.memberArr[indexPath.item];
    DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
    vc.otherUserId = info.Uid;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)getGroupMembers {
    @weakify(self)
    [[RCHttpTools shareInstance] getGroupMembersByGroupId:self.groupId handle:^(NSArray *members) {
        @strongify(self)
        self.memberArr = members.copy;
        self.groupCount.text= [NSString stringWithFormat:@"%ld/3000",(long)members.count];
        self.groupCard.text = self.myGroupCard;
        [self.collectionView reloadData];
    }];
    currentConversation =
    [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP
                                          targetId:self.groupId];
    self.topSwitch.on = currentConversation.isTop;
    [[RCIMClient sharedRCIMClient]
     getConversationNotificationStatus:ConversationType_GROUP
     targetId:self.groupId
     success:^(RCConversationNotificationStatus nStatus) {
         enableNotification = NO;
         if (nStatus == NOTIFY) {
             enableNotification = YES;
         }
         self.msgSwitch.on = !enableNotification;
     }
     error:^(RCErrorCode status){
         
     }];
}
#pragma mark - 点击事件
// 邀请新成员
- (IBAction)invitedNewMembers:(UIButton *)sender {
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLInvitationNewMemberVC *vc = [stroyboard instantiateViewControllerWithIdentifier:@"DLInvitationNewMemberVC"];
    vc.groupId = self.groupId;
    vc.membersArr = self.memberArr.copy;
    [self.navigationController pushViewController:vc animated:YES];
    
    @weakify(self)
    vc.successBlock = ^() {
        @strongify(self)
        [self getGroupMembers];
    };
}
// 群组管理
- (IBAction)groupManager:(UIButton *)sender {
    if (!self.isMainGrouper) {
        if (!self.isAdmin) {
            [DLAlert alertWithText:@"您不是群主或管理员"];
            return;
        }
    }
    DLGroupManagerTableViewController *vc = [DLGroupManagerTableViewController new];
    vc.groupId = self.groupId;
    vc.isMainGrouper = self.isMainGrouper;
    vc.isAdmin = self.isAdmin;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//群公告
- (IBAction)groupNoticeNoticeNoticeNoticeNoticegroupNotice:(id)sender {
    if (!self.isMainGrouper) {
        if (!self.isAdmin) {
            [DLAlert alertWithText:@"您不是群主或管理员"];
            return;
        }
    }
    DLGroudNoticeViewController *sdView = [DLGroudNoticeViewController new];
    sdView.groudID = self.groupId;
    [self.navigationController pushViewController:sdView animated:YES];
    
}

// 消息免打扰
- (IBAction)messageNotDisturb:(UISwitch *)sender {
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId isBlocked:sender.on success:^(RCConversationNotificationStatus nStatus) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [DLAlert alertWithText:@"设置成功"];
         });
     } error:^(RCErrorCode status){
         [DLAlert alertWithText:@"设置失败"];
     }];
    
   
}

// 消息置顶
- (IBAction)setTopGroup:(UISwitch *)sender {
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP
                                               targetId:self.groupId
                                                  isTop:sender.on];
}

// 清空聊天记录
- (IBAction)EmptyChatRecords:(UIButton *)sender {
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"确定清除聊天记录？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"确定"
                       otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

// 解散群
- (IBAction)deleteGroup:(UIButton *)sender {
    NSString *title = nil;
    if (!self.isMainGrouper) {
      title = @"删除并退出该群";
    } else {
        title = @"删除并且解散该群";
    }
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:title
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"确定"
                       otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 101;
}

- (void)changeMyGroupCard {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改群名片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入新的名称";
    [alert show];
}

#pragma mark -UIActionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            [DLAlert alertShowLoad];
            [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP targetId:self.groupId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DLAlert alertWithText:@"聊天记录清理成功"];
                });
            } error:^(RCErrorCode status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DLAlert alertWithText:@"聊天记录清理失败"];
                });
            }];
        }
    } else if (actionSheet.tag == 101) {
        if (buttonIndex == 0) {
            if (self.isMainGrouper) {
                [[RCHttpTools shareInstance] dissolutionGroupByGroupId:self.groupId handle:^(BOOL isSuccess, NSString *msg) {
                    if (isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMainGrouperDeletGroupNitificationName object:nil];
                        [[RCIMClient sharedRCIMClient]
                         clearMessages:ConversationType_GROUP
                         targetId:self.groupId];
                        
                        [[RCIMClient sharedRCIMClient]
                         removeConversation:ConversationType_GROUP
                         targetId:self.groupId];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            } else {
                [[RCHttpTools shareInstance] exitGroupBuyGroupId:self.groupId handle:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMainGrouperDeletGroupNitificationName object:nil];
                        [[RCIMClient sharedRCIMClient]
                         clearMessages:ConversationType_GROUP
                         targetId:self.groupId];
                        
                        [[RCIMClient sharedRCIMClient]
                         removeConversation:ConversationType_GROUP
                         targetId:self.groupId];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 1) {
        UITextField *txtName = [alertView textFieldAtIndex:0];
        @weakify(self)
        [[RCHttpTools shareInstance] userChangeRemarkInGroupWithGroupId:self.groupId andNewRemark:txtName.text handle:^(BOOL isSuccess) {
            @strongify(self)
            if (isSuccess) {
                 [DLAlert alertWithText:@"修改成功"];
                self.groupCard.text = txtName.text;
            } else {
                [DLAlert alertWithText:@"修改失败"];
            }
        }];
    }
}

// 去群成员列表
- (IBAction)gotoGroupMembersList:(UIButton *)sender {
    DLSeeMembersTableViewController *vc = [DLSeeMembersTableViewController new];
    vc.membersArr = self.memberArr.copy;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 私有方法
- (void)clearCacheAlertMessage:(NSString *)msg {
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:nil
                               message:msg
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSArray *)memberArr {
    if (!_memberArr) {
        _memberArr = [NSArray array];
    }
    return _memberArr;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMainGrouperDeletGroupNitificationName object:nil];
}


@end
