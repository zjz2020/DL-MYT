//
//  DLBillViewController.m
//  Dlt
//
//  Created by USER on 2017/9/19.
//  Copyright © 2017年 mr_chen. All rights reserved.


#import "DLBillViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLBillTableViewCell.h"
#import "DLBillStatus.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
@interface DLBillViewController ()
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UIButton *topText;
@property (nonatomic , strong)UILabel *topRightLable;
@property (nonatomic , strong)NSMutableArray *statuses;
@property (nonatomic , assign)CGFloat incomeStr;
@property (nonatomic , assign)CGFloat outStr;
@property (nonatomic , assign)int index;
@property (nonatomic , strong)NSString *type;

@end

@implementation DLBillViewController
-(NSMutableArray *)statuses{
    if (_statuses == nil) {
        _statuses = [NSMutableArray array];
    }return _statuses;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    _type = @"0";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.time;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addHeardView];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(upBillRightButton)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationController.navigationBar.tintColor  = [UIColor blackColor];
    [self httpBillData];
}
-(void)httpNumberData{
    
   
        self.incomeStr =[_payIn integerValue]/100.0;
        self.outStr =[_payOut  integerValue]/100.0;
        self.topRightLable.text = [NSString stringWithFormat:@"收入 %.2f 支出 %.2f",self.incomeStr,self.outStr];
    
}
//账单数据
-(void)httpBillData{
    
    NSString *ind = [NSString stringWithFormat:@"%d",_index];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    //
    NSArray *array = [_time componentsSeparatedByString:@"-"];
  
    NSString *url = [NSString stringWithFormat:@"%@promote/DaywagesRecordByDate",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"index" :ind,
                             @"month":array[1],
                             @"year":array[0]
                             };
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    if (![_type isEqualToString:@"0"]) {
        
        param[@"type"] = _type;
    }
   
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:param successBlock:^(id response) {
        NSLog(@"%@",response);
        @strongify(self)
        NSArray *array =[DLBillStatus mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        if (_index == 0) {
            self.statuses = (NSMutableArray *)[DLBillStatus mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        }else{
            
            [self.statuses addObjectsFromArray:array];
        }
         [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        if ([_type isEqualToString:@"0"]) {
            self.topRightLable.text = [NSString stringWithFormat:@"收入 %.2f 支出 %.2f",self.incomeStr,self.outStr];
            [_topText setTitle:@"全部" forState:0];
        }else if ([_type isEqualToString:@"1"]){
             self.topRightLable.text = [NSString stringWithFormat:@"收入 %.2f",self.incomeStr];
            [_topText setTitle:@"收入" forState:0];
        }else{
             self.topRightLable.text = [NSString stringWithFormat:@"支出 %.2f",self.outStr];
            [_topText setTitle:@"支出" forState:0];
        }
        if (array.count < 10) {
            _index --;
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"网络延迟稍后重试"];
    } progress:nil];

}
-(void)addHeardView{
    UIView *heardView = [UIView new];
    _topText = [UIButton buttonWithType:UIButtonTypeSystem];
    _topText.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    _topText.layer.masksToBounds = YES;
    CGFloat R = 13;
    _topText.layer.cornerRadius  = R;
    _topText.layer.borderWidth = 1;
    _topText.layer.borderColor = UICOLORRGB(156, 156, 156, 1.0).CGColor;
    [_topText setTintColor:[UIColor blackColor]];
    _topText.titleLabel.font = [UIFont systemFontOfSize:14];
    [_topText setTitle:@"全部" forState:0];
    _topRightLable = [UILabel new];
    _topRightLable.font = [UIFont systemFontOfSize:14];
    [self httpNumberData];
    [heardView sd_addSubviews:@[_topText,_topRightLable]];
    _topText.sd_layout
    .centerYEqualToView(heardView)
    .leftSpaceToView(heardView, 20);
    [_topText setupAutoSizeWithHorizontalPadding:20 buttonHeight:2*R];
    _topRightLable.sd_layout
    .centerYEqualToView(heardView)
    .rightSpaceToView(heardView, 10)
    .heightIs(20);
    [_topRightLable setSingleLineAutoResizeWithMaxWidth:200];
    [self.view addSubview:heardView];
    heardView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .rightSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .heightIs(54);
    _tableView = [UITableView new];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _index ++;
        [self httpBillData];
    }];
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(heardView,0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statuses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"BILLCELL";
    DLBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DLBillTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.status = _statuses[indexPath.row];
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
    
    NSArray *  array = @[@"账单"];
    
    static NSString *headerViewId = @"ResultheaderViewId";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        
    headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    headerView.contentView.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    UILabel *label = [UILabel new];
    label.text = array[section];
    [headerView addSubview:label];
    label.sd_layout
    .centerYEqualToView(headerView)
    .leftSpaceToView(headerView, 10)
    .heightIs(20)
    .widthIs(100);
    return headerView;
    
}

//点击了筛选按钮
-(void)upBillRightButton{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"筛选" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *allAction=[UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _index = 0;
            _type = @"0";
            [self httpBillData];
            
        }];
        UIAlertAction *incomeAction=[UIAlertAction actionWithTitle:@"收入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _index = 0;
            _type = @"1";
            [self httpBillData];
        }];
        UIAlertAction *expenditureAction=[UIAlertAction actionWithTitle:@"支出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _index = 0;
            _type = @"2";
           [self httpBillData];
        }];
    
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alertController addAction:allAction];
        [alertController addAction:expenditureAction];
        [alertController addAction:incomeAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
}
@end
