//
//  DltCommonMacro.h
//  Dlt
//
//  Created by Gavin on 17/5/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#ifndef DltCommonMacro_h
#define DltCommonMacro_h

#ifdef NS_DESIGNATED_INITIALIZER
#   define DLT_DESIGNATED_INITIALIZER    NS_DESIGNATED_INITIALIZER
#else
#   define DLT_DESIGNATED_INITIALIZER
#endif

#ifndef DLT_EXTERN
# define DLT_EXTERN extern
#endif

#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kScreenScale    ([UIScreen mainScreen].bounds.size.width)/320

#define kCurrentSysVersion ([[[UIDevice currentDevice] systemVersion] floatValue])


#define ISNULLARRAY(arr) (arr == nil || (NSObject *)arr == [NSNull null] || arr.count == 0)
#define ISOBJ(obj) (obj == nil || (NSObject *)obj == [NSNull null])
#define ISNULLSTR(str) (str == nil || (NSObject *)str == [NSNull null] || str.length == 0 )


#define DLT_URL(str) ([NSURL URLWithString:str])
#define DLT_STRCMP(s1, s2) ([s1 isEqualToString:s2])


// Quick & Easy Shorthand for RGB x HSB Colors
// The reason we don't import our Macro file is to prevent naming conflicts.
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define hsba(h,s,b,a) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:a]
#define hsb(h,s,b) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:1.0]
#define UICOLORRGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define NAVIH  self.navigationController.navigationBar.frame.size.height + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define SafeAreaBottomHeight (HEIGHT == 812.0 ? 34 : 0)
#define DLBLUECOLOR  [UIColor colorWithRed:21/255.0f green:103/255.0f blue:241/255.0f alpha:1.0]
#endif /* DltCommonMacro_h */
