//
//  AppDelegate.m
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebView.h"
#import "LoginViewController.h"
#import "MainTabbarViewController.h"
#import "BaseNC.h"
#import "RCDNavigationViewController.h"
#import "AppDelegate+DLCategory.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"
#import <RongIMKit/RongIMKit.h>
#import "RCHttpTools.h"
#import "RCDataBaseManager.h"
#import "DLRedpacketMessage.h"
#import <WXApi.h>
#import "DLThirdShare.h"
#import "MyUncaughtExceptionHandler.h"
static NSString * const kWeChatAppKey = @"wx33af1f1e0e029d19";

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define GDKEY @"09743428909b1f7e88bfe1db55ae328b"
#define iosSee @"temp/ios_display"
@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,WXApiDelegate>
@property(nonatomic,assign)NSInteger afnCount;
@end

@implementation AppDelegate

- (void)configurationRCIM{
    //设置RCIMappkey
    [self cofonfig];
    _afnCount = 0;
    [[RCIM sharedRCIM] registerMessageType:[DLRedpacketMessage class]];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    [RCIM sharedRCIM].enableMessageRecall = YES;
    [RCIM sharedRCIM].userInfoDataSource = self;
}

- (void)configurationWechatShare {
    
    [WXApi registerApp:kWeChatAppKey];
}


- (void)registerUserNotification{
#ifdef __IPHONE_8_0
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];

#endif
   
    
    
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
-(void)isMyUncaughtExceptionHandler{
    [MyUncaughtExceptionHandler setDefaultHandler];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(
                                                                                     NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           NSArray *files =
                           [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           NSFileManager *fileManger = [NSFileManager defaultManager];
                           [fileManger removeItemAtPath:path error:nil];
                       });
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //进行数据请求  判断是否是审核状态
    [self judeIsAssessor];
    
    [self isMyUncaughtExceptionHandler];
    [AMapServices sharedServices].apiKey = GDKEY;//配置高德key
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [UIViewController new];
    [_window makeKeyAndVisible];
    
    [self configurationRCIM];

    [self configurationWechatShare];
    DLTUserCenter *userCenter = [DLTUserCenter userCenter];
    if (userCenter.isLogged){
        @weakify(self);
        [[userCenter autoLogin] subscribeNext:^(id response) {
            @strongify(self);
            int  code = [response[@"code"] intValue];
            if (code == 1) {[self loginCompleted];}
            else if (code == 2){}
            else{[self showLoginViewController];}
        }
                                        error:^(NSError *error) {
                                            @strongify(self);
                                            [self showLoginViewController];
                                        }
         
                                    completed:^{}];
        
    }
    
    else{
        
        [self showLoginViewController];
    }
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
         [self setUPkeyboardManager];
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }

      [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
   

      return YES;
}

- (void)judeIsAssessor{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,iosSee];
    _afnCount ++;
    @weakify(self);
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet urlString:urlStr parameters:nil successBlock:^(id response) {
//        @strongify(self);
        NSLog(@"%@",response);
        NSDictionary *dic = response[@"data"];
        NSString *isDisplay = [dic stringValueForKey:@"isDisplay"];
        if ([isDisplay isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setObject:showMYKeyYes forKey:showMYKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:showMYKeyNo forKey:showMYKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failureBlock:^(NSError *error) {
        @strongify(self);
        [DLAlert alertWithText:@"请求失败" afterDelay:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_afnCount < 5) {
                [self judeIsAssessor];
            }
        });
    } progress:nil];
}

-(void)setUPkeyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}
- (void)loginCompleted {
    
  MainTabbarViewController *mainVC = [[MainTabbarViewController alloc]initWithNibName:nil bundle:nil];
  self.mainViewController = mainVC;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
  self.window.rootViewController = mainVC;
  [self.window makeKeyAndVisible];
}

- (void)logoutCompleted{
  [self showLoginViewController];
  _mainViewController = nil;
}

- (void)showLoginViewController {
  LoginViewController * login = [[LoginViewController alloc]init];
  self.window.rootViewController = login;
  [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

/// 程序到后台后未读消息条数显示在icon上
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger totalUnreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = totalUnreadCount;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL) verify:(NSString *) resultStr {
    
    //此处的verify，商户需送去商户后台做验签
    return NO;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        if([code isEqualToString:@"success"]) {
            
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
            if(data != nil){
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                if([self verify:sign]) {
                    //验签成功
                }
                else {
                    //验签失败
                }
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"aliPayReslut" object:nil userInfo:resultDic];
        }];
        
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        return YES;
    }
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    if ([WXApi handleOpenURL:url delegate:self]) {
        return YES;
    }
    if ([WXApi handleOpenURL:url delegate:[DLThirdShare thirdShareInstance]]) {
        return YES;
    }
    if ([WXApi handleOpenURL:url delegate:[SDWebView WebViewInstance]]) {
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[RCIM sharedRCIM] openExtensionModuleUrl:url]) {
        return YES;
    }
    if ([WXApi handleOpenURL:url delegate:[DLThirdShare thirdShareInstance]]) {
        return YES;
    }
    if ([WXApi handleOpenURL:url delegate:[SDWebView WebViewInstance]]) {
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"aliPayReslut" object:nil userInfo:resultDic];
        }];
        
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        return YES;
    }
    return YES;
}

+ (AppDelegate *)shareAppdelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    NSLog(@"QQQQQQQQQQQQQQQQ%@",deviceToken);
    NSString *token = [deviceToken description];
 
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"QQQQQQQQQQQQQQQQerror : %@",error);
    
}
/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
}

#pragma mark -融云代理
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    [[RCHttpTools shareInstance] getUserInfoByUserId:userId handle:^(RCUserInfo *userInfo) {
        completion(userInfo);
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
-(void)onResp:(BaseResp *)resp{
    
    SendAuthResp *aresp = (SendAuthResp *)resp;

    //aresp.errCode== 0 &&

    if([aresp isKindOfClass:[SendMessageToWXResp class]]){
        return;
    }
    else if ([aresp isKindOfClass:[SendAuthResp class]]) {
        if(aresp.errCode== 0){
            if([aresp.state isEqualToString:@"mayitongAPP"])
            {
                NSString *code = aresp.code;
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"WEIXINBINDING" object:code];
            }
        }
    }
}

@end
