//
//  DLPayNewsViewController.h
//  Dlt
//
//  Created by USER on 2017/9/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLPayNewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSArray *statuses;
@end
