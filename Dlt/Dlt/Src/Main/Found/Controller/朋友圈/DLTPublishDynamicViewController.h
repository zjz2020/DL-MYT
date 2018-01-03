//
//  DLTPublishDynamicViewController.h
//  Dlt
//
//  Created by Gavin on 17/5/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BaseTableViewController.h"

@class DLTPublishDynamicViewController;

@protocol DLTPublishDynamicDelegate <NSObject>

@optional
- (void)publishDynamicViewController:(DLTPublishDynamicViewController *)viewController
           didPublishDynamicMessages:(NSString *)content
                    publishedDynamic:(BOOL)isSuccessful;
@end

@interface DLTPublishDynamicViewController : UIViewController

@property (nonatomic ,weak) id<DLTPublishDynamicDelegate>delegate;

@end
