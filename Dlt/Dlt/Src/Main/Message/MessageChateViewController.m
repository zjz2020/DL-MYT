//
//  MessageChateViewController.m
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "MessageChateViewController.h"
#import "SQMenuShowView.h"
#import "STQRCodeController.h"
#import "STQRCodeAlert.h"
#import "SearchFriendsViewController.h"
#import "ConversationViewController.h"
#import "RCDataManager.h"
#import "DLFriendsModel.h"
#import "XTPopView.h"
#import "DLMessageListCell.h"
#import "RCDataManager.h"
#import "DltUICommon.h"
#import "DLNewFriendTableViewController.h"
#import "DLOtherUserModel.h"
#import <RongIMKit/RongIMKit.h>
#import "RCHttpTools.h"
#import "RCDataBaseManager.h"
#import "DLGroupNotifyMessage.h"
#import "DLGroupMemberModel.h"
#import "DLRedpacketMessage.h"
#import "DLCreatGroupViewController.h"
#import "DLSeachViewController.h"
#import "RCDataManager.h"
#import "DLMyNewFriendsTableViewController.h"
#import "DLGroupSetupViewController.h"
#import "BaseNC.h"
#import "DLTransferAccountsTableViewController.h"
#import "AppDelegate.h"
#import "DLAddGroupMessage.h"
 #import "DLTransferMessage.h"
#import "DLPayNewsViewController.h"
@interface MessageChateViewController ()<STQRCodeControllerDelegate,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,selectIndexPathDelegate,UITableViewDelegate,UITableViewDataSource,RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource,RCIMGroupMemberDataSource>
{
    UIButton * rightbtn;
    XTPopView *PopView;
}
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSString *requesterName;
@property (nonatomic, assign) BOOL isClick;
@end

@implementation MessageChateViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)
                                            ]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_RECTANGLE];
        [self setCollectionConversationType:@[ @(ConversationType_SYSTEM)]];
        
        [RCIM sharedRCIM].userInfoDataSource = self;
        [RCIM sharedRCIM].groupUserInfoDataSource = self;
        [RCIM sharedRCIM].groupInfoDataSource = self;
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        //[RCIM sharedRCIM].RCIMGroupMemberDataSource = self;
       [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:@"99999999" name:@"蚂蚁通" portrait:nil];
    [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:@"99999999"];
    
    [self addrightitem];
    self.conversationListTableView.tableFooterView = [UIView new];
   
    [[RCIM sharedRCIM] registerMessageType:[DLRedpacketMessage class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[DLRedpacketMessage class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[DLAddGroupMessage class]];
     [[RCIMClient sharedRCIMClient] registerMessageType:[DLTransferMessage class]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"ClearHistoryMsg" object:nil];
    
    
}

- (void)refreshList {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationListTableView reloadData];
    });
}
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{

    [[RCHttpTools shareInstance] getGroupMembersByGroupId:groupId handle:^(NSArray *members) {
        
        NSMutableArray *array = [NSMutableArray array];
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        NSString *urlImage = [NSString stringWithFormat:@"%@UserCenter/otherUserInfo",BASE_URL];
        for (DLGroupMemberInfo *info in members) {
            [array addObject:info.Uid];
            NSDictionary *paramImage = @{
                                         @"token" : [DLTUserCenter userCenter].token,
                                         @"uid" : user.uid,
                                         @"toId":info.Uid
                                         };
            
            [BANetManager ba_request_POSTWithUrlString:urlImage parameters:paramImage successBlock:^(id response) {
                
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:info.Uid name:response[@"data"][@"userName"] portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,[response valueForKey:@"data"][@"userHeadImg"]]];
             
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:info.Uid];
            
            } failureBlock:^(NSError *error) {
                
            } progress:nil];}
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(array);
                });
    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isClick = YES;
    
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].groupInfoDataSource = self;
    [[RCDataManager shareManager] refreshBadgeValue];
}

-(void)addrightitem {
     rightbtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    [rightbtn setImage:[UIImage imageNamed:@"Okami_00"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightitem;
}
-(void)rightClick {
    CGPoint point = CGPointMake(WIDTH -30, 64 + 5);
    PopView = [[XTPopView alloc] initWithOrigin:point
                                          Width:115
                                         Height:120
                                           Type:XTTypeOfUpRight
                                          Color:[UIColor whiteColor]];
    PopView.dataArray = @[@"发起群聊",@"添加好友", @"扫一扫"];
    PopView.fontSize = 13;
    PopView.row_height = 40;
    PopView.titleTextColor = [UIColor blackColor];
    PopView.delegate = self;
    [PopView popView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [PopView dismiss];
}
- (void)selectIndexPathRow:(NSInteger )index {
    switch (index) {
        case 0: {
            /// 创建群
            DLCreatGroupViewController *vc = [DLCreatGroupViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            DLSeachViewController *vc = [DLSeachViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            NSLog(@"3");
            STQRCodeController *codeVC = [[STQRCodeController alloc]init];
            codeVC.delegate = self;
            BaseNC *navVC = [[BaseNC alloc]initWithRootViewController:codeVC];
            [self presentViewController:navVC animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isShow = NO;
    [self.showView dismissView];
}
#pragma mark - --- 2.delegate 视图委托 ---
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType {
    if (resultType == STQRCodeResultTypeSuccess) {
        NSDictionary *params = [self dictionaryWithJsonString:readerScanResult];
        if (params) {
            NSString *str = params[@"action"];
            if (str && [str isEqualToString:@"transfer"]) {
                [DLAlert alertShowLoad];
                [[RCHttpTools shareInstance] getOtherUserInfoByUserId:params[@"uid"] handle:^(DLTUserProfile *userInfo) {
                    if (userInfo) {
                        [DLAlert alertHideLoad];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        DLTransferAccountsTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLTransferAccountsTableViewController"];
                        DLFriendsInfo *friendInfo = [DLFriendsInfo new];
                        friendInfo.uid = userInfo.uid;
                        friendInfo.name = userInfo.userName;
                        friendInfo.headImg = userInfo.userHeadImg;
                        friendInfo.isFriend = userInfo.isFriend;
                        friendInfo.note = userInfo.note;
                        vc.friendsInfo = friendInfo;
                        vc.toID = params[@"uid"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            } else if (str && [str isEqualToString:@"addFriend"]) {
                NSString *uid = params[@"uid"];
                [[RCHttpTools shareInstance] addFriendsWithFriendsId:uid handle:^(NSString *message) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }];
            }
        }
    } else {
        [DLAlert alertWithText:@"二维码错误，请扫面正确二维码"];
    }
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    // 聚合类型
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        MessageChateViewController *chatVC = [[MessageChateViewController alloc] init];
        NSArray *arr = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [chatVC setDisplayConversationTypes:arr];
        [chatVC setCollectionConversationType:nil];
        chatVC.isEnteredToCollectionViewController = YES;
        chatVC.isSystem = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
        return;
    }
    
    
    // 系统消息
    if (model.conversationType == ConversationType_SYSTEM) {
        //把这个消息的未读数清除掉
        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:model.targetId];
        RCTextMessage *dayMessage = (RCTextMessage *)model.lastestMessage;
        if ( [dayMessage.extra isEqualToString:@"DLT:PROMOTE"] ) {
            NSArray *newsArray = [[RCIMClient sharedRCIMClient] getLatestMessages:6 targetId:@"99999999" count:10];
            DLPayNewsViewController *sdView = [DLPayNewsViewController new];
            NSMutableArray *news = [NSMutableArray arrayWithArray:newsArray];
            for (int i = 0; i < news.count; i++) {
                RCMessage *model = news[i];
                RCTextMessage *groupMsg = (RCTextMessage *)model.content;
                if (![groupMsg.extra isEqualToString:@"DLT:PROMOTE"]) {
                    [news removeObjectAtIndex:i];
                }
            }
            sdView.statuses = news;
            [self.navigationController pushViewController:sdView animated:YES];
            return;
        }
        //转账消息
        if ([model.lastestMessage isMemberOfClass:[DLTransferMessage class]] ) {
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        // 好友请求
        if ([model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            // 处理请求好友请求
//            DLNewFriendTableViewController *vc = [[DLNewFriendTableViewController alloc] init];
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            vc.requestUserId = [user objectForKey:@"requestUserId"];
//            vc.recordId = [user objectForKey:@"recordId"];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.isGroupRequest = NO;
//            [self.navigationController pushViewController:vc animated:YES];
//            model.unreadMessageCount = 0;
//            [self.conversationListTableView reloadData];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DLMyNewFriendsTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLMyNewFriendsTableViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([model.lastestMessage isKindOfClass:[DLAddGroupMessage class]]) {
            // 群通知
            DLAddGroupMessage *groupMsg = (DLAddGroupMessage *)model.lastestMessage;

            DLNewFriendTableViewController *vc = [[DLNewFriendTableViewController alloc] init];
            vc.requestUserId = model.targetId;
            vc.recordId = groupMsg.gqId;
            vc.isGroupRequest = YES;
            vc.hidesBottomBarWhenPushed = YES;
            vc.groupName = groupMsg.groupName;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
   
    // 其他消息，直接去聊天界面
    [self jumpToControllerWithType:model.conversationType andTargetId:model.targetId setControllerTitle:model.conversationTitle];
}

#pragma mark - 跳转到聊天界面
- (void)jumpToControllerWithType:(RCConversationType)conversationType andTargetId:(NSString *)targetId setControllerTitle:(NSString *)title {
    if (conversationType == 1) {
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        NSDictionary *paramImage = @{
                                     @"token" : [DLTUserCenter userCenter].token,
                                     @"uid" : user.uid,
                                     @"toId":targetId
                                     };
        NSString *urlImage = [NSString stringWithFormat:@"%@UserCenter/otherUserInfo",BASE_URL];
        [BANetManager ba_request_POSTWithUrlString:urlImage parameters:paramImage successBlock:^(id response) {
            
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:targetId name:response[@"data"][@"userName"] portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,[response valueForKey:@"data"][@"userHeadImg"]]];
            
            [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:targetId];
            
            
        } failureBlock:^(NSError *error) {
            
        } progress:nil];
    }

    
    ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
    conversationVC.conversationType = conversationType;
    conversationVC.targetId = targetId;
    conversationVC.title = title;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM
                                             targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
    [[RCDataManager shareManager] refreshBadgeValue];
   
}
- (void)didDeleteConversationCell:(RCConversationModel *)model {
    
    [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:model.targetId];
   
    [[RCDataManager shareManager] refreshBadgeValue];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    
    return 1;
}
#pragma mark - 融云代理
/// 接收到消息通知调用
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    // 只有当所有的消息全部接收到了再刷新UI
    if (left == 0) {
        
        // 刷新
        [self refreshConversationTableViewIfNeeded];
    }
   
    [[RCDataManager shareManager] refreshBadgeValue];
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    /// 其他设备登录了就提示下
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        /// 在这里来个退出登录
        [[DLTUserCenter userCenter]logout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate shareAppdelegate]logoutCompleted];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"您的帐号已在别的设备上登录，\n您被迫下线！"
                                  delegate:self
                                  cancelButtonTitle:@"知道了"
                                  otherButtonTitles:nil, nil];
            [alert show];
        });
    }
}


- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath {
    cell.contentView.backgroundColor = [UIColor whiteColor];
   
    
        
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.conversationListDataSource.count;
}
// 自定义消息列表样式
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
  
    if ((model.conversationType == ConversationType_SYSTEM)) {
        //日工资消息
        RCTextMessage *dayMessage = (RCTextMessage *)model.lastestMessage;
        if ([dayMessage.extra isEqualToString:@"DLT:PROMOTE"] ) {
            DLTransferMessage *groupMessage = (DLTransferMessage *)model.lastestMessage;
            DLMessageListCell *cell = [DLMessageListCell creatMessageListCellWithTableView:tableView];
            cell.headImg.image= [UIImage imageNamed:@"friends_39"];
            NSArray *array = [groupMessage.content componentsSeparatedByString:@";"];
            cell.nickName.text = @"日工资";
            cell.isFriendsRequest = NO;
            
            cell.detail.text = array[0];
            cell.unreadMsgCount.hidden = YES;
            
            
            
            return cell;
        }

        //转账消息
        if ([model.lastestMessage isMemberOfClass:[DLTransferMessage class]] ) {
            DLTransferMessage *groupMessage = (DLTransferMessage *)model.lastestMessage;
            DLMessageListCell *cell = [DLMessageListCell creatMessageListCellWithTableView:tableView];
            cell.headImg.image= [UIImage imageNamed:@"yue"];
            cell.nickName.text = @"转账消息";
            cell.isFriendsRequest = NO;
            cell.detail.text = groupMessage.content;
            cell.unreadMsgCount.hidden = YES;
        
            
            
            return cell;
        }
        
        
        if ([model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            RCContactNotificationMessage *message = (RCContactNotificationMessage *)model.lastestMessage;
             DLMessageListCell *cell = [DLMessageListCell creatMessageListCellWithTableView:tableView];
            cell.headImg.image= [UIImage imageNamed:@"system_notice"];
            cell.nickName.text = @"好友请求";
            NSString *operationContent = nil;
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            if ([message.operation isEqualToString:@"Request"]) {
//                NSString *name = [def objectForKey:model.targetId];
//                if (ISNULLSTR(name)) {
                    operationContent = @"来自好友请求";
//                } else {
//                    operationContent = [NSString stringWithFormat:@"来自“%@”的好友请求",[def objectForKey:model.targetId]];
//                   
//                }
            } else if ([message.operation isEqualToString:@"AcceptResponse"]) {
                operationContent = [NSString stringWithFormat:@"“%@”通过了你的好友请求",[def objectForKey:model.targetId]];
            }
            cell.detail.text = operationContent;
            cell.isFriendsRequest = YES;
            cell.model = model;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:message.targetUserId forKey:@"recordId"];
             [user setValue:message.sourceUserId forKey:@"requestUserId"];
            [user synchronize];
            return cell;
        }
        
        // 群系统消息
        if ([model.lastestMessage isKindOfClass:[DLAddGroupMessage class]] ) {
            DLAddGroupMessage *groupMessage = (DLAddGroupMessage *)model.lastestMessage;
            DLMessageListCell *cell = [DLMessageListCell creatMessageListCellWithTableView:tableView];
            cell.headImg.image = [UIImage imageNamed:@"Login_00"];
            cell.nickName.text = @"群系统消息";
            cell.isFriendsRequest = NO;
            

           NSString *name = groupMessage.fromName;
            cell.detail.text = [NSString stringWithFormat:@"%@:请求加入群[%@]",name, groupMessage.groupName];
            cell.unreadMsgCount.hidden = YES;
           
            cell.time.text = groupMessage.time;
         
            return cell;
        }
    }
//    /// 群聊天
//    if (model.conversationType == ConversationType_GROUP) {
//        DLMessageListCell *listCell = [DLMessageListCell creatMessageListCellWithTableView:tableView];
//        [[RCHttpTools shareInstance] getGroupInfoByGroupId:model.targetId handle:^(RCGroup *groupInfo) {
//            listCell.nickName.text = groupInfo.groupName;
//            [listCell.headImg sd_setImageWithURL:[NSURL URLWithString:groupInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
//        }];
//        [listCell setDataModel:model];
//        return listCell;
//    }
//    DLMessageListCell *listCell = [DLMessageListCell creatMessageListCellWithTableView:tableView];
////    [[RCHttpTools shareInstance] getUserInfoForUsByUserId:model.senderUserId handle:^(DLOtherUserInfo *userInfo) {
////        listCell.nickName.text = userInfo.userName;
////        [listCell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,userInfo.headImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
////    }];
//    listCell.model = model;
    return [[RCConversationBaseCell alloc] init];
}

#pragma mark - 收到消息监听/自定义会话cell
-(void)didReceiveMessageNotification:(NSNotification *)notification {
    RCMessage *message = notification.object;
    
    
    if (message.conversationType == ConversationType_SYSTEM) {
        //RCTextMessage *textMsg = (RCTextMessage *)message.content;
       // if ([textMsg.extra isEqualToString:@"DLT:PROMOTE"]) {
       //     return;
       // }
        if ([message.objectName isEqualToString:@"RC:ContactNtf"]) {
            [self getRequestInfoById:message.targetId];
        }
                /// 群消息
        if ([message.objectName isEqualToString:@"RC:TxtMsg"]) {
            if ([message.content isMemberOfClass:[RCTextMessage class]]) {
                RCTextMessage *textMsg = (RCTextMessage *)message.content;
                
                NSArray *arr = [textMsg.content componentsSeparatedByString:@";"];
                [[RCHttpTools shareInstance] getOtherUserInfoByUserId:message.targetId handle:^(DLTUserProfile *userInfo) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:userInfo.userName forKey:arr[0]];
                    [user synchronize];
                }];
            }
            
        }
    }
  
        [self notifyUpdateUnreadMessageCount];
        [self refreshConversationTableViewIfNeeded];
        [[RCDataManager shareManager] refreshBadgeValue];
   

    
    
}
- (void)getRequestInfoById:(NSString *)targetId {
    [[RCHttpTools shareInstance] getUserInfoByUserId:targetId handle:^(RCUserInfo *userInfo) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:userInfo.name forKey:targetId];
        [user synchronize];
        [super refreshConversationTableViewIfNeeded];
    }];
}


- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    for (int i = 0; i < dataSource.count; i ++) {
        RCConversationModel *model = dataSource[i];
        if (model.conversationType == ConversationType_SYSTEM) {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            model.isTop = YES;
        }
    }
    return dataSource;
}

- (NSMutableArray *)friends {
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    @weakify(self)
    if ([userId isEqualToString:[DLTUserCenter userCenter].curUser.uid]) {
        [[RCHttpTools shareInstance] getUserInfoByUserId:userId handle:^(RCUserInfo *userInfo) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(userInfo);
                [self refreshConversationTableViewIfNeeded];
            });
        }];
    } else {
        [[RCHttpTools shareInstance] getOtherUserInfoByUserId:userId handle:^(DLTUserProfile *userInfo) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userInfo.uid name:userInfo.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,userInfo.userHeadImg]];
                completion(info);
                [self refreshConversationTableViewIfNeeded];
            });
        }];
    }
}
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    
    [[RCHttpTools shareInstance] getGroupInfoByGroupId:groupId handle:^(RCGroup *groupInfo) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:groupInfo.groupName forKey:groupId];
        [user synchronize];
        completion(groupInfo);
    }];
}
- (void)getUserInfoWithUserId:(NSString *)userId
                      inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
//    [[RCHttpTools shareInstance] getGroupMembersByGroupId:groupId handle:^(NSArray *members) {
//        for (DLGroupMemberInfo *info in members) {
//            if ([userId isEqualToString:info.Uid]) {
//                RCUserInfo *userInfo = [RCUserInfo new];
//                userInfo.name = info.Remrk;
//                userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg];
//                userInfo.userId = info.Uid;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completion(userInfo);
//                });
//            }
//        }
//    }];
    @weakify(self)
    if ([userId isEqualToString:[DLTUserCenter userCenter].curUser.uid]) {
        [[RCHttpTools shareInstance] getUserInfoByUserId:userId handle:^(RCUserInfo *userInfo) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(userInfo);
                [self refreshConversationTableViewIfNeeded];
            });
        }];
    } else {
        [[RCHttpTools shareInstance] getOtherUserInfoByUserId:userId handle:^(DLTUserProfile *userInfo) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userInfo.uid name:userInfo.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,userInfo.userHeadImg]];
                completion(info);
                [self refreshConversationTableViewIfNeeded];
            });
        }];
    }
}
- (void)dealloc {
   
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {return nil;}
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        [DLAlert alertWithText:@"获取数据失败"];
        return nil;
    }
    return dic;
}

@end
