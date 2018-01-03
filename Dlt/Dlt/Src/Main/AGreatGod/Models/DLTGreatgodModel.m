//
//  DLTGreatgodModel.m
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTGreatgodModel.h"

@implementation DLTGreatgodModel

- (NSString *)age{
  if (self.birthday.length > 0) {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.birthday.doubleValue / 1000];
    return [self dateToOld:date];;
  }
  
  return @"0";
}

- (NSString *)sexStr{
  return self.sex? @"男" : @"女";
}

- (void)setPhotos:(NSString *)photos{
  _photos = photos;
  
  if (photos.length > 0) {
    NSArray *components = [photos componentsSeparatedByString:@";"];
    if (components.count > 3) {
      NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
      self.photoNames = [components objectsAtIndexes:set];
    }
    else{
      self.photoNames = components;
    }
  }
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
