//
//  DLDetailTaskViewController.h
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTaskStatus.h"
@class DLTaskStatus;
@interface DLDetailTaskViewController : UIViewController

@property (nonatomic , strong)DLTaskStatus *status;
@end
