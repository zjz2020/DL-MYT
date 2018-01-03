//
//  UIImageView+Extension.m
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "UIImageView+Extension.h"
#import <YYKit/YYKit.h>

@implementation UIImageView (Extension)

// 渐变 模糊加载
- (void)ui_setImageDefaultOperationWithURL:(NSString *)url{
  [self ui_setImageDefaultOperationWithURL:url placeholder:nil];
}

- (void)ui_setImageDefaultOperationWithURL:(NSString *)url placeholder:(UIImage *)placeholder{
  [ self setImageWithURL:[NSURL URLWithString:url]
             placeholder:placeholder
                 options:YYWebImageOptionProgressiveBlur |YYWebImageOptionSetImageWithFadeAnimation
              completion:NULL];
}

- (void)ui_imageViewAddGestureRecognizerTarget:(id)target action:(SEL)action{
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
  [self addGestureRecognizer:tap];
}


@end
