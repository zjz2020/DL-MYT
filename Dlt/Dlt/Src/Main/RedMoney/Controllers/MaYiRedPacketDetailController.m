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
#define MaYiRedPacketDetailCellIdenifer @"redPacketReuseIdentifier"

@interface MaYiRedPacketDetailController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView     * mainTableView;

@end

@implementation MaYiRedPacketDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    [self addrightitem];
    [self.view addSubview:self.mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.DidDissAppearBlock();
}

#pragma -mark  -------------    代理方法  ------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MaYiRedPacketDetailHeadView * headView = [[MaYiRedPacketDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.97)];
    headView.num = @"65.123";
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

-(void)requestData{
    
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/otherUserInfo",BASE_URL];
    NSDictionary *params = @{@"uid" : @"154"};
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url
                                    parameters:params
                                  successBlock:^(id response) {
                                      @strongify(self);
                                      if ([response[@"code"] intValue] == 1){
//                                          NSArray *models = [self resultMapForJson:response[@"data"]];
//
//                                          if (models) {
//                                              [self.dataArray removeAllObjects];
//                                              [self.dataArray addObjectsFromArray:models];
//                                              [self.tableView reloadData];
//                                              [ZWBucket.userDefault removeItemForKey:kDltGreatgoddModels];
//                                              [ZWBucket.userDefault setItem:[models mutableCopy] forKey:kDltGreatgoddModels];
//                                          }
                                      }
                                      else{
                                          NSLog(@"----error---");
                                      }
                                      
                                  } failureBlock:^(NSError *error) {
                                      @strongify(self);
                                     
                                  } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {

                                  }];
    
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
