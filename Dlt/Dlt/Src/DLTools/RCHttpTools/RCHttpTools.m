//
//  RCHttpTools.m
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RCHttpTools.h"
#import "RCDataBaseManager.h"
#import "DLFriendsModel.h"
#import "DLGroupMemberModel.h"
#import "DltUICommon.h"
#import "DLGroupModel.h"
#import "DLOtherUserModel.h"
#import "DLRedpackerInfoModel.h"
#import "DLFriendPacketModel.h"
#import "DLRedpackerRecordModel.h"
#import "DLTUserProfile.h"

@implementation RCHttpTools
+ (RCHttpTools *)shareInstance {
    static RCHttpTools *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *)GetUserParams{
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  return  @{@"token" : userCenter.token,
            @"uid"   : userCenter.curUser.uid
           }.mutableCopy;
}

- (NSString *)getUserInfoByKey:(NSString *)key {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:key];
}

- (void)getUserInfoByUserId:(NSString *)userId handle:(void(^)(RCUserInfo *userInfo))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/userInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : userId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSDictionary *dic = response[@"data"];
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:dic[@"userName"] portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,dic[@"headImg"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(userInfo);
            });
        }
    }failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)getUserInfoForUsByUserId:(NSString *)userId
                          handle:(void(^)(DLOtherUserInfo *userInfo))compeletion {
    
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/userInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : userId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        DLOtherUserModel *model = [DLOtherUserModel modelWithJSON:response];
        if ([model.code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 compeletion(model.data);
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)getOtherUserInfoByUserId:(NSString *)userId handle:(void(^)(DLTUserProfile *userInfo))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/otherUserInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"toId": userId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            DLTUserProfile *model = [DLTUserProfile modelWithJSON:response[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(model);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(nil);
        });
    } progress:nil];
}

- (void)getUserFriendsList:(void(^)(NSArray *friendArr))comeleption {
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/myFriends",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:[self GetUserParams] successBlock:^(id response) {
        DLFriendsModel *friendsModel = [DLFriendsModel modelWithJSON:response];
        if ([friendsModel.code integerValue] == 1) {
            NSMutableArray *temp = [NSMutableArray array];
            for (DLFriendsInfo *model in friendsModel.data) {
                RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:model.fid name:model.name portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg]];
                [temp addObject:info];
            }
            [[RCDataBaseManager shareInstance] insertUserListToDB:temp];
            dispatch_async(dispatch_get_main_queue(), ^{
                comeleption(friendsModel.data);
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


- (void)getGroupInfoByGroupId:(NSString *)groupId handle:(void(^)(RCGroup *groupInfo))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/groupInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"groupId" : groupId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSDictionary *dic = response[@"data"];
            RCGroup *groupInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:dic[@"name"] portraitUri:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,dic[@"headImg"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(groupInfo);
            });
        }
    }failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)getGroupInfoForUsByGroupId:(NSString *)groupId
                            handle:(void(^)(DLGroupInfo *groupInfo))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/groupInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"groupId" : groupId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        DLGroupModel *model = [DLGroupModel modelWithJSON:response];
        if ([model.code integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(model.data);
            });
        }
    }failureBlock:^(NSError *error) {
        
    } progress:nil];
    
}


- (void)getGroupMembersByGroupId:(NSString *)groupId handle:(void(^)(NSArray *members))compeletion {
    
    NSString *url = [NSString stringWithFormat:@"%@Group/groupMembers",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"groupId" : groupId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
         DLGroupMemberModel *model = [DLGroupMemberModel modelWithDictionary:response];
        if ([model.code integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(model.data);
            });
        }
    }failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)dissolutionGroupByGroupId:(NSString *)groupId handle:(void(^)(BOOL isSuccess,NSString *msg))compeletion {
    
    NSString *url = [NSString stringWithFormat:@"%@Group/delGroup",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"groupId" : groupId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES,response[@"msg"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(NO,response[@"msg"]);
            });
        }
    }failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (void)changeGroupNameByGroupId:(NSString *)groupId
                 targetGroupName:(NSString *)groupName
                          handle:(void(^)(BOOL isSuccess))compeletion {
    
  NSString *url = [NSString stringWithFormat:@"%@Group/modifyGroupInfo",BASE_URL];
  NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];
   [params setObject:groupName forKey:@"groupName"];
  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}

- (void)changeGroupNoteByGroupId:(NSString *)groupId
                    newGroupNote:(NSString *)note
                          handle:(void(^)(BOOL isSuccess))compeletion {
  NSString *url = [NSString stringWithFormat:@"%@Group/modifyGroupInfo",BASE_URL];
  NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];
  [params setObject:note forKey:@"note"];
  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}

- (void)changeGroupHeadImgByGroupId:(NSString *)groupId
                      forHeadImgUrl:(NSString *)headImgUrl
                             handle:(void(^)(BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/modifyGroupInfo",BASE_URL];
    NSMutableDictionary *params = [self GetUserParams];
    [params setObject:headImgUrl forKey:@"headImg"];
    [params setObject:groupId forKey:@"groupId"];
//    [params setObject:headImgUrl forKey:@"headImgUrl"];
  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}

- (void)changeGroupImagesByGroupId:(NSString *)groupId
                       groupImages:(NSString *)imagesUrl
                            handle:(void(^)(BOOL isSuccess, NSString *imageUrl))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/modifyGroupInfo",BASE_URL];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"groupId" :groupId,
                             @"imgs" : imagesUrl
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES,response[@"data"][@"imgs"]);
            });
        } else {
            compeletion(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO,nil);
    } progress:nil];
}

- (void)deleteGroupImageByGroupId:(NSString *)groupId
                   deleteImageUrl:(NSString *)url
                           handle:(void(^)(BOOL isSuccess))compeletion {
    NSString *path = [NSString stringWithFormat:@"%@Group/delGroupImgs",BASE_URL];
  NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];
   [params setObject:url forKey:@"imgUrl"];
  
    [BANetManager ba_request_POSTWithUrlString:path parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}


- (void)invitationNewMemberJoinGroupWithGroupId:(NSString *)groupId
                                   targetUserId:(NSString *)userIds
                                         handle:(void(^)(BOOL isSuccess))compeletion {
    
  NSString *url = [NSString stringWithFormat:@"%@Group/addGroupMembers",BASE_URL];
  NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];
  [params setObject:userIds forKey:@"uids"];
  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}

- (void)exitGroupBuyGroupId:(NSString *)groupId handle:(void(^)(BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/exitGroup",BASE_URL];
   NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];

  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}

- (void)addFriendsWithFriendsId:(NSString *)userId handle:(void (^)(NSString *))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/addFriendRequest",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid,
                             @"fid" : userId
                             };
    //    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
       dispatch_async(dispatch_get_main_queue(), ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               NSString *msg = response[@"msg"];
               compeletion(msg);
           });
       });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(@"请求出现问题，请重新尝试");
        });
    } progress:nil];
    
    
}



- (void)transferGrouperByGroupId:(NSString *)groupId
                          toUser:(NSString *)userId
                          handle:(void(^)(BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/groupOwinerMove",BASE_URL];
  NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];
  [params setObject:userId forKey:@"toId"];
  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}

- (void)setGroupManagerByGroupId:(NSString *)groupId
                          toUser:(NSString *)userId
                          handle:(void(^)(BOOL isSuccess))compeletion {
  NSString *url = [NSString stringWithFormat:@"%@Group/setGroupMgr",BASE_URL];
  NSMutableDictionary *params = [self GetUserParams];
  [params setObject:groupId forKey:@"groupId"];
  [params setObject:userId forKey:@"toId"];
  
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}
//取消群管理
- (void)groupMgrCancleManagerByGroupId:(NSString *)groupId
                          toUser:(NSString *)userId
                          handle:(void(^)(BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/groupMgrCancle",BASE_URL];

    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"groupId" :groupId,
                             @"memberId" : userId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
    } progress:nil];
}


- (void)removeGroupMembersByGroupId:(NSString *)groupId
                             toUser:(NSString *)userId
                             handle:(void(^)(BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/delGroupMembers",BASE_URL];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"groupId" :groupId,
                             @"memberId" : userId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            compeletion(NO);
        }
    } failureBlock:^(NSError *error) {
        compeletion(NO);
        NSLog(@"DDDDDDDDDDDDDDDDD%@",error);
    } progress:nil];
}

- (void)applyJoinGroupByGroupId:(NSString *)groupId handle:(void (^)(BOOL))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/addGroupReq",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"groupId" : groupId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(NO);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(NO);
        });
    } progress:nil];
}

- (void)handleGroupRequestByRequestId:(NSString *)requestId
                            stateCode:(NSString *)code
                               handle:(void (^)(NSString *operation))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Group/addGroupResponse",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"grId" : requestId,
                             @"code" : code
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(@"YES");
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(response[@"msg"]);
            });
        }
    } failureBlock:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            compeletion(NO);
//        });
    } progress:nil];
}

- (void)userChangeRemarkInGroupWithGroupId:(NSString *)groupId
                              andNewRemark:(NSString *)remark
                                    handle:(void(^)(BOOL isSuccess))compeletion {
    
    NSString *url = [NSString stringWithFormat:@"%@Group/groupRemark",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"groupId" : groupId,
                             @"remark" : remark
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(NO);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(NO);
        });
    } progress:nil];
}



/**------------------------  红包接口  --------------------------**/
- (void)userIsSetPayPassword:(void(^)(BOOL isSet))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/isSetPaypwd",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSDictionary *dic = response[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"IsSetPaypwd"] integerValue] == 1) {
                    compeletion(YES);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        compeletion(NO);
                    });
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(NO);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(NO);
            
        });
    } progress:nil];
}

- (void)verificationPayPassword:(NSString *)password handle:(void(^)(BOOL isSame))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/verifyPaypwd",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"paypwd" : password
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if ([response[@"data"] integerValue] == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    compeletion(YES);
                });
            } else {
                compeletion(NO);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(NO);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(NO);
        });
    } progress:nil];
}

- (void)checkMyBalances:(void(^)(NSString *myBalances))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/myBalances",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSDictionary *dic = response[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(dic[@"balance"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(nil);
            });
        }
    }failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(nil);
        });
    } progress:nil];
}

- (void)sendRedpackerToFriend:(NSDictionary *)params handle:(void(^)(id responseObject))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/sendFriendRedpacket",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 compeletion(response[@"data"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(nil);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          compeletion(nil);
        });
    } progress:nil];
}

- (void)sendNomalRedpackerWithParams:(NSDictionary *)params
                              handle:(void(^)(NSString *responseObject, BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/sendNomalRedpacket",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = response[@"data"];
                compeletion(dic[@"rpId"],YES);
            });
        } else if ([response[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(response[@"msg"],NO);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(nil,NO);
        });
    } progress:nil];
}

- (void)sendFightLuckRedparkerWithParams:(NSDictionary *)params
                                  handle:(void(^)(NSString *responseObject, BOOL isSuccess))compeletion
{
    NSString *url = [NSString stringWithFormat:@"%@Wallet/sendRandomRedpacket",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = response[@"data"];
                NSString *str = [NSString stringWithFormat:@"%ld",(long)[dic[@"rpId"] integerValue]];
                compeletion(str,YES);
            });
        } else if ([response[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(response[@"msg"],NO);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(nil,NO);
        });
    } progress:nil];
}

- (void)getRedpacketDetailWithRedpackerId:(NSString *)redpackerId sendUid:(NSString*)sendUid
                                   handle:(void(^)(DLRedpackerInfo *redpackerInfo))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/redpacketInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"rpId" : redpackerId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
       
        DLRedpackerInfoModel *model = [DLRedpackerInfoModel modelWithJSON:response];
        model.data.uid = sendUid;
        if (model.code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(model.data);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(nil);
            });
        }
    }failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            compeletion(nil);
        });
    } progress:nil];
}

- (void)robRedpackerWithRedpackerId:(NSString *)redpackerId
                             handle:(void(^)(NSString *responseObject, BOOL isSuccess))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/getRedpacket",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"rpId" : redpackerId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
          
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(response[@"data"][@"amount"],YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(response[@"msg"],NO);
            });
        }
    }failureBlock:^(NSError *error) {
    } progress:nil];
}

- (void)receiveFriendsRedpacketWithRedpacketId:(NSString *)redpacketId
                                        handle:(void(^)(DLFriendPacketModel *packetStateModel))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/getFriendRedpacket",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"rpId" : redpacketId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = response[@"data"];
                DLFriendPacketModel *stateModel = [DLFriendPacketModel modelWithDictionary:dic];
                compeletion(stateModel);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(nil);
            });
        }
    }failureBlock:^(NSError *error) {
    } progress:nil];
}

- (void)getFriendRedpacketInfoWithRedpacketId:(NSString *)redpacketId
                                       handle:(void(^)(DLFriendPacketModel *model))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/friendRedpacketInfo",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"rpId" : redpacketId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        NSLog(@"%@",response);
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = response[@"data"];
                DLFriendPacketModel *packetModel = [DLFriendPacketModel modelWithDictionary:dic];
                compeletion(packetModel);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
               compeletion(nil);
            });
        }
    }failureBlock:^(NSError *error) {
    } progress:nil];
}


- (void)getFriendRedpacketRecordWithRedpacketId:(NSString *)redpacketId
                                         handle:(void(^)(NSArray *models))compeletion {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/friendRedpacketRecord",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : [DLTUserCenter userCenter].curUser.uid,
                             @"rpId" : redpacketId
                             };
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSMutableArray *temp = [NSMutableArray array];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *datas = response[@"data"];
                for (NSDictionary *dic in datas) {
                   DLRedpackerRecord *packetModel = [DLRedpackerRecord modelWithDictionary:dic];
                    packetModel.isFriendPacket = YES;
                    [temp addObject:packetModel];
                }
                compeletion(temp.copy);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                compeletion(nil);
            });
        }
    }failureBlock:^(NSError *error) {
    } progress:nil];
}



@end
