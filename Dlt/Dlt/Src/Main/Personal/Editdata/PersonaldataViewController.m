//
//  PersonaldataViewController.m
//  Dlt
//
//  Created by USER on 2017/6/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "PersonaldataViewController.h"
#import "UINavigationController+Smooth.h"

@interface PersonaldataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * persoalView;
@property(nonatomic,strong)UIView * heardView;
@property (nonatomic, assign)BOOL statusBarShouldLight;

@end

@implementation PersonaldataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusBarShouldLight = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBarBgAlpha = 0;
    self.navBarTintColor = [UIColor whiteColor];
    [self.view addSubview:self.persoalView];

    [_persoalView mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(HEIGHT);
    }];
    
}
-(UIView *)heardView
{
    UIView * backview = [[UIView alloc]init];
    backview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:backview];
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo (WIDTH);
        make.height.mas_equalTo (100);
    }];
    return backview;
}
-(UITableView *)persoalView
{
    if (_persoalView==nil) {
        _persoalView = [[UITableView alloc]init];
        _persoalView.delegate = self;
        _persoalView.dataSource = self;
//        _persoalView.tableHeaderView = [self heardView];
        
    }
    return _persoalView;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (_statusBarShouldLight) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat showNavBarOffSetY = 200 - self.topLayoutGuide.length;
    
    //    if (contentOffsetY <= 0) {
    //        self.headerView.frame = CGRectMake(0, 2*contentOffsetY, CGRectGetWidth(self.headerView.frame), 200 - contentOffsetY);
    //    }
    
    if (contentOffsetY > showNavBarOffSetY) {
        CGFloat newAlpha = (contentOffsetY - showNavBarOffSetY) / 40.0;
        newAlpha = newAlpha < 1 ? newAlpha : 1;
        self.navBarBgAlpha = newAlpha;
        if (newAlpha > 0.8) {
            self.navBarTintColor = [UIColor orangeColor];
            _statusBarShouldLight = NO;
        }
        else{
            self.navBarTintColor = [UIColor whiteColor];
            _statusBarShouldLight = YES;
        }
    }
    else{
        self.navBarBgAlpha = 0;
        self.navBarTintColor = [UIColor whiteColor];
        _statusBarShouldLight = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
