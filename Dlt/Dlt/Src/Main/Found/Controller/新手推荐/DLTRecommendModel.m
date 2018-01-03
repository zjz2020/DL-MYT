//
//  DLTRecommendModel.m
//  Dlt
//
//  Created by Gavin on 2017/6/9.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTRecommendModel.h"

@implementation DLTRecommendModel

- (NSString *)sexStr{
  return self.sex? @"男" : @"女";
}

- (NSString *)age{
  if (self.birthday.length > 0) {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.birthday.doubleValue / 1000];
    return [self dateToOld:date];;
  }
  
  return @"0";
}

-(NSString *)dateToOld:(NSDate *)bornDate{
  //获得当前系统时间
  NSDate *currentDate = [NSDate date];
  //获得当前系统时间与出生日期之间的时间间隔
  NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
  //时间间隔以秒作为单位,求年的话除以60*60*24*356
  int age = ((int)time)/(3600*24*365);
  return [NSString stringWithFormat:@"%d",age];
}


@end
