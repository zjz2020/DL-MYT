//
//  UIViewController+DltUI.m
//  Dlt
//
//  Created by Gavin on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+DltUI.h"
#import "MBProgressHUD+Extension.h"

@interface UIViewController ()

@property (nonatomic, weak) MBProgressHUD *HUD;

@end

static char kHUDKeyIdentifier;

@implementation UIViewController (DltUI)

#pragma mark - HUD

- (void)setHUD:(MBProgressHUD *)HUD {
  [self willChangeValueForKey:@keypath(self, HUD)];
  objc_setAssociatedObject(self, &kHUDKeyIdentifier, HUD, OBJC_ASSOCIATION_ASSIGN);
  [self didChangeValueForKey:@keypath(self, HUD)];
}

- (MBProgressHUD *)HUD {
  return objc_getAssociatedObject(self, &kHUDKeyIdentifier);
}

- (void)showHUD:(NSString *)message block:(BOOL)block{
  if (self.HUD) self.HUD.labelText = message;  
  self.HUD = [MBProgressHUD showMessage:message toView:block? nil: self.view];
}

- (void)hideHUD{
  if (self.HUD) {
    [self.HUD hide:YES];
    self.HUD = nil;
  }
}



@end
