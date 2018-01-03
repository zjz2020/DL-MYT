//
//  TransferViewController.m
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "TransferViewController.h"
#import "TransferCell.h"
#import "PayCell.h"
#import "SelectorPayCell.h"
#import "RCHttpTools.h"
#import "DLPasswordInputView.h"
#import "LTAlertView.h"
#define TransferCellInderifer @"TransferCellInderifer"
#define PayCellInderifer @"PayCellInderifer"
#define SelectorPayCellInderifer @"SelectorPayCellInderifer"

@interface TransferViewController ()<DLPasswordInputViewDelegate>
{
    NSString * blances;
    NSString * money;
    NSString * pslabel;
    NSString * tranAmount;
}

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账";
    [self back:@"friends_15"];
    [self.tableView registerClass:[TransferCell class] forCellReuseIdentifier:TransferCellInderifer];
     [self.tableView registerClass:[PayCell class] forCellReuseIdentifier:PayCellInderifer];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      [self.tableView registerClass:[SelectorPayCell class] forCellReuseIdentifier:SelectorPayCellInderifer];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

   
   
    
    
}
-(void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password
{
    [DLAlert alertShowLoad];
    //
    [[RCHttpTools shareInstance]verificationPayPassword:password handle:^(BOOL isSame) {
       
        if (isSame) {
            [DLAlert alertHideLoad];
            
            NSDictionary * dic = @{@"toId":_toid,
                                   @"tranAmount":tranAmount,
                                   @"payPwd":password,
                                   @"uid":[DLTUserCenter userCenter].curUser.uid,
                                   @"token":[DLTUserCenter userCenter].token};
            NSString * url = [NSString stringWithFormat:@"%@Wallet/transferAccount",BASE_URL];
            [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
                NSLog(@"%@",response);
                if ([response[@"code"]integerValue]==1) {
                    [DLAlert alertWithText:@"转账成功"];
                    [self dismissViewControllerAnimated:YES completion:nil];

                }else{
                    //[DLAlert alertWithText:response[@""]];
                }

            } failureBlock:^(NSError *error) {
                
            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        }
        else
        {
            [DLAlert alertHideLoad];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付密码错误，请重试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            [alert show];

        }
    }];
    
    
}
-(void)backclick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
//    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [[RCHttpTools shareInstance] checkMyBalances:^(NSString *myBalances) {
        
        blances = [NSString stringWithFormat:@"%.2f",[myBalances floatValue]];
        [self.tableView reloadData];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 355;
    }
    else if (indexPath.row==1)
    {
        return 40 ;
    }
    else
    {
        return 70;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        TransferCell * cell = [tableView dequeueReusableCellWithIdentifier:TransferCellInderifer];
        if (cell== nil) {
            cell = [[TransferCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TransferCellInderifer];
        }
        cell.myName.text = _friendsName;
        [cell.myIcon sd_setImageWithURL:[NSURL URLWithString:_heardimage]];
        cell.moneyClick = ^(UITextField *text) {
            NSLog(@"%@",text.text);
            money = text.text;
        };
        cell.psClick = ^(UITextField *text) {
            NSLog(@"%@",text.text);
            pslabel = text.text;
        };
        return cell;
    }
    else if (indexPath.row==1)
    {
        SelectorPayCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectorPayCellInderifer];
        if (cell== nil) {
            cell = [[SelectorPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectorPayCellInderifer];
        }
        //        [cell filedata:@{@"title":@"支付方式"}];
        return cell;
    }
    else if (indexPath.row==2)
    {
        PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
        if (cell== nil) {
            cell = [[PayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayCellInderifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"wallet_07",
                     @"title":@"余额支付"
                     }];
        cell.contentLabel.text = blances;
        return cell;

    }else if (indexPath.row==3)
    {
        PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
        if (cell== nil) {
            cell = [[PayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayCellInderifer];
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"wallet_08",
                     @"title":@"支付宝支付",
                     @"content":@"推荐使用支付宝支付"}];
        return cell;
    }else if (indexPath.row==4)
    {
        PayCell * cell = [tableView dequeueReusableCellWithIdentifier:PayCellInderifer];
        if (cell== nil) {
            cell = [[PayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayCellInderifer];
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"wallet_09",
                     @"title":@"微信支付",
                     @"content":@"推荐安装微信5.0及以上版本使用"}];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        if (money==nil) {

            [LTAlertView showConfigBlock:^(LTAlertView *alertView) {
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            } Title:@"请输入转账金额" message:@"" ButtonTitles:@[@"确定",@"取消"] OnTapBlock:^(LTAlertView* alert,NSInteger num) {
                NSString* str = [alert textFieldAtIndex:0].text;
                
                if (num==0) {
                                DLPasswordInputView * inputview = [DLPasswordInputView initInputView];
                                inputview.delegate = self;
                                inputview.money = str;
                                tranAmount = [NSString stringWithFormat:@"%d",[inputview.money intValue]];
                    
                                [inputview popAnimationView:self.view];
                }
                
            }];
  
            
            
            
        }else
        {
            DLPasswordInputView * inputview = [DLPasswordInputView initInputView];
            inputview.delegate = self;
           
            inputview.money = money;
            tranAmount = [NSString stringWithFormat:@"%d",[inputview.money intValue]];


            [inputview popAnimationView:[UIApplication sharedApplication].keyWindow];
        }
    
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
