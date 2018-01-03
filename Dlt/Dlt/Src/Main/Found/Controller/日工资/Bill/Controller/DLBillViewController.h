//
//  DLBillViewController.h
//  Dlt
//
//  Created by USER on 2017/9/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLBillViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSString *time;
@property (nonatomic , strong)NSString *payIn;
@property (nonatomic , strong)NSString *payOut;
@end
