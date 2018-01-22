//
//  PayselectorView.m
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "PayselectorView.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation PayselectorView
#pragma clang diagnostic pop
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initui];
    }
    return self;
}
-(void)initui
{
//    self.selectorView = [[UITableView alloc]initWithFrame:RectMake_LFL(15, 0, 0, 438/2)];
//    self.selectorView.top_sd = (HEIGHT-438/2)/2;
//    self.selectorView.width_sd = WIDTH-30;
//    self.selectorView.delegate = self;
//    self.selectorView.dataSource = self;
//    [self addSubview:self.selectorView];
    
    
    
    
    
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 4;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 54;
//}
//-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger  row  =indexPath.row ;
//    if (row==0) {
//        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenfier];
//        if (cell == nil) {
//            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenfier];
//        }
//        [cell file:@{@"icon":@"",@"title":@"选择支付"}];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//    }else if (row==1)
//    {
//        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenfier];
//        if (cell == nil) {
//            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenfier];
//        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell file:@{@"icon":@"",@"title":@"支付宝"}];
//        return cell;
//    }else if (row==2)
//    {
//        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenfier];
//        if (cell == nil) {
//            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenfier];
//        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell file:@{@"icon":@"",@"title":@"微信"}];
//        return cell;
//    }else if (row==3)
//    {
//        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenfier];
//        if (cell == nil) {
//            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenfier];
//        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell file:@{@"icon":@"",@"title":@"银行卡"}];
//        return cell;
//    }
//
//    return nil;
//}




@end
