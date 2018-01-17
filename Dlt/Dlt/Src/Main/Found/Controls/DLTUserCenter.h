//
//  DLTUserCenter.h
//  Dlt
//
//  Created by Gavin on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLTUserProfile.h"

UIKIT_EXTERN NSString *const DLTUserCenterUserInfoKey NS_AVAILABLE_IOS(8_0);
UIKIT_EXTERN NSString *const DLTKeychainserviceNameKey NS_AVAILABLE_IOS(8_0);
UIKIT_EXTERN NSString *const DLTUserLoggedKey NS_AVAILABLE_IOS(8_0);
UIKIT_EXTERN NSString *const DLTUserTokenKey NS_AVAILABLE_IOS(8_0);

#define DLT_USER_CENTER [DLTUserCenter userCenter]

typedef NS_ENUM(NSUInteger, DltOnlineState){
  DltOnlineState_online   = 0,     // 在线
  DltOnlineState_offline  = 1,     // 离线
  DltOnlineState_kicked   = 2,     // 被踢下线 (在其它设备登录)
  DltOnlineState_freeze   = 3      // 被冻结
};

@interface DLTUserCenter : NSObject

/**
 *  Returns the singleton `DLTUserCenter`.
 *  The instance is used by `DLTUserCenter` class methods.
 *
 *  @return The singleton `DLTUserCenter`.
 */
@property (class, nonatomic, strong, readonly) DLTUserCenter *userCenter;

/**
 当前登录的用户数据模型.
 */
@property (nonatomic, strong, readonly) DLTUserProfile *curUser;

/**
 服务器返回token.
 */
@property (nonatomic, copy, readonly) NSString *token;

/**
 当前用户与RIM服务器连接的状态.
 */
@property (nonatomic,getter=isOnlineState,readonly) DltOnlineState onlineState;

/**
 用户是否登录.
 */
@property (nonatomic, getter=isLogged,readonly) BOOL  logged;

/**
 用户信息变化Signal.
 return DLTUserProfile.
 */
@property (nonatomic, strong, readonly) RACSignal *userInfoChangeSignal;

//用户所在的经纬度  城市编码

@property(nonatomic, copy) NSString *cityCode;
//经纬度
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@end

/**
 关于用户信息操作
 */
@interface DLTUserCenter (Operation)

/**
 *  登陆
 *  @param account  用户账号
 *  @param pwd  用户密码
 *
 *  @return Signal.
 */
- (RACSignal *)login:(NSString *)account password:(NSString *)pwd;
- (RACSignal *)tokenLogin:(NSString *)account password:(NSString *)pwd;
- (RACSignal *)autoLogin;  // 在登录的情况下, 是可以自动登录的 , 也就是 isLogged YES;
- (void)logout;

/**
 设置用户信息
 */
- (RACSignal *)setUserInfo:(NSDictionary *)params;
- (RACSignal *)setModifyUserInfo:(NSDictionary *)params;
- (void)setUserProfile:(DLTUserProfile *)user;
- (void)requestUpdateUserInfo;

/**
 更新用户头像

 @param image UIImage
 */
- (RACSignal *)updateUserAvatar:(UIImage *)image;

/**
 请传入加密的密码
 */
- (void)setUserPassword:(NSString *)password account:(NSString *)account;

@end
