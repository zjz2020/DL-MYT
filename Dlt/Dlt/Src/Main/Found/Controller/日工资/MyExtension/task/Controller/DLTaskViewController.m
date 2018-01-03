//
//  DLTaskViewController.m
//  Dlt
//
//  Created by USER on 2017/9/20.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTaskViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLTaskTableViewCell.h"
#import "DLDetailTaskViewController.h"
#import "DLVulgarTycoonTableViewCell.h"
#import "MJExtension.h"
#import "DLTaskStatus.h"

@interface DLTaskViewController ()
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , assign)int index;
@property (nonatomic , strong)NSMutableArray *statuses;
@end

@implementation DLTaskViewController
-(NSMutableArray *)statuses{
    if (_statuses == nil) {
        _statuses = [NSMutableArray array];
    }return _statuses;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_isVulgarTycoon) {
        self.navigationItem.title = @"土豪任务";
        [self httpVulgarTycoonTaskTabelViewData];
    }else{
        self.navigationItem.title = @"推广员任务";
        [self httpTaskTabelViewData];
    }
    [self addMainTabelView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadTableViewData) name:@"RELOADTABLEVIEWDATA" object:nil];
    
}
-(void)reloadTableViewData{
    [self httpVulgarTycoonTaskTabelViewData];

}
//土豪任务列表
-(void)httpVulgarTycoonTaskTabelViewData{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/MyPubAds",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"index" : [NSString stringWithFormat:@"%d",_index]
                             };
    
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        self.statuses = [DLTaskStatus mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
//推广员列表
-(void)httpTaskTabelViewData{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/MyPromoteAds",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"index" : [NSString stringWithFormat:@"%d",_index]
                             };
     @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        self.statuses = [DLTaskStatus mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
-(void)addMainTabelView{
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statuses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isVulgarTycoon) {
        static NSString *ID = @"VulgarTycoonDLTASKCELL";
        DLVulgarTycoonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[DLVulgarTycoonTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID
                    ];
        }
        cell.status = self.statuses[indexPath.row];
        return cell;
    }else{
        static NSString *ID = @"DLTASKCELL";
        DLTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[DLTaskTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID
                    ];
        }
         cell.status = self.statuses[indexPath.row];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isVulgarTycoon) {
        id model = self.statuses[indexPath.row];
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"status" cellClass:[DLVulgarTycoonTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
        id model = self.statuses[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"status" cellClass:[DLTaskTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
   

    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (_isVulgarTycoon) {
        DLVulgarTycoonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        DLDetailTaskViewController *sdView = [DLDetailTaskViewController new];
        sdView.status = cell.status;
        [self.navigationController pushViewController:sdView animated:YES];
    }else{
        DLTaskTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        DLDetailTaskViewController *sdView = [DLDetailTaskViewController new];
        sdView.status = cell.status;
        [self.navigationController pushViewController:sdView animated:YES];
    }
    
    
}


@end
