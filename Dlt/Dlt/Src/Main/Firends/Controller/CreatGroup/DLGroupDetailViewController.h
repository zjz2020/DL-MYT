//
//  DLGroupDetailViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGroupsInfo;


@interface DLGroupDetailViewController : UIViewController

@property (nonatomic, assign) BOOL isJoined;
@property (nonatomic, strong) DLGroupsInfo *groupsInfo;
@end
