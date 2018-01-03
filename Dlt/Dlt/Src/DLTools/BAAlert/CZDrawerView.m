//
//  CZDrawerView.m
//  YHHCbc
//
//  Created by CZHH-12 on 17/3/28.
//  Copyright © 2017年 CZ. All rights reserved.
//

#import "CZDrawerView.h"
#import "UIView+XDFrame.h"

 CGFloat const gestureMinimumTranslation = 2.0 ;

@interface CZDrawerView ()<UIGestureRecognizerDelegate>

{
    UISwipeGestureRecognizer *swipeGes;
    
    CGPoint beginPoint;
    
    CZDrawerAnimationDirection moveDirection;
}

/**
 *父视图
 */
@property (nonatomic, weak)UIView *parentView;

/**
 *contentView原本的frame
 */
@property (nonatomic, assign)CGRect contentViewFrame;

/**
 *抽屉视图
 */
@property (nonatomic, weak)UIView * drawerContentView;

@end

@implementation CZDrawerView

/**
 *返回此类的实例
 
 @param parentView 父视图
 @param color 抽屉背景颜色
 @param frame 坐标大小
 @return 实例对象
 */
- (id)initWithParentView:(UIView *)parentView
          DefaultColor:(UIColor *)color
                 frame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.drawerBackGroundColor = color;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clikedCover:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        _parentView = parentView;
        [_parentView addSubview:self];
        [_parentView bringSubviewToFront:self];
        
        self.hidden = YES;
    }
    return self;

}

#pragma mark - 手势事件
/**
 *滑动了视图

 @param swipe 滑动手势
 */
- (void)swipeCover:(UISwipeGestureRecognizer *)swipe {
    CGPoint point = [swipe locationInView:self];
    
    if(!CGRectContainsPoint(self.drawerContentView.frame, point)){
        [self hide];
    }
}

/**
 *点击了内容视图以外的蒙层

 @param tap 点击手势
 */
- (void)clikedCover:(UITapGestureRecognizer*)tap {
    CGPoint point = [tap locationInView:self];
    
    if(!CGRectContainsPoint(self.drawerContentView.frame, point)){
        [self hide];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //防止父视图手势对子视图的影响
    if ([touch.view isDescendantOfView:self.drawerContentView]) {
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark 动画
- (void)setShowAnimation:(CZDrawerAnimationDirection)showAnimation {
    
    _showAnimation = showAnimation;
    
    if (!swipeGes) {
        swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeCover:)];
        [self addGestureRecognizer:swipeGes];
    }
    
    switch (_showAnimation) {
        case CZDrawerAnimationDirectionNone:
            [self removeGestureRecognizer:swipeGes];
            swipeGes = nil;
            break;
        case CZDrawerAnimationDirectionTop:
            swipeGes.direction = UISwipeGestureRecognizerDirectionDown;
            break;
        case CZDrawerAnimationDirectionLeft:
            swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
            break;
        case CZDrawerAnimationDirectionRight:
            swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
            break;
        case CZDrawerAnimationDirectionBottom:
            swipeGes.direction = UISwipeGestureRecognizerDirectionUp;
            break;
        default:
            break;
    }
}

/**
 *更改或获得内容视图
 */
- (void)setContentView:(UIView *)contentView {
    
    if(_drawerContentView !=contentView) {
        
        [_drawerContentView removeFromSuperview];
        _drawerContentView = contentView;
        _contentViewFrame = _drawerContentView.frame;

        [self addSubview:_drawerContentView];
        
    }
    
}
- (UIView *)contentView {
    return _drawerContentView;
}

/**
 *更改或获得背景颜色
 */
- (void)setDrawerBackGroundColor:(UIColor *)drawerBackGroundColor {
    
    _drawerBackGroundColor = drawerBackGroundColor;
    self.backgroundColor = _drawerBackGroundColor;
    
}

/**
 *更改或获得背景透明度
 */
- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    
    self.backgroundColor = [_drawerBackGroundColor colorWithAlphaComponent:backgroundAlpha];
    
}

/**
 *弹出抽屉
 */
- (void)show {
    self.hidden = NO;
    if (!_drawerContentView) return;
    [self showAnimationWithTargetFrame:_contentViewFrame delay:_delay completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(drawerViewDidShow:)]) {
            [_delegate drawerViewDidShow:self];
        }
    }];
}

/**
 *开始一个显示动画

 @param frame 目标frame
 @param delay 动画时间
 @param completion 动画完成后要做的事
 */
- (void)showAnimationWithTargetFrame:(CGRect)frame delay:(NSInteger)delay completion:(void (^ __nullable)(BOOL finished))completion {
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    switch (_showAnimation) {
        case CZDrawerAnimationDirectionNone:
            
            break;
        case CZDrawerAnimationDirectionTop:
            self.drawerContentView.y = self.height;
            break;
        case CZDrawerAnimationDirectionLeft:
            self.drawerContentView.x = self.width;
            break;
        case CZDrawerAnimationDirectionRight:
            self.drawerContentView.x = - width;
            break;
        case CZDrawerAnimationDirectionBottom:
            self.drawerContentView.y = - height;
            break;
        default:
            break;
    }

    [UIView animateWithDuration:_delay delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.drawerContentView.frame = frame;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

/**
 *隐藏抽屉
 */
- (void)hide {
    [self hideAnimationWithTargetFrame:self.drawerContentView.frame delay:_delay completion:^(BOOL finished) {
        self.hidden = YES;
        if ([_delegate respondsToSelector:@selector(drawerViewDidHide:)]) {
            [_delegate drawerViewDidHide:self];
        }
    }];
}

/**
 *开始一个隐藏动画
 
 @param frame 目标frame
 @param delay 动画时间
 @param completion 动画完成后要做的事
 */
- (void)hideAnimationWithTargetFrame:(CGRect)frame delay:(NSInteger)delay completion:(void (^ __nullable)(BOOL finished))completion {
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGRect newFrame = frame;
    switch (_showAnimation) {
        case CZDrawerAnimationDirectionNone:
            
            break;
        case CZDrawerAnimationDirectionTop:
            newFrame.origin.y = self.height;
            break;
        case CZDrawerAnimationDirectionLeft:
            newFrame.origin.x = self.width;
            break;
        case CZDrawerAnimationDirectionRight:
            newFrame.origin.x = - width;
            break;
        case CZDrawerAnimationDirectionBottom:
            newFrame.origin.y = - height;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:_delay delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.drawerContentView.frame = newFrame;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
    
}



/**
 *touch事件

 @return
 */
#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    beginPoint =[[touches anyObject] locationInView:self];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (swipeGes) {
        [self removeGestureRecognizer:swipeGes];
        swipeGes = nil;
    }
    
    
    CGPoint currentPt=[[touches anyObject] locationInView:self];
    CGPoint parentPt = [[touches anyObject] previousLocationInView:self];
    
    [self judgeMoveDirectionCurPt:currentPt parPt:parentPt];
    
    switch (_showAnimation) {
        case CZDrawerAnimationDirectionNone:
            break;
        case CZDrawerAnimationDirectionTop:
        {
            CGFloat heightDiff = currentPt.y - beginPoint.y;

            if (moveDirection == CZDrawerAnimationDirectionTop) {
                if (heightDiff < 0) {
                    beginPoint = currentPt;
                    self.drawerContentView.y =_contentViewFrame.origin.y;
                    return;
                }
            }
            
            self.drawerContentView.y =_contentViewFrame.origin.y + heightDiff;
        }
            break;
        case CZDrawerAnimationDirectionLeft:
        {
            CGFloat widthDiff = currentPt.x - beginPoint.x;

            if (moveDirection == CZDrawerAnimationDirectionLeft) {
                if (widthDiff < 0) {
                    beginPoint = currentPt;
                    self.drawerContentView.x =_contentViewFrame.origin.x;
                    return;
                }
            }
            self.drawerContentView.x =_contentViewFrame.origin.x + widthDiff;
        }
            break;
        case CZDrawerAnimationDirectionRight:
        {
            CGFloat widthDiff = currentPt.x - beginPoint.x;

            if (moveDirection == CZDrawerAnimationDirectionRight) {
                if (widthDiff > 0) {
                    beginPoint = currentPt;
                    self.drawerContentView.x =_contentViewFrame.origin.x;
                    return;
                }
            }
            
            self.drawerContentView.x =_contentViewFrame.origin.x +widthDiff;
        }
            break;
        case CZDrawerAnimationDirectionBottom:
        {
            CGFloat heightDiff = currentPt.y - beginPoint.y;

            if (moveDirection == CZDrawerAnimationDirectionBottom) {
                if (heightDiff > 0) {
                    beginPoint = currentPt;
                    self.drawerContentView.y =_contentViewFrame.origin.y;
                    return;
                }
            }
            
            self.drawerContentView.y =_contentViewFrame.origin.y + heightDiff;
        }
            break;
        default:
            break;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (!swipeGes) {
        self.showAnimation = _showAnimation;
    }
    
    
    CGFloat diff_x = fabs(fabs(self.drawerContentView.x) - fabs(_contentViewFrame.origin.x));
    CGFloat diff_y = fabs(fabs(self.drawerContentView.y) - fabs(_contentViewFrame.origin.y));
    
    if (diff_x >=self.drawerContentView.width/2 || diff_y >= self.drawerContentView.height/2) {
        
        [self hide];
        
    }else {
        if (!_drawerContentView) return;
        [UIView animateWithDuration:_delay delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.drawerContentView.frame = _contentViewFrame;
        } completion:^(BOOL finished) {
            if ([_delegate respondsToSelector:@selector(drawerViewDidEndMove:)]) {
                [_delegate drawerViewDidEndMove:self];
            }
        }];
    }
    
}

- (void)judgeMoveDirectionCurPt:(CGPoint)curPt
                          parPt:(CGPoint)parPt {
    switch (_showAnimation) {
        case CZDrawerAnimationDirectionNone:
            
            break;
        case CZDrawerAnimationDirectionBottom:
            
            if (curPt.y>parPt.y) {
                moveDirection = CZDrawerAnimationDirectionBottom;
            }else {
                moveDirection = CZDrawerAnimationDirectionTop;
            }
            break;
        case CZDrawerAnimationDirectionTop:
            
            if (curPt.y>parPt.y) {
                moveDirection = CZDrawerAnimationDirectionBottom;
            }else {
                moveDirection = CZDrawerAnimationDirectionTop;
            }
            break;
            
        case CZDrawerAnimationDirectionLeft:
            
            if (curPt.x>parPt.x) {
                moveDirection = CZDrawerAnimationDirectionRight;
            }else {
                moveDirection = CZDrawerAnimationDirectionLeft;
            }
            break;
        case CZDrawerAnimationDirectionRight:
            
            if (curPt.x>parPt.x) {
                moveDirection = CZDrawerAnimationDirectionRight;
            }else {
                moveDirection = CZDrawerAnimationDirectionLeft;
            }
            break;
        default:
            break;
    }
    
}

- (void)dealloc {
    NSLog(@"抽屉释放了");
}

@end
