//
//  DLPayNewsViewController.m
//  Dlt
//
//  Created by USER on 2017/9/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLPayNewsViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "DLPayNewsTableViewCell.h"
@interface DLPayNewsViewController ()
@property (nonatomic , strong)UITableView *tableView;

@end

@implementation DLPayNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [UITableView new];
    _tableView.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .rightSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
     [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:6 targetId:@"99999999"];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _statuses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"PAYCELL";
    DLPayNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell = [[DLPayNewsTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.status = _statuses[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
