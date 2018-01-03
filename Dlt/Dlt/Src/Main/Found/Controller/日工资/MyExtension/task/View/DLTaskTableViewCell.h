//
//  DLTaskTableViewCell.h
//  Dlt
//
//  Created by USER on 2017/9/20.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTaskStatus.h"
@class DLTaskStatus;
@interface DLTaskTableViewCell : UITableViewCell
@property (nonatomic , assign)BOOL isTextAndeImage;
@property (nonatomic , strong)DLTaskStatus *status;
@end
