//
//  SDTimeLineRefreshFooter.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 17/2/6.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "SDBaseRefreshView.h"

@interface SDTimeLineRefreshFooter : SDBaseRefreshView

+ (instancetype)refreshFooterWithRefreshingText:(NSString *)text;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (void)addToScrollView:(UIScrollView *)scrollView refreshOpration:(void(^)())refrsh;

@property (nonatomic, strong) UILabel *indicatorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, copy) void (^refreshBlock)();
#pragma clang diagnostic pop
@end
