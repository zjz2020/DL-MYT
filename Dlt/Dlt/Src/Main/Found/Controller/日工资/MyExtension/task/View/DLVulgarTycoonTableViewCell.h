//
//  DLVulgarTycoonTableViewCell.h
//  Dlt
//
//  Created by USER on 2017/9/23.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTaskStatus.h"
@class DLTaskStatus;
@interface DLVulgarTycoonTableViewCell : UITableViewCell
@property (nonatomic , assign)BOOL isTextAndeImage;
@property (nonatomic , strong)DLTaskStatus *status;
@end
