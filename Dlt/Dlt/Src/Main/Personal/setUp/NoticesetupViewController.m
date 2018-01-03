//
//  NoticesetupViewController.m
//  Dlt
//
//  Created by USER on 2017/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "NoticesetupViewController.h"
#import "RCDBaseSettingTableViewCell.h"
#import "UIColor+RCColor.h"
#import "VibrationandvoiceCell.h"
#import "RCDMessageNoDisturbSettingController.h"
#define VibrationandvoiceCellinderifer @"VibrationandvoiceCellinderifer"
@interface NoticesetupViewController ()<RCDBaseSettingTableViewCellDelegate>
@property(nonatomic, assign) BOOL isReceiveNotification;
@property (nonatomic, strong) NSString *setMsg;
@end

@implementation NoticesetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知设置";
    [self back:@"friends_15"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[VibrationandvoiceCell class] forCellReuseIdentifier:VibrationandvoiceCellinderifer];
}
-(void)backclick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RCIMClient sharedRCIMClient]
     getNotificationQuietHours:^(NSString *startTime, int spansMin) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (spansMin >= 1439) {
                 self.isReceiveNotification = NO;
                 [self.tableView reloadData];
             } else {
                 self.isReceiveNotification = YES;
                 [self.tableView reloadData];
             }
         });
     }
     error:^(RCErrorCode status) {
         dispatch_async(dispatch_get_main_queue(), ^{
             //       cell.switchButton.on = YES;
             self.isReceiveNotification = YES;
             [self.tableView reloadData];
         });
     }];

}
#pragma mark - Table view Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else if (section==1)
    {
        return 2;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 54;
    }else if (indexPath.section==1)
    {
        return 54;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
        RCDBaseSettingTableViewCell *cell = [self.tableView
                                             dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
        if (cell == nil) {
            cell = [[RCDBaseSettingTableViewCell alloc] init];
        }
        cell.baseSettingTableViewDelegate = self;
        if (indexPath.row==0) {
            [cell setCellStyle:SwitchStyle];
                                cell.leftLabel.text = @"消息提醒";
                                cell.leftLabel.font = AdaptedFontSize(17);
                                cell.switchButton.on = self.isReceiveNotification;

        }else if (indexPath.row==1)
        {
            [cell setCellStyle:DefaultStyle];
            cell.leftLabel.text = @"免打扰";
            cell.leftLabel.font = AdaptedFontSize(17);
            cell.detailTextLabel.text = self.setMsg;
            if (self.isReceiveNotification == YES) {
                cell.backgroundColor = [UIColor whiteColor];
            } else {
                cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            VibrationandvoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:VibrationandvoiceCellinderifer];
            if (cell==nil) {
                cell = [[VibrationandvoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VibrationandvoiceCellinderifer];
            }
            [cell file:@{@"title":@"声音"}];
            cell.isonClick = ^(UISwitch *ison) {
                BOOL isbuttonOn = [ison isOn];
                if (isbuttonOn) {
                    NSLog(@"kai");
                }else
                {
                    NSLog(@"关");
                }
            };
            return cell;
        }else if (indexPath.row==1)
        {
            VibrationandvoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:VibrationandvoiceCellinderifer];
            if (cell==nil) {
                cell = [[VibrationandvoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VibrationandvoiceCellinderifer];
            }
            [cell file:@{@"title":@"震动"}];
            cell.isonClick = ^(UISwitch *ison) {
                BOOL isbuttonOn = [ison isOn];
                if (isbuttonOn) {
                    NSLog(@"kai");
                }else
                {
                    NSLog(@"关");
                }
            };
            return cell;

        }

    }
    
    
    return nil;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中
    
    if (indexPath.row == 1 && indexPath.section == 0) {
        if (self.isReceiveNotification == YES) {
            self.hidesBottomBarWhenPushed = YES;
            RCDMessageNoDisturbSettingController *noMessage =
            [[RCDMessageNoDisturbSettingController alloc] init];
            @weakify(self)
            noMessage.msgSetBlock = ^(NSString *msg) {
                @strongify(self)
                self.setMsg = msg;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:noMessage animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }else if (section==1)
    {
        return 10;
    }
    return 0;
}

- (void)onClickSwitchButton:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"设置中...";
    UISwitch *switchBtn = (UISwitch *)sender;
    if (!switchBtn.on) {
        [[RCIMClient sharedRCIMClient]
         setNotificationQuietHours:@"00:00:00"
         spanMins:1439
         success:^{
             NSLog(@"setNotificationQuietHours succeed");
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [hud hide:YES];
                 self.isReceiveNotification = NO;
                 [self.tableView reloadData];
             });
         }
         error:^(RCErrorCode status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert =
                 [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"设置失败"
                                           delegate:nil
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:nil, nil];
                 [alert show];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.isReceiveNotification = YES;
                     [self.tableView reloadData];
                 });
                 [hud hide:YES];
             });
         }];
    } else {
        [[RCIMClient sharedRCIMClient]
         removeNotificationQuietHours:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [hud hide:YES];
                 self.isReceiveNotification = YES;
                 [self.tableView reloadData];
             });
         }
         error:^(RCErrorCode status) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert =
                 [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"取消失败"
                                           delegate:nil
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:nil, nil];
                 [alert show];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.isReceiveNotification = NO;
                     [self.tableView reloadData];
                 });
                 [hud hide:YES];
             });
         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
