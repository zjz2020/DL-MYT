//
//  DLFirstBillViewController.m
//  Dlt
//
//  Created by USER on 2017/11/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLFirstBillViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLBillViewController.h"
#import "DLBillTableViewCell.h"
@interface DLFirstBillViewController ()
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *status;
@end

@implementation DLFirstBillViewController
-(NSMutableArray *)status{
    if (_status == nil) {
        _status = [NSMutableArray array];
    }return _status;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self HttpTabelViewData];
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    // Do any additional setup after loading the view.
}
-(void)HttpTabelViewData{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/DaywagesRecord2",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
 @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
         @strongify(self)
        NSLog(@"%@",response);
        self.status = (NSMutableArray *)response[@"data"][@"months"];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
       
    } progress:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.status.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"BILLCELL";
    DLBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DLBillTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.payIn = [_status[indexPath.section] valueForKey:@"income"];
    }else{
        cell.payOut = [_status[indexPath.section] valueForKey:@"outcome"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *headerViewId = @"ResultheaderViewId";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    headerView.contentView.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    UILabel *label = [UILabel new];

    label.text = [self.status[section] valueForKey:@"month"];
    [headerView addSubview:label];
    label.sd_layout
    .centerYEqualToView(headerView)
    .leftSpaceToView(headerView, 10)
    .heightIs(20)
    .widthIs(100);
    UILabel *xqLabel = [UILabel new];
    
    xqLabel.text = @"详情";
    [headerView addSubview:xqLabel];
    xqLabel.sd_layout
    .centerYEqualToView(headerView)
    .rightSpaceToView(headerView, 0)
    .heightIs(20)
    .widthIs(50);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [headerView addSubview:btn];
    [btn addTarget:self action:@selector(upButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 100+section;
    btn.sd_layout
    .topSpaceToView(headerView, 0)
    .rightSpaceToView(headerView, 0)
    .leftSpaceToView(headerView, 0)
    .bottomSpaceToView(headerView, 0);
    return headerView;
    
}
-(void)upButton:(UIButton *)btn{
    DLBillViewController *sdView = [DLBillViewController new];
    sdView.time =[_status[btn.tag -100]valueForKey:@"month"];
    sdView.payIn = [_status[btn.tag -100]valueForKey:@"income"];
    sdView.payOut = [_status[btn.tag -100]valueForKey:@"outcome"];
    [self.navigationController pushViewController:sdView animated:YES];
}
@end
