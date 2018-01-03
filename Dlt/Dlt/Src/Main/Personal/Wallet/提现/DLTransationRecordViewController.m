//
//  DLTransationRecordViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/20.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTransationRecordViewController.h"
#import "TranscationCell.h"
#import "TransactionrecordsModel.h"

@interface DLTransationRecordViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation DLTransationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"交易记录";
    
    self.tableView.tableFooterView = [UIView new];
    
    [self dl_networkForTransactionrecords];
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TranscationCell *cell = [TranscationCell creatRecordCellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - 网络请求
- (void)dl_networkForTransactionrecords {
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary * dic = @{
                           @"token":[DLTUserCenter userCenter].token,
                           @"uid":user.uid
                           };
    NSString * url = [NSString stringWithFormat:@"%@Wallet/tranRecords",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        TransactionrecordsModel *model = [TransactionrecordsModel modelWithJSON:response];
        if ([model.code integerValue] == 1) {
            [self.dataArr addObjectsFromArray:model.data];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}




@end
