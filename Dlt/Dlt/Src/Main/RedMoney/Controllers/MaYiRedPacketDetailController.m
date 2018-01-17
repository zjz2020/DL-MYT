//
//  MaYiRedPacketDetailController.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiRedPacketDetailController.h"
#import "MaYiRedPacketDetailCell.h"
#import "MaYiRedPacketDetailHeadView.h"
#import "MYRedListModel.h"
#import <MJRefresh/MJRefresh.h>
#define MyReceiveAntMoneyList       @"mayi/mayi_rp_record"//我的蚂蚁红包领取记录

#define MaYiRedPacketDetailCellIdenifer @"redPacketReuseIdentifier"

@interface MaYiRedPacketDetailController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView     * mainTableView;

//数据列表
@property (nonatomic , strong)NSMutableArray *dataArray;

//总红包数
@property (nonatomic, copy)NSString *allCount;
@end

@implementation MaYiRedPacketDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包明细";
    self.allCount = @"0.00";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self requestData];
    [self antGetRedMoneyList];
    [self addrightitem];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(antGetRedMoneyList)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.DidDissAppearBlock();
}

#pragma -mark  -------------    代理方法  ------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MaYiRedPacketDetailHeadView * headView = [[MaYiRedPacketDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.97)];
    headView.num = self.allCount;
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kScreenWidth/1.97;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenWidth/6.25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MaYiRedPacketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MaYiRedPacketDetailCellIdenifer];
    if(!cell){
        cell = [[MaYiRedPacketDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MaYiRedPacketDetailCellIdenifer];
    }
    if (indexPath.row <= self.dataArray.count -1) {
    
        cell.redListModel = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma -mark  -------------    私有方法  ------------

-(void)addrightitem {
    UIButton * leftbtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    [leftbtn setImage:[UIImage imageNamed:@"friends_15"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//领取红包记录
- (void)antGetRedMoneyList{
    NSString *GetRedMoneyList = [NSString stringWithFormat:@"%@%@",BASE_URL,MyReceiveAntMoneyList];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *parameter = @{
                                @"uid":user.uid,
                                @"token":user.token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:GetRedMoneyList parameters:parameter successBlock:^(id response) {
        @strongify(self);
        [self redMoneyListWithDic:response];
    } failureBlock:^(NSError *error) {
        NSLog(@"antInfoGet:%@",error);
    } progress:nil];
    if (self.mainTableView.mj_header) {
        [self.mainTableView.mj_header endRefreshing];
    }
}
//处理红包列表
- (void)redMoneyListWithDic:(NSDictionary *)dic{
    NSDictionary *newDic = [dic dictValueForKey:@"data"];
    NSNumber *sum = [newDic numberValueForKey:@"sum"];
    CGFloat flotSum = [sum integerValue]/100;
    self.allCount = [NSString stringWithFormat:@"%.2f",flotSum];
     NSArray *array = [newDic arrayValueForKey:@"record"];
    NSMutableArray *testArray = [NSMutableArray new];
    for (NSDictionary *aDic in array) {
        MYRedListModel *model = [MYRedListModel showModel];
        [model modelSetWithDictionary:aDic];
        [testArray addObject:model];
    }
    self.dataArray = testArray;
    [self.mainTableView reloadData];
}

#pragma -mark  -------------    初始化  ------------

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

@end
