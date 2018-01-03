//
//  DLTPublishDynamicVisibleAlertView.h
//  Dlt
//
//  Created by Gavin on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLTComposeToolbar.h"

@interface DLTPublishDynamicVisibleAlertView : UIView

- (void)pop:(DLTPublishDynamicVisibleType)visible visibleChange:(void (^)(DLTPublishDynamicVisibleType type))visibleBlock;

@end
