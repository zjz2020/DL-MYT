//
//  DLListViewController.m
//  Dlt
//
//  Created by USER on 2017/9/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLListViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLListTableViewCell.h"
#import "DLListStatus.h"
#import <MJExtension/MJExtension.h>
#import "DLUserInfDetailViewController.h"

@interface DLListViewController ()
@property (nonatomic , strong)UITableView *tabelView;
@property (nonatomic , strong)NSMutableArray *statuses;
@end

@implementation DLListViewController
-(NSMutableArray *)statuses{
    if (_statuses == nil) {
        _statuses = [NSMutableArray array];
    }return _statuses;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"推手列表";
    [self httpTableViewData];
    _tabelView = [UITableView new];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableFooterView = [UIView new];
    [self.view addSubview:_tabelView];
    _tabelView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}
//推手列表
-(void)httpTableViewData{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/PromoterList",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"adid":_adID,
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        NSLog(@"%@",response);
        self.statuses =[DLListStatus mj_objectArrayWithKeyValuesArray:[response valueForKey:@"data"]];
        [self.tabelView reloadData];
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"网络延迟稍后重试"];
    } progress:nil];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.statuses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"LISTCELL";
    DLListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DLListTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
    cell.status = self.statuses[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    DLUserInfDetailViewController *sdView = [DLUserInfDetailViewController new];
//    sdView.otherUserId = [_statuses valueForKey:@""][indexPath.row];
//    [self.navigationController pushViewController:sdView animated:YES];
}
@end
