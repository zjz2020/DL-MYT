//
//  DLListTableViewCell.h
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLListStatus.h"
@class DLListStatus;
@interface DLListTableViewCell : UITableViewCell
@property (nonatomic , strong)DLListStatus *status;
@end
