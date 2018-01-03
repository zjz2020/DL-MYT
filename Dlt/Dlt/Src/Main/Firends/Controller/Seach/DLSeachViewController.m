//
//  DLSeachViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLSeachViewController.h"
#import "DLSeachPeopleTableViewController.h"
#import "DLSeachGroupsTableViewController.h"

#define kStartTag   100

@interface DLSeachViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *line;

@end

@implementation DLSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加";
    [self addleftitem];
    
    [self initUI];
}

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
        [btn addTarget:self action:@selector(seachFriendsOrGroups:) forControlEvents:UIControlEventTouchUpInside];
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
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), viewW, viewH - topView.frame.size.height - 64);
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(titles.count * viewW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    DLSeachPeopleTableViewController *friendsList = [[DLSeachPeopleTableViewController alloc] init];
    DLSeachGroupsTableViewController *groupList = [[DLSeachGroupsTableViewController alloc] init];
    NSArray *controllers = @[friendsList,groupList];
    for (int k = 0; k < controllers.count; k ++) {
        UIViewController *vc = controllers[k];
        vc.view.frame = CGRectMake(k * viewW, 0, viewW, scrollView.frame.size.height);
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
    }
}

#pragma mark - 点击事件
- (void)seachFriendsOrGroups:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake((sender.tag - kStartTag) * self.view.frame.size.width / 2, 42, self.view.frame.size.width / 2, 2);
    }];
    [self.scrollView setContentOffset:CGPointMake((sender.tag - kStartTag) * self.view.frame.size.width, 0) animated:NO];
    self.title = sender.tag == kStartTag ? @"找人" : @"找群";
}


@end
