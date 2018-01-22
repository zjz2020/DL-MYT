//
//  SDTimeLineRefreshHeader.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 17/2/7.
//  Copyright © 2017年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SDBaseRefreshView.h"

@interface SDTimeLineRefreshHeader : SDBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
@property (nonatomic, copy) void(^refreshingBlock)();
#pragma clang diagnostic pop
@end
