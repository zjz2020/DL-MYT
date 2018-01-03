//
//  AppDelegate+DLCategory.h
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (DLCategory)

-(void)cofonfig;

/// 初始化融云系列配置
- (void)initRongCouldWithApplication:(UIApplication *)application
                          andOptions:(NSDictionary *)luchOptions;


@end
