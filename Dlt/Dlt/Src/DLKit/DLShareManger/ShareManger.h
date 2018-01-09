//
//  ShareManger.h
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SHAREMANAGER [ShareManger ba_shareManage]
//bmdehs6pbik1s
//pkfcgjstp9u28      正式环境
#define RONGCLOUD_IM_APPKEY @"bmdehs6pbik1s" //online key

@interface ShareManger : NSObject

+ (ShareManger *)ba_shareManage;

-(void)setupryAppkey;

@end
