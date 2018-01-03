//
//  UITableViewCell+RLTTime.h
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (RLTTime)

- (NSString *)compareCurrentTime:(NSString *)timeStr;
- (NSString *)compareCurrentTimeDate:(NSDate *)timeDate;

@end