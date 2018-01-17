//
//  DLAlert.h
//  Dlt
//
//  Created by Liuquan on 17/6/2.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLAlert : NSObject
+ (void)alertWithText:(NSString *)text afterDelay:(NSInteger)delayTime;
+ (void)alertWithText:(NSString *)text;
+ (void)alertShowLoadWithTime:(NSInteger)delayTime;
+ (void)alertShowLoad;
+ (void)alertHideLoad;
//一直显示警告
+ (void)alertShowLoadStr:(NSString *)msg;
+ (void)alertHideLoadStrWithTime:(NSInteger)time;
@end
