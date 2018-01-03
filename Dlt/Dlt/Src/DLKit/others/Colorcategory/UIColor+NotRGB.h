//
//  UIColor+NotRGB.h
//  slider_RGB
//
//  Created by Keje on 2016/11/30.
//  Copyright © 2016年 Keje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NotRGB)

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)ColorWithHexString:(NSString *)color;

@end
