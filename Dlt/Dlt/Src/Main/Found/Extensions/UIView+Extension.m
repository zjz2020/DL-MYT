//
//  UIView+Extension.m
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


#pragma mark - 半径
- (void)ui_setCornerRadius:(NSUInteger)radius {
  [self ui_setCornerRadius:radius withBackgroundColor:nil];
}

- (void)ui_setCornerRadius:(NSUInteger)radius withBackgroundColor:(UIColor *)backgroundColor {
  [self ui_setCornerRadius:radius withBackgroundColor:backgroundColor borderColor:nil borderWidth:0];
}

- (void)ui_setCornerRadius:(NSUInteger)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
  [self ui_setCornerRadius:radius withBackgroundColor:nil borderColor:borderColor borderWidth:borderWidth];
}

- (void)ui_setCornerRadius:(NSUInteger)radius withBackgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
  self.layer.cornerRadius = radius;
  self.layer.backgroundColor = [backgroundColor CGColor];
  self.layer.borderColor = [borderColor CGColor];
  self.layer.borderWidth = borderWidth;
  
  self.layer.masksToBounds = YES;
}


- (void)ui_setPathRadius:(CGFloat)radius withRoundedRect:(CGRect)rect{
  UIBezierPath *btnPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = btnPath.CGPath;
  shapeLayer.lineWidth = .8;
  shapeLayer.strokeColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1].CGColor;
  [shapeLayer strokeColor];
  shapeLayer.fillColor = [UIColor clearColor].CGColor;
  [self.layer addSublayer:shapeLayer];
}


@end
