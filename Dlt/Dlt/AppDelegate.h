//
//  AppDelegate.h
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabbarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark- 文件夹路径
@property (strong, nonatomic) NSString *folderPath;

@property (nonatomic, strong) MainTabbarViewController *mainViewController;

+ (AppDelegate *)shareAppdelegate;


- (void)loginCompleted;
- (void)logoutCompleted;
- (void)showLoginViewController;

@end

