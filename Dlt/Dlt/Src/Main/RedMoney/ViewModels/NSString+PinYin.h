//
//  NSString+PinYin.h
//  AddressBook
//
//  Created by caizheyong on 15/10/30.
//  Copyright © 2015年 xiaocaicai111. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYin)
//获取姓名首字母
+ (NSString *)getFirstNameWithText:(NSString *)name;
@end
