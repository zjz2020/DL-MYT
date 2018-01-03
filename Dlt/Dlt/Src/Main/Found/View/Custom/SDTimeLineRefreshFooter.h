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

- (void)addToScrollView:(UIScrollView *)scrollView refreshOpration:(void(^)())refrsh;

@property (nonatomic, strong) UILabel *indicatorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, copy) void (^refreshBlock)();

@end
