//
//  ChangepayViewController.m
//  Dlt
//
//  Created by USER on 2017/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "ChangepayViewController.h"
#import "ChangephoneCell.h"
#import "SetupPasswordViewController.h"
#import "SelectorPayCell.h"
#import "DLFindPayPwdViewController.h"
#define SelectorPayCellInderifer @"SelectorPayCellInderifer"


#define ChangephoneCellInderifer @"ChangephoneCellInderifer"

@interface ChangepayViewController ()
{
    NSString * payPassword;
}
@end

@implementation ChangepayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付管理";
    [self back:@"friends_15"];
    [self.tableView registerClass:[ChangephoneCell class] forCellReuseIdentifier:ChangephoneCellInderifer];
     [self.tableView registerClass:[SelectorPayCell class] forCellReuseIdentifier:SelectorPayCellInderifer];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
//    payPassword = [DEFAULTS objectForKey:@"Paypassword"];
//    NSLog(@"%@",payPassword);
}
-(void)backclick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_seleType) {
        return 2;
    }else{
        return 1;

    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

            return 54;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_seleType==NO) {
        if (row==0)
        {
            SelectorPayCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectorPayCellInderifer];
            if (cell == nil) {
                cell = [[SelectorPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectorPayCellInderifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"title":@"设置支付密码"}];
            return cell;
            
        }
       
    } else
    {
        if (row==0)
        {
            SelectorPayCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectorPayCellInderifer];
            if (cell == nil) {
                cell = [[SelectorPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectorPayCellInderifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"title":@"修改支付密码"}];
            return cell;
            
            
        }else{
            SelectorPayCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectorPayCellInderifer];
            if (cell == nil) {
                cell = [[SelectorPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectorPayCellInderifer];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell file:@{@"title":@"验证码修改"}];
            return cell;
        }

        }
     
    
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SetupPasswordViewController * setup= [[SetupPasswordViewController alloc]init];
        setup.changeType = _seleType;
        [self.navigationController pushViewController:setup animated:YES];
    }else{
        DLFindPayPwdViewController * setup= [[DLFindPayPwdViewController alloc]init];
        [self.navigationController pushViewController:setup animated:YES];
    }
  
    

        
    
}

@end
