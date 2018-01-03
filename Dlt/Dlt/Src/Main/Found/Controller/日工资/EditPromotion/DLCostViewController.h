//
//  DLCostViewController.h
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLCostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)NSString *AdTitle;
@property (nonatomic , assign)BOOL isLink;
@property (nonatomic , strong)NSString *linkTitle;
@property (nonatomic , strong)NSString *covorImage;
@property (nonatomic , strong)NSString *cityCodeStr;
@end
