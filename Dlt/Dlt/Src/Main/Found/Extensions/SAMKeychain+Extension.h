//
//  SAMKeychain+Extension.h
//  Dlt
//
//  Created by Gavin on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#if __has_include(<SAMKeychain/SAMKeychain.h>)
#import <SAMKeychain/SAMKeychain.h>
#else
#import "SAMKeychain.h"
#endif

@interface SAMKeychain (Extension)

+ (NSArray <NSString *> *)GetAllAccounts;
+ (NSArray <NSString *> *)GetAccountsForService:(NSString *)serviceName;

+ (void)deleteAllPassword;
+ (void)deleteAllPasswordForService:(NSString *)serviceName;

@end
