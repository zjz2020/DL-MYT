//
//  BaseTableViewController.h
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
-(void)back:(NSString*)image;
-(void)rightItem:(NSString *)image;
-(void)rightclick;
-(void)backclick;
-(void)rightTitle:(NSString *)title;
-(void)rightclicks;
@end
