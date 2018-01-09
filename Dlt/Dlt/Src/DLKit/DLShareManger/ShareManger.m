//
//  ShareManger.m
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ShareManger.h"
#import <RongIMKit/RongIMKit.h>

@implementation ShareManger
+ (ShareManger *)ba_shareManage
{
    static ShareManger *ba_shareManage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ba_shareManage = [[ShareManger alloc] init];
    });
    return ba_shareManage;
}




-(void)setupryAppkey
{
    //正式pkfcgjstp9u28
    //测试bmdehs6pbik1s
    
    [[RCIM sharedRCIM]initWithAppKey:@"bmdehs6pbik1s"];
}





@end
