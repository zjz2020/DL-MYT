//
//  MySetupViewController.m
//  Dlt
//
//  Created by USER on 2017/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
#define SafeAreaBottomHeight (HEIGHT == 812.0 ? 34 : 0)
#import "MySetupViewController.h"
#import "ChangephoneCell.h"
#import "ChagepasswordCell.h"
#import "ChangephoneViewController.h"
#import "LoginViewController.h"
#import "JXActionSheet.h"
#import "NoticesetupViewController.h"
#import "AppDelegate.h"
#define ChangephoneCellInderifer @"ChangephoneCellInderifer"
#define ChagepasswordCellInderifer @"ChagepasswordCellInderifer"

@interface MySetupViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)UIButton * completeBtn;

@end

@implementation MySetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self back:@"friends_15"];
    [self.tableView registerClass:[ChangephoneCell class] forCellReuseIdentifier:ChangephoneCellInderifer];
    [self.tableView registerClass:[ChagepasswordCell class] forCellReuseIdentifier:ChagepasswordCellInderifer];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.completeBtn];

    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HEIGHT-118-SafeAreaBottomHeight);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(55);
    }];
}
-(void)backclick
{
    
        [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row==1||row==0) {
        return 64;
    }else
    {
        return 54;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
//    if (row==0) {
//        ChangephoneCell * cell = [tableView dequeueReusableCellWithIdentifier:ChangephoneCellInderifer];
//        if (cell == nil) {
//            cell = [[ChangephoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangephoneCellInderifer];
//        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell filedata:@{@"title":@"修改手机号"}];
//        return cell;
//    }else
        if (row==0)
    {
        ChagepasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:ChagepasswordCellInderifer];
        if (cell == nil) {
            cell = [[ChagepasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChagepasswordCellInderifer];
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell filedata:@{@"title":@"修改登录密码"}];
        cell.icon.hidden = YES;
        return cell;

    }else if (row==1)
    {
        ChagepasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:ChagepasswordCellInderifer];
        if (cell == nil) {
            cell = [[ChagepasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChagepasswordCellInderifer];
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell filedata:@{@"title":@"新消息通知"}];
        cell.icon.hidden = YES;
        return cell;

    }
//    else if (row==2)
//    {
//        ChangephoneCell * cell = [tableView dequeueReusableCellWithIdentifier:ChangephoneCellInderifer];
//        if (cell == nil) {
//            cell = [[ChangephoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangephoneCellInderifer];
//        }
//         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell filedata:@{@"title":@"关于蚂蚁通"}];
//        return cell;
//
//    }else if (row==3)
//    {
//        ChagepasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:ChagepasswordCellInderifer];
//        if (cell == nil) {
//            cell = [[ChagepasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChagepasswordCellInderifer];
//        }
//         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell filedata:@{@"title":@"客服中心"}];
//        return cell;
//
//    }
    else if (row==2)
    {
        ChangephoneCell * cell = [tableView dequeueReusableCellWithIdentifier:ChangephoneCellInderifer];
        if (cell == nil) {
            cell = [[ChangephoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangephoneCellInderifer];
        }
        [cell filedata:@{@"title":@"清除缓存"}];
        cell.userName.hidden = YES;
        cell.sexStr.hidden = YES;
        cell.dateStr.hidden = YES;
        return cell;

    }
    
    
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row==0) {
        self.hidesBottomBarWhenPushed = YES;
        ChangephoneViewController * changepassword = [[ChangephoneViewController alloc]init];
        [self.navigationController pushViewController:changepassword animated:YES];
    }else if (row==2)
    {

        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:@"是否清理缓存？"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil];
        alertView.tag = 1011;
        [alertView show];

    }else if (row==1)
    {
        self.hidesBottomBarWhenPushed = YES;
        NoticesetupViewController * notice = [[NoticesetupViewController alloc]init];
        [self.navigationController pushViewController:notice animated:YES];
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {

    
    if (buttonIndex == 1 && alertView.tag == 1011) {
        [self clearCache];
    }
}
//清除缓存
- (void)clearCache {
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       //这里清除 Library/Caches 里的所有文件，融云的缓存文件及图片存放在 Library/Caches/RongCloud 下
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(
                                                                                 NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files =
                       [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil
                                           waitUntilDone:YES];
                   });
}

- (void)clearCacheSuccess {
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:nil
                               message:@"缓存清理成功！"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil, nil];
    [alertView show];
}

-(UIButton *)completeBtn
{
    if (_completeBtn == nil) {
        _completeBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 0, 54)];
        _completeBtn.top_sd = HEIGHT- 110;
        _completeBtn.width_sd = WIDTH;
        
        [_completeBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeBtn.backgroundColor = [UIColor colorWithHexString:@"0080f5"];
        [_completeBtn addTarget:self action:@selector(complet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}
-(void)complet
{
    JXActionSheet *sheet = [[JXActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" cancelTitle:@"取消" otherTitles:@[@"退出登录"]];
    sheet.destructiveButtonIndex = 0;
    [sheet showView];
    [sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
        if (clickedIndex==0) {
//            [DEFAULTS removeObjectForKey:@"token"];
            //    [DEFAULTS removeObjectForKey:@"uid"];
            ////    [DEFAULTS removeObjectForKey:@"userName"];
            ////    [DEFAULTS removeObjectForKey:@"userPwd"];
            [[DLTUserCenter userCenter]logout];
            dispatch_async(dispatch_get_main_queue(), ^{
//                LoginViewController * login = [[LoginViewController alloc]init];
//                [self presentViewController:login animated:YES completion:nil];
                [[AppDelegate shareAppdelegate]logoutCompleted];
                
            });
            

        }
        NSLog(@"%@ == %@", @(clickedIndex), isCancel ? @"YES" : @"NO");
    }];

   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
