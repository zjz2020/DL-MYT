//
//  DLAlert.m
//  Dlt
//
//  Created by Liuquan on 17/6/2.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLAlert.h"
#import "MBProgressHUD.h"


@implementation DLAlert
+ (void)alertWithText:(NSString *)text afterDelay:(NSInteger)delayTime {
    [self alertHideLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud show:YES];
    
    // 定时隐藏
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [hud hide:YES];
    });
}
+ (void)alertWithText:(NSString *)text {
    [self alertWithText:text afterDelay:2];
}

+ (void)alertShowLoadWithTime:(NSInteger)delayTime {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    // 定时隐藏
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [hud hide:YES];
    });
}

+ (void)alertShowLoad {
    [self alertShowLoadWithTime:15];
}

+ (void)alertHideLoad {
     [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

@end
