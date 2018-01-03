//
//  UIView+Extension.h
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

#pragma mark - 半径

- (void)ui_setCornerRadius:(NSUInteger)radius;
- (void)ui_setCornerRadius:(NSUInteger)radius withBackgroundColor:(UIColor *)backgroundColor;
- (void)ui_setCornerRadius:(NSUInteger)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (void)ui_setCornerRadius:(NSUInteger)radius withBackgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;


- (void)ui_setPathRadius:(CGFloat)radius withRoundedRect:(CGRect)rect;


@end
