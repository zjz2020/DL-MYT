//
//  BlackFriendsViewController.m
//  Dlt
//
//  Created by USER on 2017/8/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BlackFriendsViewController.h"
#import "SDAutoLayout.h"
#import "BlackFriendsCell.h"
#import "DLUserInfDetailViewController.h"
#import "BlackFriendStatus.h"
#import "MJExtension.h"

@interface BlackFriendsViewController ()
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *blackArray;
@end


@implementation BlackFriendsViewController
-(NSMutableArray *)blackArray{
    if (_blackArray == nil) {
        _blackArray = [NSMutableArray array];
    }return _blackArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBlackFriendTabel];
}
-(void)addBlackFriendTabel{
    _tableView = [UITableView new];
    [self HttpBlackFriendData];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [ center addObserver:self selector:@selector(HttpBlackFriendData) name:@"RELOASBLACKXELLCENTER" object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RELOASBLACKXELLCENTER" object:nil];
}
- (void)HttpBlackFriendData{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    //myFriends
    //blackList
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/blackList",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
     
        @strongify(self)
       
        self.blackArray = [BlackFriendStatus mj_objectArrayWithKeyValuesArray:[response valueForKey:@"data"]];
            [self.tableView reloadData];
       
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _blackArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"BLACKFRIENDCELL";
    BlackFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BlackFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.status = _blackArray[indexPath.row];
   
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DLUserInfDetailViewController *sdView = [DLUserInfDetailViewController new];
    sdView.otherUserId = [_blackArray[indexPath.row] valueForKey:@"fid"];
    sdView.isBalckFriend = YES;
    [self.navigationController pushViewController:sdView animated:YES];
}

@end
