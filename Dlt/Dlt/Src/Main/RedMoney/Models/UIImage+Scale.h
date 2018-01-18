//
//  UIImage+Scale.h
//  Dlt
//
//  Created by Fang on 2018/1/17.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
@end
