//
//  DLTCircleoffriendDetailViewController.h
//  Dlt
//
//  Created by Gavin on 17/5/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DltBaseViewController.h"
#import "DltUICommon.h"

@class DLTCircleoffriendDetailViewController;
@protocol DLTCircleoffriendDetailDelegate  <NSObject>

@optional
- (void)circleoffriendDetailDelegate:(DLTCircleoffriendDetailViewController *)viewController circleofFriendModel:(DLTCircleofFriendDynamicModel *)model;

@end

@interface DLTCircleoffriendDetailViewController : DltBaseViewController

- (instancetype)initWithCircleoffriendDetailViewController:(DLTCircleofFriendDynamicModel *)model DLT_DESIGNATED_INITIALIZER;

@property (nonatomic ,weak) id<DLTCircleoffriendDetailDelegate>delegate;
@property (nonatomic , assign)BOOL isMine;


@end
