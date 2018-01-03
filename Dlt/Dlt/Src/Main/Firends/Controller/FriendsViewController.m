//
//  FriendsViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "FriendsViewController.h"
#import "DLFriendsListTableViewController.h"
#import "DLGroupListTableViewController.h"
#import "DLSeachViewController.h"
#import "DLCreatGroupViewController.h"
#import "BlackFriendsViewController.h"


#define kStartTag   100

@interface FriendsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *line;
@end

@implementation FriendsViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"好友";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];

    [self addrightitem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScrollViewContentOffset) name:kCreatGroupSuccessNitificationName object:nil];
    
    
    UIBarButtonItem *blackFriend = [[UIBarButtonItem alloc] initWithTitle:@"黑名单" style:UIBarButtonItemStylePlain target:self action:@selector(upBlackFriendButton)];
    self.navigationItem.leftBarButtonItem = blackFriend;
    self.navigationController.navigationBar.tintColor  = [UIColor blackColor];
}
//点击了黑名单
-(void)upBlackFriendButton{
    BlackFriendsViewController *seachVC = [[BlackFriendsViewController alloc] init];
    seachVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seachVC animated:YES];

}

#pragma mark - 初始化UI
- (void)initUI {
    CGFloat viewW = self.view.frame.size.width;
    CGFloat viewH = self.view.frame.size.height;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIH, viewW, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    NSArray *titles = @[@"好友",@"群组"];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * viewW / 2, 0, viewW / 2, 42);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"2C2C2C"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(exchangeFriendsOrGroups:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.tag = kStartTag + i;
        [topView addSubview:btn];
    }
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"0089F1"];
    self.line.frame = CGRectMake(0, 42, viewW / 2, 2);
    [topView addSubview:self.line];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), viewW, viewH - topView.frame.size.height - 64 - 48);
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(titles.count * viewW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];

    DLFriendsListTableViewController *friendsList = [[DLFriendsListTableViewController alloc] init];
    friendsList.mainView = self;
    DLGroupListTableViewController *groupList = [[DLGroupListTableViewController alloc] init];
    NSArray *controllers = @[friendsList,groupList];
    for (int k = 0; k < controllers.count; k ++) {
        UIViewController *vc = controllers[k];
        vc.view.frame = CGRectMake(k * viewW, 0, viewW, scrollView.frame.size.height);
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
    }
}
-(void)addrightitem {
    UIButton * rightbtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    [rightbtn setImage:[UIImage imageNamed:@"Okami_00"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightitem;
}

#pragma mark - 点击事件
- (void)exchangeFriendsOrGroups:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake((sender.tag - kStartTag) * self.view.frame.size.width / 2, 42, self.view.frame.size.width / 2, 2);
    }];
    [self.scrollView setContentOffset:CGPointMake((sender.tag - kStartTag) * self.view.frame.size.width, 0) animated:NO];
    self.title = sender.tag == kStartTag ? @"好友" : @"群组";
}

- (void)setScrollViewContentOffset {
   [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
     self.line.frame = CGRectMake(self.view.frame.size.width / 2, 42, self.view.frame.size.width / 2, 2);
    
}


- (void)rightClick {
    DLSeachViewController *seachVC = [[ DLSeachViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           alloc] init];
    seachVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seachVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCreatGroupSuccessNitificationName object:nil];
}



@end
