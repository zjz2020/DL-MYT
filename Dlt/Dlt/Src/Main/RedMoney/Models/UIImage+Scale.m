//
//  UIImage+Scale.m
//  Dlt
//
//  Created by Fang on 2018/1/17.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // borderWidth 表示边框的宽度
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat borderWidth = 1;
    // borderColor表示边框的颜色
    [[UIColor redColor] set];
    CGFloat bigRadius = newsize.width * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    [img drawInRect:CGRectMake(borderWidth, borderWidth, newsize.width, newsize.height)];
    
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/*
 // borderWidth 表示边框的宽度
 CGFloat imageW = image.size.width + 2 * borderWidth;
 CGFloat imageH = imageW;
 CGSize imageSize = CGSizeMake(imageW, imageH);
 UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
 CGContextRef context = UIGraphicsGetCurrentContext();
 // borderColor表示边框的颜色
 [borderColor set];
 CGFloat bigRadius = imageW * 0.5;
 CGFloat centerX = bigRadius;
 CGFloat centerY = bigRadius;
 CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
 CGContextFillPath(context);
 CGFloat smallRadius = bigRadius - borderWidth;
 CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
 CGContextClip(context);
 [image drawInRect:CGRectMake(borderWidth, borderWidth, image.frame.size.width, image.frame.size.height)];
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 */
@end
