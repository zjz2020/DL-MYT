//
//  CZDrawerView.h
//  YHHCbc
//
//  Created by CZHH-12 on 17/3/28.
//  Copyright © 2017年 CZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZDrawerView;
/**
 *contentView显示或消失或拖动方向

 - CZDrawerAnimationDirectionTop: 向上
 */
typedef NS_ENUM(NSUInteger, CZDrawerAnimationDirection) {
    CZDrawerAnimationDirectionNone,//没动画
    CZDrawerAnimationDirectionTop,//向上
    CZDrawerAnimationDirectionLeft,//向左
    CZDrawerAnimationDirectionRight,//向右
    CZDrawerAnimationDirectionBottom//向下
};

@protocol CZDrawerViewDelegate <NSObject>

@optional
/**
 *抽屉显示动画结束

 @param drawerView 实例
 */
- (void)drawerViewDidShow:(CZDrawerView *)drawerView;

/**
 *抽屉拖动动画结束

 @param drawerView 实例
 */
- (void)drawerViewDidEndMove:(CZDrawerView *)drawerView;

/**
 *抽屉隐藏动画结束

 @param drawerView 实例
 */
- (void)drawerViewDidHide:(CZDrawerView *)drawerView;

@end


@interface CZDrawerView : UIView

@property (nonatomic, weak)id delegate;

/**
 *返回此类的实例

 @param parentView 父视图
 @param color 抽屉背景颜色
 @param frame 坐标大小
 @return 实例对象
 */
- (id)initWithParentView:(UIView *)parentView
          DefaultColor:(UIColor *)color
                 frame:(CGRect)frame;

/**
 *抽屉背景颜色
 */
@property (nonatomic, copy)UIColor *drawerBackGroundColor;

/**
 *背景图的透明度
 */
@property (nonatomic, assign)CGFloat backgroundAlpha;

/**
 *自定义展示视图 用于显示内容 放在背景图上 不强引用子视图
 */
@property (nonatomic, weak)UIView *contentView;

/**
 *弹出方向 动画的方向要根据contentView大小和坐标来决定 不然很怪异
 *子视图收回的方向和弹出相反 
 *如果为空 则没有动画效果 
 */
@property (nonatomic, assign)CZDrawerAnimationDirection showAnimation;

/**
 *动画时间
 */
@property (nonatomic, assign)CGFloat delay;

/**
 *弹出抽屉 若contentView为空则只显示蒙层 没有效果
 */
- (void)show;

/**
 *隐藏抽屉
 */
- (void)hide;
@end
