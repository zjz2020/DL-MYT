//
//  UIViewController+DltUI.h
//  Dlt
//
//  Created by Gavin on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DltUI)

#pragma mark - HUD

- (void)showHUD:(NSString *)message block:(BOOL)block;
- (void)hideHUD;

@end
