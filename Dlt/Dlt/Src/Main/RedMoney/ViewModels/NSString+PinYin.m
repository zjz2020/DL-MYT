//
//  NSString+PinYin.m
//  AddressBook
//
//  Created by caizheyong on 15/10/30.
//  Copyright © 2015年 xiaocaicai111. All rights reserved.
//

#import "NSString+PinYin.h"

@implementation NSString (PinYin)
+ (NSString *)getFirstNameWithText:(NSString *)name {
    //1:将字符串转换成可变字符串对象
    NSMutableString *nameM = [NSMutableString stringWithFormat:@"%@", name];
    //2:将字符串转换成带音标的拼音//0代表所有
    CFStringTransform((__bridge CFMutableStringRef)nameM, 0, kCFStringTransformMandarinLatin, NO);
//    NSLog(@"%@", nameM);
    //3:将带音标的拼音转换成不带音标的拼音
    CFStringTransform((__bridge CFMutableStringRef)nameM, 0, kCFStringTransformStripDiacritics, NO);
//    NSLog(@"%@", nameM);
    //4:获取拼音首字母
    NSString *firstL = [[nameM substringToIndex:1] uppercaseString];
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    if (![array containsObject:firstL]) {
        return @"*";
    }
    return firstL;
}
@end
