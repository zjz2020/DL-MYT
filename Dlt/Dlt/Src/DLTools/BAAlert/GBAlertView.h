//
//  GBAlertView.h
//  测试demo
//
//  Created by mac on 2017/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^itemClickAtIndex)(NSInteger itemIndex);

@interface GBAlertView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *titles;//

@property (nonatomic, copy) itemClickAtIndex itemIndex;

+ (GBAlertView *)showWithtTtles:(NSArray *)titles
                    itemIndex:(itemClickAtIndex)itemIndex;
@end
