//
//  DLListViewController.h
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSString *adID;
@end
