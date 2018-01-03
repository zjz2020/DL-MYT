//
//  BaseTableViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(void)back:(NSString *)image
{
    UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftitem;
    
}
-(void)backclick
{
    
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItem:(NSString *)image
{
    UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
}
-(void)rightclick
{
    
}
-(void)rightTitle:(NSString *)title
{
    UIBarButtonItem * righttitle = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightclicks)];
    self.navigationItem.rightBarButtonItem = righttitle;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}
-(void)rightclicks
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
