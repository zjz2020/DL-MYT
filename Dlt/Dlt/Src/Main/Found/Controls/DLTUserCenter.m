//
//  DLTUserCenter.m
//  Dlt
//
//  Created by Gavin on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTUserCenter.h"
#import "ZWBucket.h"
#import "SAMKeychain+Extension.h"
#import "RCHttpTools.h"
#import "KeyChainManager.h"

NSString *const DLTUserCenterUserInfoKey  = @"dltUserCenterUserInfoKey";
NSString *const DLTKeychainserviceNameKey  = @"dltKeychainserviceNameKey";
NSString *const DLTUserLoggedKey  = @"dltUserLoggedKey";
NSString *const DLTUserTokenKey  = @"dltUserTokenKey";
NSString *const refreshToken   =  @"usercenter/refresh_rong_token";
// UIKIT_EXTERN NSString *const DltUserCenterUserTokenKey NS_AVAILABLE_IOS(8_0);

/**
 获取用户密码

 @param account 账号
 @return 密码
 */
NSString *GetUserPasswordForAccount(NSString *account){
  return [SAMKeychain passwordForService:DLTKeychainserviceNameKey account:account];
}

@interface DLTUserCenter ()

@property (nonatomic, copy) NSString *userPassword;

@end


static DLTUserCenter *_userCenter = nil;

@implementation DLTUserCenter {
  RACSubject *_userInfoChangeSubject;
}

@synthesize userInfoChangeSignal = _userInfoChangeSubject;

+ (DLTUserCenter *)userCenter{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _userCenter = [[self alloc] init];
  });
  
  return _userCenter;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
  _userInfoChangeSubject = [RACSubject subject];
  }
  return self;
}
#pragma mark - lifecycle

@end



@implementation DLTUserCenter (Operation)

- (RACSignal *)login:(NSString *)account password:(NSString *)pwd {
  NSParameterAssert(account);
  NSParameterAssert(pwd);
    if(![KeyChainManager readUUID]){
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChainManager saveUUID:idfv];
    }
  @weakify(self);
  return [[[[[RACSignal
          createSignal:^RACDisposable *(id<RACSubscriber>subscriber) {
            @strongify(self);
              NSString  * saveKeyAccountStr = [KeyChainManager readUUID];
              
              [self remoteToken: @{@"account":account,@"password":pwd,@"login_device_id":saveKeyAccountStr}
                 successBlock:^(id response) {   // remote token
                    @strongify(self);
                   int code = [response[@"code"] intValue];
                   if (code == 1 || code == 2 ){  // 登录成功
                      
                     NSString *tokneStr = response[@"data"][@"token"];
                     [self _updateUserInfo:response[@"data"]];
                     ZWBucket.userDefault.set(DLTUserTokenKey,tokneStr);
                     [self setUserPassword:pwd account:account];
                       [subscriber sendNext:response];
                       [subscriber sendCompleted];
                       [self toRefreshToken];
//                     [self _autoConnectRongCloudWithToken:tokneStr
//                                                  success:^(NSString *userId) {
//                                                    @strongify(self);
//                                                    // 与融云服务器建立连接之后，应该设置当前用户的用户信息，用于SDK显示和发送
//                                                     [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:user.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,user.userHeadImg]];
//                                                    self->_onlineState = DltOnlineState_online;
//                                                    [subscriber sendNext:response];
//                                                    [subscriber sendCompleted];
//
//                                                  }
//                                                    error:^(RCConnectErrorCode status) {
//                                                      @strongify(self);
//                                                      self->_onlineState = DltOnlineState_offline;
//                                                      if (status == RC_CONNECTION_EXIST) {
//                                                        [subscriber sendNext:response];
//                                                        [subscriber sendCompleted];
//                                                      }else{
//                                                         [subscriber sendError:nil];
//                                                      }
//                                                  }];
                     
                   }else{ // 去外部处理
                       if (code == 0) {
                          
                           [subscriber sendError:[NSError errorWithDomain:@"登录出错了"
                                                                     code:10086
                                                                 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",response[@"msg"]]
                                                                                                      forKey:NSLocalizedDescriptionKey]]];
                       }else{
                           [subscriber sendError:[NSError errorWithDomain:@"网络出现问题"
                                                                     code:10010
                                                                 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",response[@"msg"]]
                                                                                                      forKey:NSLocalizedDescriptionKey]]];
                       }
                   
                   }
                   
                  
                   
            } failure:^{
              [subscriber sendError:nil];
                [DLAlert alertWithText: @"连接到远程服务器失败"];
            }];
            
            return nil;
          }]
          
          doNext:^(id x) {
            ZWBucket.userDefault.set(DLTUserLoggedKey, @YES);
          }]
            
          doError:^(NSError *error) {
             ZWBucket.userDefault.set(DLTUserLoggedKey, @NO);
          }] deliverOnMainThread] setNameWithFormat:@"用户[%@]登录了",account];

}
-(RACSignal *)tokenLogin:(NSString *)account password:(NSString *)pwd{
    NSParameterAssert(account);
    NSParameterAssert(pwd);
    
    @weakify(self);
    return [[[[[RACSignal
                createSignal:^RACDisposable *(id<RACSubscriber>subscriber) {
                    @strongify(self);
                    [self remoteToken: @{@"account":account,@"password":pwd}
                         successBlock:^(id response) {   // remote token
                             @strongify(self);
                             int code = [response[@"code"] intValue];
                             if (code == 1 || code == 2){  // 登录成功
                                 NSString *tokneStr = response[@"data"][@"token"];
                               
                                 ZWBucket.userDefault.set(DLTUserTokenKey,tokneStr);
                                 [self setUserPassword:pwd account:account];
                                 
                                                                 
                             }else{ // 去外部处理
                                 [subscriber sendError:[NSError errorWithDomain:@"登录出错了"
                                                                           code:10086
                                                                       userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",response[@"msg"]]
                                                                                                            forKey:NSLocalizedDescriptionKey]]];
                             }
                             
                             
                             
                         } failure:^{
                             [subscriber sendError:nil];
                         }];
                    
                    return nil;
                }]
               
               doNext:^(id x) {
                   ZWBucket.userDefault.set(DLTUserLoggedKey, @YES);
               }]
              
              doError:^(NSError *error) {
                  ZWBucket.userDefault.set(DLTUserLoggedKey, @NO);
              }] deliverOnMainThread] setNameWithFormat:@"用户[%@]登录了",account];
}
- (RACSignal *)autoLogin{
  NSString *userAct = self.curUser.account;
  NSString *password = GetUserPasswordForAccount(userAct);
  if (userAct.length == 0 || password.length == 0) {
    return [RACSignal return:nil];
  }
  return [self login:userAct password:password];
}

- (void)remoteToken:(NSDictionary *)param successBlock:(void(^)(id result))success failure:(dispatch_block_t)failure{
  NSString * url = [NSString stringWithFormat:@"%@UserCenter/login",BASE_URL];
  [BANetManager ba_request_POSTWithUrlString:url
                                  parameters:param
                                successBlock:^(id response) {
                                   if (success)success(response);
                                }
   
                                failureBlock:^(NSError *error) {
                                  if (failure)failure();
                                 // [BAAlertView showTitle:nil message:@"出现错误"];
                                }
   
                                progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                  
                                }];
}

- (void)_autoConnectRongCloudWithToken:(NSString *)token success:(void (^)(NSString *userId))successBlock error:(void (^)(RCConnectErrorCode status))errorBlock{
  NSAssert(token.length > 0, @"token is empty!");
    
  [[RCIM sharedRCIM] connectWithToken:token
                              success:successBlock
                                error:errorBlock
                       tokenIncorrect:^{
                                
                              }];
}


- (void)logout{
  ZWBucket.userDefault.rm(DLTUserCenterUserInfoKey); // 清理用户信息
  ZWBucket.userDefault.set(DLTUserLoggedKey, @NO);   // 变更用户登录状态
  ZWBucket.userDefault.rm(DLTUserTokenKey);
   [[RCIMClient sharedRCIMClient] logout];
    
}

- (RACSignal *)updateUserProfile{
  return [RACSignal empty];
}

- (void)setUserPassword:(NSString *)password account:(NSString *)account{
  [SAMKeychain setPassword:password forService:DLTKeychainserviceNameKey account:account];
}

- (RACSignal *)setUserInfo:(NSDictionary *)params{
  NSParameterAssert(params);
  
  @weakify(self);
  NSString *url = [NSString stringWithFormat:@"%@UserCenter/setBaseInfo",BASE_URL];
  return [[RACSignal
          createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [BANetManager ba_request_POSTWithUrlString:url
                                            parameters:params
                                          successBlock:^(id response) {
                                            @strongify(self);
                                              int code = [response[@"code"] intValue];
                                              if (code == 1) {
                                                [self _updateUserInfo:response[@"data"]];
                                                [subscriber sendNext:response];
                                                [subscriber sendCompleted];
                                              }
                                              else{
                                                [subscriber sendError:nil];
                                              }
            }
             
                                          failureBlock:^(NSError *error) {
                                             [subscriber sendError:nil];
                                          } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                            
                                          }];
            return nil;
  }] deliverOnMainThread];
}

- (RACSignal *)setModifyUserInfo:(NSDictionary *)params{
   NSString * url = [NSString stringWithFormat:@"%@UserCenter/modifyUserInfo",BASE_URL];
  
  return [[RACSignal
          createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
        BAURLSessionTask *task = [BANetManager ba_request_POSTWithUrlString:url
                                            parameters:params
                                          successBlock:^(id response) {                                   
                                            if ([response[@"code"]integerValue] == 1) {
                                              [subscriber sendNext:response];
                                              [subscriber sendCompleted];
                                            }
                                            else{[subscriber sendError:nil];}
                            
                                      } failureBlock:^(NSError *error) {
                                          [subscriber sendError:nil];
                                      } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                        
                                      }];
            return [RACDisposable disposableWithBlock:^{
              [task cancel];
            }];
  }] deliverOnMainThread];
}
- (void)setUserProfile:(DLTUserProfile *)user{
  ZWBucket.userDefault.set(DLTUserCenterUserInfoKey,user);
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [_userInfoChangeSubject sendNext:DLT_USER_CENTER.curUser];
  });
}

- (DLTUserProfile *)_updateUserInfo:(NSDictionary *)response{
  DLTUserProfile *user = [DLTUserProfile modelWithJSON:response];
  [self setUserProfile:user];  // save user
  
  return user;
}


- (void)requestUpdateUserInfo{
  NSString *url = [NSString stringWithFormat:@"%@UserCenter/userInfo",BASE_URL];
    NSLog(@"AAAAAA%@",DLT_USER_CENTER.token);
    NSLog(@"AAAAAAA%@",DLT_USER_CENTER.curUser.uid);
  NSDictionary *params = @{
                           @"token" : DLT_USER_CENTER.token,
                           @"uid" : DLT_USER_CENTER.curUser.uid
                           };
  @weakify(self)
  [BANetManager ba_request_POSTWithUrlString:url
                                  parameters:params
                                successBlock:^(id response) {
                                      @strongify(self)
                                    NSLog(@"%@",response);
                                      if ([response[@"code"] integerValue] == 1) {
                                        [self _updateUserInfo:response[@"data"]];
                                      }
                                    } failureBlock:^(NSError *error) {
                                      
                                    } progress:nil];
    
   
}

/**
 更新用户头像
 
 @param image UIImage
 */
- (RACSignal *)updateUserAvatar:(UIImage *)image{
   NSString *url = [NSString stringWithFormat:@"%@Upload/headImg",BASE_URL];
  NSDictionary *params = @{@"uid" : DLT_USER_CENTER.curUser.uid,
                           @"token" :DLT_USER_CENTER.token
                           };
  
//  @weakify(self);
  return [RACSignal
          createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            BAURLSessionTask *task = [BANetManager ba_uploadImageWithUrlString:url
                                                                    parameters:params
                                                                    imageArray:@[image]
                                                                      fileName:@""
                                                                  successBlock:^(id response) {
//                                                                    @strongify(self);
                                                                    if ([response[@"code"] integerValue] == 1){
                                                                       NSString *headimgeURL = response[@"data"][@"src"];
                                                                      [subscriber sendNext:headimgeURL];
                                                                      [subscriber sendCompleted];
                                                                    }
                                                                    else{                                                                  
                                                                      [subscriber sendError:nil];
                                                                    }
                                                                    
                                                                } failurBlock:^(NSError *error) {
                                                                   [subscriber sendError:nil];
                                                                } upLoadProgress:NULL];
            
            return [RACDisposable disposableWithBlock:^{
              [task cancel];
            }];
          }];
}
//刷新token
- (void)toRefreshToken{
    NSString *tokenStr = [NSString stringWithFormat:@"%@%@",BASE_URL,refreshToken];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token":[DLTUserCenter userCenter].token,
                          @"uid":user.uid
                          };
    [BANetManager ba_request_POSTWithUrlString:tokenStr parameters:dic successBlock:^(id response) {
        NSDictionary *dic = [response dictValueForKey:@"data"];
        NSString *token = [dic stringValueForKey:@"rongToken"];
        if (token) {
            self.RCToken = token;
            [self _autoConnectRongCloudWithToken:token
                                         success:^(NSString *userId) {
                                             // 与融云服务器建立连接之后，应该设置当前用户的用户信息，用于SDK显示和发送
                                             [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:user.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,user.userHeadImg]];
                                             self->_onlineState = DltOnlineState_online;
                                             //                                                    [subscriber sendNext:response];
                                             //                                                    [subscriber sendCompleted];
                                             
                                         }
                                           error:^(RCConnectErrorCode status) {
                                               NSLog(@"--%zd",status);
                                               self->_onlineState = DltOnlineState_offline;
                                               if (status == RC_CONNECTION_EXIST) {
                                                   //                                                        [subscriber sendNext:response];
                                                   //                                                        [subscriber sendCompleted];
                                               }else{
                                                   //                                                         [subscriber sendError:nil];
                                               }
                                           }];
        }
        NSLog(@"--%@",response);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@--",error);
    } progress:nil];
}

#pragma makr -
#pragma makr - propertys

- (DLTUserProfile *)curUser{
  return  ZWBucket.userDefault.get(DLTUserCenterUserInfoKey);
}

- (NSString *)token{
  return  ZWBucket.userDefault.get(DLTUserTokenKey);
}

- (BOOL)isLogged{
  return [ZWBucket.userDefault.get(DLTUserLoggedKey) boolValue];
}

@end
