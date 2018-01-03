//
//  DLBillTableViewCell.h
//  Dlt
//
//  Created by USER on 2017/9/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLBillStatus.h"
@class DLBillStatus;
@interface DLBillTableViewCell : UITableViewCell
@property (nonatomic , strong)DLBillStatus *status;
@property (nonatomic , strong)NSString *payIn;
@property (nonatomic , strong)NSString *payOut;
@end
