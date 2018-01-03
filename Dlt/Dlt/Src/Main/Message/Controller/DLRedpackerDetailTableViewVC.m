//
//  DLRedpackerDetailTableViewVC.m
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLRedpackerDetailTableViewVC.h"
#import "DLRedpackerDetailCell.h"
#import "UIView+Extension.h"
#import "DLRedpackerInfoModel.h"
#import "DLRedpackerRecordModel.h"
#import "DLFriendPacketModel.h"
#import "RCHttpTools.h"



@interface DLRedpackerDetailTableViewVC ()

@property (weak, nonatomic) IBOutlet UILabel *getMoney;
@property (weak, nonatomic) IBOutlet UIImageView *senderHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *senderNickName;
@property (weak, nonatomic) IBOutlet UILabel *senderRemark;
@property (weak, nonatomic) IBOutlet UILabel *redpackerDetail;
@property (weak, nonatomic) IBOutlet UILabel *yourRedpacker;
@property (weak, nonatomic) IBOutlet UILabel *deposited;

@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation DLRedpackerDetailTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.senderHeadImg ui_setCornerRadius:6];

    
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)setRedpackerInfo:(DLRedpackerInfo *)redpackerInfo {
    _redpackerInfo = redpackerInfo;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkRedpackerReceiveDetailWithRedpackerId:[NSString stringWithFormat:@"%ld",self.redpackerInfo.rpId]];
        
        self.getMoney.text = [NSString stringWithFormat:@"%.2f",self.redpackerInfo.myGetAmount / 100.0];
        self.redpackerDetail.text = [NSString stringWithFormat:@"领取%ld/%ld个  %ld个红包，共%.2f元",self.redpackerInfo.totalCount - self.redpackerInfo.remainCount,self.redpackerInfo.totalCount,self.redpackerInfo.totalCount,self.redpackerInfo.totalAmount / 100.0];
        self.senderRemark.text = self.redpackerInfo.note;
        [self.senderHeadImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,self.redpackerInfo.userHeadImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
        self.senderNickName.text = self.redpackerInfo.userName;
        
        if (self.redpackerInfo.myGetAmount == 0) {
            self.getMoney.font = [UIFont systemFontOfSize:25];
            self.getMoney.text = @"红包已派完，下次再努力";
            self.yourRedpacker.hidden = YES;
            self.deposited.hidden = YES;
        }
    });
}

- (void)setModel:(DLFriendPacketModel *)model {
    _model = model;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.senderHeadImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.userHead]] placeholderImage:[UIImage imageNamed:@"wallet_11.png"]];
        self.senderNickName.text = model.userName;
        self.senderRemark.text = model.note;
        self.getMoney.text = [NSString stringWithFormat:@"%.2f",[model.amount integerValue] / 100.0];
        self.redpackerDetail.text = [NSString stringWithFormat:@"1个红包 共%.2f元",[model.amount floatValue] / 100.0];
    });
    @weakify(self)
    [[RCHttpTools shareInstance] getFriendRedpacketRecordWithRedpacketId:model.rpId handle:^(NSArray *models) {
        @strongify(self)
        [self.dataArr addObjectsFromArray:models];
        [self.tableView reloadData];
    }];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLRedpackerDetailCell *cell = [DLRedpackerDetailCell creatRedpackerCellWithTableView:tableView];
    cell.recordModel = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)checkRedpackerReceiveDetailWithRedpackerId:(NSString *)redpackerId {
    NSString *url = [NSString stringWithFormat:@"%@Wallet/redpacketRecord",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"rpid" : redpackerId
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        DLRedpackerRecordModel *model = [DLRedpackerRecordModel modelWithJSON:response];
        if (model.code == 1) {
            [self.dataArr addObjectsFromArray:model.data];
        }
        [self.tableView reloadData];
    }failureBlock:^(NSError *error) {
        
    } progress:nil];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
