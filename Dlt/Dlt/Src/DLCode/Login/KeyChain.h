//
//  KeyChain.h
//  Dlt
//
//  Created by 陈杭 on 2018/1/8.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;


@end

