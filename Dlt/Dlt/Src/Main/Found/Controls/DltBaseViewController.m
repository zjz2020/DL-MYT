//
//  DltBaseViewController.m
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DltBaseViewController.h"

@interface DltBaseViewController ()

@end

@implementation DltBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
  [self.navigationController popViewControllerAnimated:YES];
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

@end
