//
//  RCHttpTools.h
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
/// 写的一个融云管理类
#import <Foundation/Foundation.h>
#import <RongIMLib/RCGroup.h>
#import <RongIMLib/RCUserInfo.h>
#import "DLFriendsModel.h"
@class DLGroupInfo,DLOtherUserInfo,DLRedpackerInfo,DLFriendPacketModel,DLFriendPacketStateModel,DLTUserProfile;


@interface RCHttpTools : NSObject

+ (RCHttpTools *)shareInstance;

/// 根据userid获取用户信息(这个是给融云的)
- (void)getUserInfoByUserId:(NSString *)userId handle:(void(^)(RCUserInfo *userInfo))compeletion;

/// 根据userid获取用户信息(这个是自己用的)
- (void)getUserInfoForUsByUserId:(NSString *)userId
                          handle:(void(^)(DLOtherUserInfo *userInfo))compeletion;

/// 获取好友列表 这个数组里面包含的是DLFriendsInfo 没有成NSArray<DLFriendsInfo *> *friendArr
- (void)getUserFriendsList:(void(^)(NSArray *friendArr))comeleption;

/// 根据id获取其他用户的信息
- (void)getOtherUserInfoByUserId:(NSString *)userId handle:(void(^)(DLTUserProfile *userInfo))compeletion;

/// 根据groupId获取群组信息(这个是个融云用)
- (void)getGroupInfoByGroupId:(NSString *)groupId handle:(void(^)(RCGroup *groupInfo))compeletion;

/// 根据groupId获取群组信息(这个给自己项目用)
- (void)getGroupInfoForUsByGroupId:(NSString *)groupId
                            handle:(void(^)(DLGroupInfo *groupInfo))compeletion;

/// 添加好友
- (void)addFriendsWithFriendsId:(NSString *)userId handle:(void(^)(NSString *message))compeletion;


/// 获取群成员
- (void)getGroupMembersByGroupId:(NSString *)groupId handle:(void(^)(NSArray *members))compeletion;

/// 解散群
- (void)dissolutionGroupByGroupId:(NSString *)groupId
                           handle:(void(^)(BOOL isSuccess,NSString *msg))compeletion;

/// 退出群
- (void)exitGroupBuyGroupId:(NSString *)groupId handle:(void(^)(BOOL isSuccess))compeletion;

/// 修改群名字
- (void)changeGroupNameByGroupId:(NSString *)groupId
                 targetGroupName:(NSString *)groupName
                          handle:(void(^)(BOOL isSuccess))compeletion;

/// 修改群备注
- (void)changeGroupNoteByGroupId:(NSString *)groupId
                    newGroupNote:(NSString *)note
                          handle:(void(^)(BOOL isSuccess))compeletion;

/// 修改群头像（一张图片）
- (void)changeGroupHeadImgByGroupId:(NSString *)groupId
                      forHeadImgUrl:(NSString *)headImgUrl
                             handle:(void(^)(BOOL isSuccess))compeletion;

/// 修改群图片（多张图片）
- (void)changeGroupImagesByGroupId:(NSString *)groupId
                      groupImages:(NSString *)imagesUrl
                             handle:(void(^)(BOOL isSuccess,NSString *imageUrl))compeletion;

/// 删除群图片(单张删除)
- (void)deleteGroupImageByGroupId:(NSString *)groupId
                   deleteImageUrl:(NSString *)url
                           handle:(void(^)(BOOL isSuccess))compeletion;


/// 群邀请新成员
- (void)invitationNewMemberJoinGroupWithGroupId:(NSString *)groupId
                                   targetUserId:(NSString *)userIds
                                         handle:(void(^)(BOOL isSuccess))compeletion;

/// 群主身份转让
- (void)transferGrouperByGroupId:(NSString *)groupId
                          toUser:(NSString *)userId
                          handle:(void(^)(BOOL isSuccess))compeletion;

/// 设置管理员
- (void)setGroupManagerByGroupId:(NSString *)groupId
                          toUser:(NSString *)userId
                          handle:(void(^)(BOOL isSuccess))compeletion;
/// 设置管理员
- (void)groupMgrCancleManagerByGroupId:(NSString *)groupId
                          toUser:(NSString *)userId
                          handle:(void(^)(BOOL isSuccess))compeletion;

/// 移除群成员
- (void)removeGroupMembersByGroupId:(NSString *)groupId
                             toUser:(NSString *)userId
                             handle:(void(^)(BOOL isSuccess))compeletion;

/// 申请加入某个群
- (void)applyJoinGroupByGroupId:(NSString *)groupId handle:(void(^)(BOOL isSuccess))compeletion;

/// 群主处理群请求
- (void)handleGroupRequestByRequestId:(NSString *)requestId
                            stateCode:(NSString *)code
                               handle:(void (^)(NSString *operation))compeletion;

/// 用户修改在群里面的昵称
- (void)userChangeRemarkInGroupWithGroupId:(NSString *)groupId
                              andNewRemark:(NSString *)remark
                                    handle:(void(^)(BOOL isSuccess))compeletion;


/**----------------------   红包支付网络请求 -----------------------   **/

/// 是否设置了支付密码 yes 设置了   no 没有设置
- (void)userIsSetPayPassword:(void(^)(BOOL isSet))compeletion;

/// 验证支付密码是否正确
- (void)verificationPayPassword:(NSString *)password handle:(void(^)(BOOL isSame))compeletion;

/// 查看我余额
- (void)checkMyBalances:(void(^)(NSString *myBalances))compeletion;

/// 好友一对一红包
- (void)sendRedpackerToFriend:(NSDictionary *)params handle:(void(^)(id responseObject))compeletion;

/// 发送普通红包
- (void)sendNomalRedpackerWithParams:(NSDictionary *)params
                              handle:(void(^)(NSString *responseObject, BOOL isSuccess))compeletion;

/// 发送拼手气红包
- (void)sendFightLuckRedparkerWithParams:(NSDictionary *)params
                                  handle:(void(^)(NSString *responseObject, BOOL isSuccess))compeletion;

/// 获取红包详情
- (void)getRedpacketDetailWithRedpackerId:(NSString *)redpackerId sendUid:(NSString*)sendUid
                                   handle:(void(^)(DLRedpackerInfo *redpackerInfo))compeletion;

/// 抢红包
- (void)robRedpackerWithRedpackerId:(NSString *)redpackerId
                             handle:(void(^)(NSString *responseObject, BOOL isSuccess))compeletion;

/// 领取好友红包
- (void)receiveFriendsRedpacketWithRedpacketId:(NSString *)redpacketId
                                        handle:(void(^)(DLFriendPacketModel *packetStateModel))compeletion;

/// 获取好友红包信息
- (void)getFriendRedpacketInfoWithRedpacketId:(NSString *)redpacketId
                                       handle:(void(^)(DLFriendPacketModel *model))compeletion;

/// 好友红包领取记录
- (void)getFriendRedpacketRecordWithRedpacketId:(NSString *)redpacketId
                                         handle:(void(^)(NSArray *models))compeletion;
@end
