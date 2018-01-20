//
//  ConversationViewController.m
//  Dlt
//
//  Created by USER on 2017/5/24.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
/// 这个就是聊天界面了

#import <RongContactCard/RongContactCard.h>



#import "ConversationViewController.h"
#import "DLGroupMemberTableViewController.h"
#import "RCHttpTools.h"
#import "RCDataBaseManager.h"
#import "DLGroupSetupViewController.h"
#import "BaseNC.h"
#import "DLGroupMemberModel.h"
#import "DLPrivateRedPacketViewController.h"
#import "BaseNC.h"
#import "DLGroupRedpacketViewController.h"
#import "DLRedpacketCell.h"
#import "DLRedpacketMessage.h"
#import "DltUICommon.h"
#import "DLOpenRedpacketView.h"
#import "DLRedpackerDetailTableViewVC.h"
#import "DLRedpackerInfoModel.h"
#import "DLUserInfDetailViewController.h"
#import "DLMyFriendsListViewController.h"
#import "DLFriendPacketModel.h"
#import "DLPrivateChatSetTableViewController.h"
#import "DLCustomExpressionTab.h"
#import "DLExpressionMessage.h"
#import "DLAddGroupMessage.h"
#import "DLExpressionMsgCell.h"

static NSString * const kRedPackerIdKey = @"RedPackerIdKey";

static NSString * kDLRedpacketCellId = @"DLRedpacketCellId";

#define kRedPacketItemTag  520


// 我遵循这个RCMessageCellDelegate代理的原因是后续要是要点击cell就可以用啦
@interface ConversationViewController ()<
  RCMessageCellDelegate,
  RCIMUserInfoDataSource,
  RCIMGroupUserInfoDataSource,
  RCIMGroupInfoDataSource,
  DLPrivateRedpacketDelegate,
  DLGroupRedpacketVCDelegate,
  DLGroupRedpacketVCDelegate,
  DLOpenRedpacketViewDelegate,
  RCCCContactsDataSource,
DLCustomExpressionTabDelegte
>
@property (nonatomic, assign) NSInteger membersCount;
@property (nonatomic, assign) BOOL      isClick;  //防止多次点击
@end

@implementation ConversationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /// 这里禁用掉IQKeyboard的toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
  
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //其他地方要用，所以再次开启
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"conversation_user"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(groupSetUp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    if (self.conversationType == ConversationType_GROUP) {
        [backBtn setImage:[UIImage imageNamed:@"conversation_croup"] forState:UIControlStateNormal];
        @weakify(self)
        [[RCHttpTools shareInstance] getGroupMembersByGroupId:self.targetId handle:^(NSArray *members) {
            @strongify(self)
            self.membersCount = members.count;
        }];
    }
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].groupUserInfoDataSource = self;
    [RCIM sharedRCIM].groupInfoDataSource = self;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [RCContactCardKit shareInstance].contactsDataSource = self;
    
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    if ([user.uid isEqualToString:@"286"] || [user.uid isEqualToString:@"3422"]) {}else{
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"redpacket_item"] title:@"红包"
                                                                         tag:kRedPacketItemTag];
    }
   
    
    [self registerClass:[DLRedpacketCell class] forMessageClass:[DLRedpacketMessage class]]; //  注册自定义消息的Cell
     [self registerClass:[DLExpressionMsgCell class] forMessageClass:[DLExpressionMessage class]];

    [[RCIM sharedRCIM] registerMessageType:[DLRedpacketMessage class]];// 消息接收与发送
    [[RCIMClient sharedRCIMClient] registerMessageType:[DLRedpacketMessage class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[DLExpressionMessage class]];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dl_sendContactMessage:) name:kSendContactCardMessageNotificationName object:nil];
    //清除历史消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMSG:)
                                                 name:@"ClearHistoryMsg"
                                               object:nil];
    
    
    NSData *gifData = [[NSUserDefaults standardUserDefaults]dataForKey:@"ExpressGif"];
    NSArray *gifArray = [NSKeyedUnarchiver unarchiveObjectWithData:gifData];
    //表情面板添加自定义表情包
    UIImage *icon = [UIImage imageNamed:@"love"];
    DLCustomExpressionTab *emoticonTab1 = [DLCustomExpressionTab new];
    emoticonTab1.identify = @"1";
    emoticonTab1.image = icon;
    emoticonTab1.pageCount = ceil(gifArray.count/8.0);
    emoticonTab1.chartView = self;
    emoticonTab1.delegate = self;
    [self.chatSessionInputBarControl.emojiBoardView addEmojiTab:emoticonTab1];
}

- (void)clearHistoryMSG:(NSNotification *)notification {
    [self.conversationDataRepository removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
}

- (void)groupSetUp {
    if (self.conversationType == ConversationType_GROUP) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DLGroupSetupViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupSetupViewController"];
        vc.groupId = self.targetId;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(groudNotioce:) name:@"groudNotioce" object:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.conversationType == ConversationType_PRIVATE) {
//        DLPrivateChatSetTableViewController *vc = [DLPrivateChatSetTableViewController new];
//        vc.targetId = self.targetId;
//        [self.navigationController pushViewController:vc animated:YES];
        DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
        vc.otherUserId = self.targetId;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(void)groudNotioce:(NSNotification *)not{
    NSString *str = [NSString stringWithFormat:@"@所有人\n%@",not.object];
    RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:str];
    rcTextMessage.mentionedInfo = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_All userIdList:nil mentionedContent:nil];
    [self sendMessage:rcTextMessage pushContent:nil];
}
/// 这个当我们自己添加什么功能的时候就可以标记tag来用了
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if (tag == kRedPacketItemTag) {
        if (self.conversationType == ConversationType_PRIVATE) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DLPrivateRedPacketViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLPrivateRedPacketViewController"];
            BaseNC *nc = [[BaseNC alloc] initWithRootViewController:vc];
            vc.delegate = self;
            [self presentViewController:nc animated:YES completion:nil];
        } else if (self.conversationType == ConversationType_GROUP) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DLGroupRedpacketViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupRedpacketViewController"];
            BaseNC *nc = [[BaseNC alloc] initWithRootViewController:vc];
            vc.delegate = self;
            vc.membersCount = self.membersCount;
            [self presentViewController:nc animated:YES completion:nil];
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController  * ctr = [self topPresentedViewController];
            NSLog(@"%@",[ctr className]);
            UIBarButtonItem * leftItem = ctr.navigationItem.leftBarButtonItems[0];
            [leftItem setTintColor:[UIColor blackColor]];
            
            UIBarButtonItem * rightItem = ctr.navigationItem.rightBarButtonItems[0];
            [rightItem setTintColor:[UIColor blackColor]];
        });
    }
}

- (UIViewController *)topPresentedViewController
{
    UIViewController *topController = ([[UIApplication sharedApplication] delegate].window).rootViewController;
    
    while ([topController presentedViewController] != nil) {
        topController = [topController presentedViewController];
    }
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = topController ;
    if ([Rootvc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)Rootvc;
        UIViewController * v = [nav.viewControllers lastObject];
        currVC = v;
        Rootvc = v.presentedViewController;
        
    }else if([Rootvc isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabVC = (UITabBarController *)Rootvc;
        currVC = tabVC;
        Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
        
    }else if([Rootvc isKindOfClass:[UIViewController class]]){
        currVC = Rootvc;
    }
    return currVC;
}

#pragma mark - 自定义代理
- (void)privateRedpacketViewController:(UIViewController *)controller sureSendRedpacker:(NSDictionary *)content {
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"]= [DLTUserCenter userCenter].token;
    params[@"uid"] = user.uid;
    params[@"toId"] = self.targetId;
    CGFloat sureMoney = [content[ktotalMoneyKey] floatValue]*100;
    NSString *accont  = [NSString stringWithFormat:@"%d",(int)sureMoney];
    params[@"amount"] = accont;
    params[@"payPwd"] = content[kPassWordKey];
    params[@"note"] = content[kRemarkKey];
    [[RCHttpTools shareInstance] sendRedpackerToFriend:params handle:^(id responseObject) {
        [self sendRedpackerWithMessage:content[kRemarkKey] forRedpackerId:responseObject[@"rpId"]];
    }];
}
- (void)groupRedpackerViewController:(DLGroupRedpacketViewController *)controller sendRedpackerWithParams:(NSMutableDictionary *)params {
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger type = [params[kGroupRedpackerTypeKey] integerValue];
    dic[@"token"]= [DLTUserCenter userCenter].token;
    dic[@"uid"] = user.uid;
    dic[@"payPwd"] = params[kGroupPayPassWordKey];
    dic[@"totalCount"] = params[kGroupRedpackerCountKey];
    dic[@"note"] = params[kGroupRedpackerDetailKey];
    dic[@"groupId"] = self.targetId;
    NSString *totalMoney = [NSString stringWithFormat:@"%ld",(long)[params[kGroupRedpackertMoneyKey] floatValue]];
    NSLog(@"%@",totalMoney);
    if (type == DLGroupRedpackerType_Random) {
        dic[@"totalAmount"] = totalMoney;
        [[RCHttpTools shareInstance] sendFightLuckRedparkerWithParams:dic handle:^(NSString *responseObject, BOOL isSuccess) {
            NSLog(@"%@",responseObject);
            if (isSuccess) {
                if (!ISNULLSTR(responseObject)) {
                    [self sendRedpackerWithMessage:params[kGroupRedpackerDetailKey] forRedpackerId:responseObject];
                }
            } else {
                if (!ISNULLSTR(responseObject)) {
                    [DLAlert alertWithText:responseObject];
                }
            }
        }];
    } else {
        dic[@"singleAmount"] = totalMoney;
        [[RCHttpTools shareInstance] sendNomalRedpackerWithParams:dic handle:^(NSString *responseObject, BOOL isSuccess) {
            if (isSuccess) {
                if (!ISNULLSTR(responseObject)) {
                    [self sendRedpackerWithMessage:params[kGroupRedpackerDetailKey] forRedpackerId:responseObject];
                }
            } else {
                if (!ISNULLSTR(responseObject)) {
                    [DLAlert alertWithText:responseObject];
                }
            }
        }];
    }
}

- (void)openRedpacketView:(DLOpenRedpacketView *)redpackerView targetRedpacketInfo:(DLRedpackerInfo *)redpackerInfo {
    if (redpackerInfo.isGet || redpackerInfo.remainCount == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
        vc.redpackerInfo = redpackerInfo;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [[RCHttpTools shareInstance] robRedpackerWithRedpackerId:[NSString stringWithFormat:@"%ld",(long)redpackerInfo.rpId] handle:^(NSString *responseObject, BOOL isSuccess) {
        if (isSuccess) {
            
            //Wallet/redpacketInfo
                
//               DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
//                NSString *msgStr = [NSString stringWithFormat:@"%@领取了%@的红包",user.userName,redpackerInfo.userName];
//                RCInformationNotificationMessage *content = [RCInformationNotificationMessage notificationWithMessage:msgStr extra:nil];
//                [[RCIM sharedRCIM] sendDirectionalMessage:ConversationType_GROUP targetId:self.targetId toUserIdList:@[@"1271",user.uid] content:content pushContent:msgStr pushData:msgStr success:^(long messageId) {
//                    
//                } error:^(RCErrorCode nErrorCode, long messageId) {
//                    
//                }];
//                
                
            
    
            
            redpackerInfo.myGetAmount = [responseObject integerValue];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
            vc.redpackerInfo = redpackerInfo;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [DLAlert alertWithText:responseObject];
        }
    }];
}

- (void)openRedpacketView:(DLOpenRedpacketView *)redpackerView recevieFriendRedpacket:(DLFriendPacketModel *)model {
    
    if (model.isGet) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    /// 还未领取
    [[RCHttpTools shareInstance] receiveFriendsRedpacketWithRedpacketId:model.rpId handle:^(DLFriendPacketModel *packetStateModel) {
        if (model) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
            vc.model = packetStateModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}



- (void)openRedpacketView:(DLOpenRedpacketView *)redpackerView checkRedpackerDetail:(DLRedpackerInfo *)redpackerInfo {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
    vc.redpackerInfo = redpackerInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendRedpackerWithMessage:(NSString *)redpackerContent forRedpackerId:(NSString *)redpackerId {
    DLRedpacketMessage *msg = [DLRedpacketMessage messageWithContent:redpackerContent andRedpacketId:redpackerId];
    [self sendMessage:msg pushContent:@"[蚂蚁通红包]恭喜发财，大吉大利"];
}
-(void)sendExpressMessage:(NSString *)name{
    
    DLExpressionMessage *msg = [DLExpressionMessage messageWithContent:name];
    [self sendMessage:msg pushContent:@"【表情】"];

}

- (void)dl_sendContactMessage:(NSNotification *)notify {
    NSDictionary *dic = notify.userInfo;
    RCUserInfo *userInfo = [dic objectForKey:@"userInfo"];
    NSString *accepterId = [dic objectForKey:@"accepterId"];
    ConversationViewController *controller = [[ConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:accepterId];
    RCContactCardMessage *msg = [RCContactCardMessage messageWithUserInfo:userInfo];
    [controller sendMessage:msg pushContent:@"收到一张个人名片"];
    NSString *note = [dic objectForKey:@"note"];
    if (!ISNULLSTR(note)) {
        RCTextMessage *textMsg = [RCTextMessage messageWithContent:note];
        [controller sendMessage:textMsg pushContent:note];
    }
}

#pragma mark - 点击cell
/**
 1.好友红包 当self.conversationType == ConversationType_PRIVATE
 逻辑: 一、如果是自己发送的，点击红包直接进入详情界面
      二、如果别的好友发给自己的，点击红包cell显示红包 1.若没领取，显示拆 点击拆跳转到详情 2.领取了，显示“完且”显示“领取详情”点击进入详情界面
 2.群红包  当self.conversationType == ConversationType_GROUP
 逻辑: 一、不管是不是自己发的，都可以抢
      二、1.若自己抢了，但是总红包还没抢完直接去红包详情 2.总红包完了，红包view显示“完” 点击“完”进入红包详情
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    if(_isClick){
        return;
    }
    _isClick = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isClick = NO;
    });
    [super didTapMessageCell:model];
    if ([model.content isMemberOfClass:[DLRedpacketMessage class]]) {
        DLRedpacketMessage *msgModel = (DLRedpacketMessage *)model.content;
        if (self.conversationType == ConversationType_PRIVATE) {
            @weakify(self)
            [[RCHttpTools shareInstance] getFriendRedpacketInfoWithRedpacketId:msgModel.packetId handle:^(DLFriendPacketModel *model) {
                @strongify(self)
                if (model) {
                    // 自己发的
                    if ([model.uid isEqualToString:[DLTUserCenter userCenter].curUser.uid] || model.isGet) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
                        vc.model = model;
                        [self.navigationController pushViewController:vc animated:YES];
                        return;
                    }
                    /// 别人的，还没领
                    DLOpenRedpacketView *redpacker = [[DLOpenRedpacketView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    redpacker.delegate = self;
                    redpacker.friendPacketModel = model;
                    [[UIApplication sharedApplication].keyWindow addSubview:redpacker];
                }
            }];
        } else {
            @weakify(self)
            [[RCHttpTools shareInstance] getRedpacketDetailWithRedpackerId:msgModel.packetId handle:^(DLRedpackerInfo *redpackerInfo) {
                @strongify(self)
                /// 如果自己抢了直接去红包详情
                if (redpackerInfo.isGet) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    DLRedpackerDetailTableViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLRedpackerDetailTableViewVC"];
                    vc.redpackerInfo = redpackerInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                if (redpackerInfo) {
                    DLOpenRedpacketView *redpacker = [[DLOpenRedpacketView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    redpacker.delegate = self;
                    redpacker.redpackerInfo = redpackerInfo;
                    [[UIApplication sharedApplication].keyWindow addSubview:redpacker];
                }
            }];
        }
    } else if ([model.content isMemberOfClass:[RCContactCardMessage class]]) {
        RCContactCardMessage *cardMsg = (RCContactCardMessage *)model.content;
        DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
        vc.otherUserId = cardMsg.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// 点击头像
- (void)didTapCellPortrait:(NSString *)userId {
    
    DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
    vc.otherUserId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 融云代理
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    [[RCHttpTools shareInstance] getUserInfoByUserId:userId handle:^(RCUserInfo *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
           completion(userInfo); 
        });
    }];
}
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion {
    [[RCHttpTools shareInstance] getGroupInfoByGroupId:groupId handle:^(RCGroup *groupInfo) {
       dispatch_async(dispatch_get_main_queue(), ^{
           completion(groupInfo);
       });
    }];
}
- (void)getUserInfoWithUserId:(NSString *)userId
                      inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    [[RCHttpTools shareInstance] getGroupMembersByGroupId:groupId handle:^(NSArray *members) {
        for (DLGroupMemberInfo *info in members) {
            if ([userId isEqualToString:info.Uid]) {
                RCUserInfo *userInfo = [RCUserInfo new];
                userInfo.name = info.Remrk;
                userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg];
                userInfo.userId = info.Uid;
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(userInfo);
                });
            }
        }
    }];
}

- (void)getAllContacts:(void (^)(NSArray<RCCCUserInfo *> *))resultBlock {
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/myFriends",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        DLFriendsModel *friendsModel = [DLFriendsModel modelWithJSON:response];
        if ([friendsModel.code integerValue] == 1) {
            NSMutableArray *temp = [NSMutableArray array];
            for (DLFriendsInfo *model in friendsModel.data) {
                RCCCUserInfo *info = [[RCCCUserInfo alloc] initWithUserId:model.fid name:model.name portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg]];
                info.displayName = model.name;
                [temp addObject:info];
            }
           dispatch_async(dispatch_get_main_queue(), ^{
               resultBlock(temp.mutableCopy);
           });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


@end
