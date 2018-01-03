//
//  NSString+Extension.m
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark 计算字符串大小

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
  NSDictionary *dict = @{NSFontAttributeName: font};
  CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  return textSize;
}

- (NSString *)userBirthdayWithTimeIntervalSince1970{
  if (self.length > 0) {
    NSTimeInterval timeInterval = [self doubleValue];//秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];//日期
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.doubleValue / 1000];
    return [NSString dateToOld:date];;
  }
  
  return @"0";
}


+ (NSString *)dateToOld:(NSDate *)bornDate{
  //获得当前系统时间
  NSDate *currentDate = [NSDate date];
  //获得当前系统时间与出生日期之间的时间间隔
  NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
  //时间间隔以秒作为单位,求年的话除以60*60*24*356
  int age = ((int)time)/(3600*24*365);
  return [NSString stringWithFormat:@"%d",age];
}

@end
