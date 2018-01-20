//
//  BaseNC.m
//  BaiduMapDemo
//
//  Created by hanzhanbing on 16/6/13.
//  Copyright © 2016年 asj. All rights reserved.
//

#import "BaseNC.h"
#import "AppDelegate.h"

@interface BaseNC ()

@end

@implementation BaseNC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor co]];
    [[UINavigationBar appearance] setTitleTextAttributes:
   [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"微软雅黑" size:24], NSFontAttributeName, nil]];
}

//设置界面切换动画
/*!
 typedef enum : NSUInteger {
 Fade = 1,                   //淡入淡出
 Push,                       //推挤
 Reveal,                     //揭开
 MoveIn,                     //覆盖
 Cube,                       //立方体
 SuckEffect,                 //吮吸
 OglFlip,                    //翻转
 RippleEffect,               //波纹
 PageCurl,                   //翻页
 PageUnCurl,                 //反翻页
 CameraIrisHollowOpen,       //开镜头
 CameraIrisHollowClose,      //关镜头
 CurlDown,                   //下翻页
 CurlUp,                     //上翻页
 FlipFromLeft,               //左翻转
 FlipFromRight,              //右翻转
 
 } AnimationType;
 */


//返回动画
-(void)backAnimation{
    AppDelegate *sap = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *bb =(UITabBarController *)sap.window.rootViewController;
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.5f];
//    [animation setType:@"FlipFromRight"];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[bb.view layer]addAnimation:animation forKey:@"switchView"];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
        [backBtn setImage:[UIImage imageNamed:@"friend_00"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        viewController.navigationItem.leftBarButtonItem = leftitem;
    }
    [super pushViewController:viewController animated:YES];
}
- (void)backclick {
    [self popViewControllerAnimated:YES];
}
@end
