//
//  UIView+XDFrame.h
//  我的微博
//
//  Created by derrick on 15/12/14.
//  Copyright © 2015年 derrick. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIView (XDFrame)
 */
@interface UIView (XDFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign,readonly) CGFloat maxY;
@property (nonatomic, assign,readonly) CGFloat maxX;


@end
