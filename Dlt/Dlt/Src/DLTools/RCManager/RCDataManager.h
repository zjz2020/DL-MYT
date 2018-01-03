//
//  RCDataManager.h
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>


@interface RCDataManager : NSObject

/// 单利对象
+ (RCDataManager *)shareManager;

/// 刷新tabbarbage
- (void)refreshBadgeValue;
@end
