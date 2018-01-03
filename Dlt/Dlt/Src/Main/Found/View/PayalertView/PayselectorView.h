//
//  PayselectorView.h
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupandStoreCell.h"
#define GroupandStoreCellIdenfier @"GroupandStoreCellIdenfier"
@interface PayselectorView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * selectorView;
@end
