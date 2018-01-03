//
//  UIImageView+Extension.h
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

- (void)ui_setImageDefaultOperationWithURL:(NSString *)url;
- (void)ui_setImageDefaultOperationWithURL:(NSString *)url placeholder:(UIImage *)placeholder;


- (void)ui_imageViewAddGestureRecognizerTarget:(id)target action:(SEL)action;



@end
