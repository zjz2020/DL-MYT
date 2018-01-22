//
//  DLTAntColonyAndNoviceGuideViewController.m
//  Dlt
//
//  Created by Gavin on 2017/6/9.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTAntColonyAndNoviceGuideViewController.h"
#import "AntsgroupsViewController.h"
#import "RecommendedViewController.h"
#import "DLSeachViewController.h"
#import "DltUICommon.h"
#import "DLSeachGroupsTableViewController.h"

@interface DLTAntColonyAndNoviceGuideViewController ()

@property (nonatomic, assign) DLTAntColonyAndNoviceGuideType type;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
@implementation DLTAntColonyAndNoviceGuideViewController {
  UIButton *_lastButton;
}
#pragma clang diagnostic pop
@synthesize type = _type;

- (instancetype)initAntColonyAndNoviceGuideViewControllerWithType:(DLTAntColonyAndNoviceGuideType)type
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _type = type;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
  self.title = @"Gavin";
  [self back:@"friends_15"];
  [self rightItem:@"friends_32"];
  
  
  //
  UIView *topView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,{kScreenWidth,70}}];
  topView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:topView];
  
  [topView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view);
    make.height.mas_equalTo(70);
    make.left.equalTo(self.view);
    make.right.equalTo(self.view.mas_right);
  }];
  
  UIView *segmentedView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,{220,40}}];
  [segmentedView ui_setPathRadius:15 withRoundedRect:(CGRect){CGPointZero,220,40}];
  [topView addSubview:segmentedView];  
  [segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(220);
    make.height.mas_equalTo(40);
    make.center.equalTo(topView);
  }];
  
  
  CGFloat segmented_w = segmentedView.width;
  
  NSArray *titles = @[@"热门蚂蚁群",@"新手推荐"];// segmentedDidSelected
  for (int i = 0; i < titles.count; i ++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(i * segmented_w / 2, 0, segmented_w / 2, segmentedView.height);
    [btn setTitle:titles[i] forState:UIControlStateNormal];
    [btn setTitleColor:rgb(44, 44, 44) forState:UIControlStateNormal];
    [btn setTitleColor:rgb(0, 137, 241) forState:UIControlStateSelected]; //
    btn.tag = i;
    [btn addTarget:self action:@selector(segmentedDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [segmentedView addSubview:btn];
    
    btn.selected = _type == i;
    if ( _type == i){_lastButton = btn;}
  }
  
  UILabel *line = [[UILabel alloc] init];
  line.backgroundColor = rgb(44, 44, 44);
  [segmentedView addSubview:line];
  [segmentedView bringSubviewToFront:line];
  [line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(.6);
    make.height.mas_equalTo(30);
    make.center.equalTo(topView);
  }];
  
  
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  scrollView.scrollEnabled = NO;
  scrollView.contentSize = CGSizeMake(titles.count * kScreenWidth, 0);
  scrollView.pagingEnabled = YES;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.bounces = NO;
  [self.view addSubview:scrollView];
  [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.top.equalTo(topView.mas_bottom);
    make.right.equalTo(self.view.mas_right);
    make.bottom.equalTo(self.view.mas_bottom);
  }];
  
  self.scrollView = scrollView;
  

  AntsgroupsViewController *antsVC = [AntsgroupsViewController new];
  RecommendedViewController *recommendedVC = [RecommendedViewController new];
  NSArray *controllers = @[antsVC,recommendedVC];
  for (int k = 0; k < controllers.count; k ++) {
    UIViewController *vc = controllers[k];
    vc.view.frame = CGRectMake(k * kScreenWidth, 0, kScreenWidth, scrollView.frame.size.height);
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
  }
  
  @weakify(self);
  [RACObserve(self, type)
        subscribeNext:^(NSNumber *type) {
            @strongify(self);
            self.title = ([type intValue] == DLTAntColonyAndNoviceGuideTypeAntColony)? @"蚂蚁群" :@"新手推荐";
  }];
  
 [self setScrollViewOffset:_type];
}

#pragma mark -
#pragma mark - - 点击事件

- (void)backclick{
  [self.navigationController popViewControllerAnimated:YES];
}

// 点击➕号 添加好友
- (void)rightclick {
  if (_type == DLTAntColonyAndNoviceGuideTypeAntColony) {
    DLSeachGroupsTableViewController *groupList = [[DLSeachGroupsTableViewController alloc] init];
    [self.navigationController pushViewController:groupList animated:YES];
  }
  
  if (_type == DLTAntColonyAndNoviceGuideTypeNoviceGuide) {
     [self.navigationController pushViewController:[DLSeachViewController new] animated:YES]; 
  }
}

- (void)segmentedDidSelected:(UIButton *)sender {
  if (_type == sender.tag) return;
  self.type = sender.tag;
  
  sender.selected = YES;
  _lastButton.selected = NO;
  _lastButton = sender;
  [self setScrollViewOffset:_type];
}

- (void)setScrollViewOffset:(DLTAntColonyAndNoviceGuideType)type{
  [self.scrollView setContentOffset:CGPointMake(type * kScreenWidth, 0) animated:NO];
}

@end
