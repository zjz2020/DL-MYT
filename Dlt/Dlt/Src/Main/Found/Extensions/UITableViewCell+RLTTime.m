//
//  UITableViewCell+RLTTime.m
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "UITableViewCell+RLTTime.h"

static NSDateFormatter *DLTCellDateFormatter() {
  static NSDateFormatter *_dateFormatterStatic;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _dateFormatterStatic = [[NSDateFormatter alloc] init];
    [_dateFormatterStatic setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
  });
  
  return _dateFormatterStatic;
}


@implementation UITableViewCell (RLTTime)

- (NSString *)compareCurrentTime:(NSString *)timeStr{
  //把字符串转为NSdate
  NSDate *timeDate = [DLTCellDateFormatter() dateFromString:timeStr];
  return [self _compareCurrentTime:timeDate];
}

- (NSString *)compareCurrentTimeDate:(NSDate *)timeDate{
   NSString *timestamp_str = [DLTCellDateFormatter() stringFromDate:timeDate];
  return [self compareCurrentTime:timestamp_str];;
  
  
  return [self _compareCurrentTime:timeDate];
}

- (NSString *)_compareCurrentTime:(NSDate *)timeDate{
  //得到与当前时间差
  NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
  timeInterval = -timeInterval;
  //标准时间和北京时间差8个小时
  timeInterval = timeInterval - 8*60*60;
  long temp = 0;
  NSString *result;
  if (timeInterval < 60) {
    result = [NSString stringWithFormat:@"刚刚"];
  }
  else if((temp = timeInterval/60) <60){
    result = [NSString stringWithFormat:@"%d 分钟前",(int)temp];
  }
  
  else if((temp = temp/60) <24){
    result = [NSString stringWithFormat:@"%d 小时前",(int)temp];
  }
  
  else if((temp = temp/24) <30){
    result = [NSString stringWithFormat:@"%d 天前",(int)temp];
  }
  
  else if((temp = temp/30) <12){
    result = [NSString stringWithFormat:@"%d 月前",(int)temp];
  }
  else{
    temp = temp/12;
    result = [NSString stringWithFormat:@"%d 年前",(int)temp];
  }
  
  return  result;
}




@end
