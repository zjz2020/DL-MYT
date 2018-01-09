//
//  KeyChainManager.h
//  Dlt
//
//  Created by 陈杭 on 2018/1/8.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

/**
 *   存储 UUID
 *
 */
+(void)saveUUID:(NSString *)UUID;

/**
 *   读取UUID
 *
 */
+(NSString *)readUUID;

/**
 *   删除数据
 *
 */
+(void)deleteUUID;


@end
