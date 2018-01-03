//
//  SearchFriendsViewController.m
//  Dlt
//
//  Created by USER on 2017/5/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SearchFriendsViewController.h"

@interface SearchFriendsViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * addfrieds;
@end

@implementation SearchFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self back:@"friends_15"];
    self.title = @"添加好友";
    self.addfrieds = [[UITextField alloc]initWithFrame:RectMake_LFL(20, 0, 0, 30)];
    self.addfrieds.delegate = self;
    self.addfrieds.width_sd = WIDTH;
    self.addfrieds.font = AdaptedFontSize(15);
    self.addfrieds.borderStyle = UITextBorderStyleRoundedRect;
    self.addfrieds.placeholder = @"   请输入好友的账号";
    self.addfrieds.returnKeyType = UIReturnKeySend;
    self.addfrieds.keyboardType = UIKeyboardTypeASCIICapable;
    self.tableView.tableHeaderView = self.addfrieds;
    

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)backclick{
 [self.navigationController popViewControllerAnimated:YES];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text) {
        NSString * url = [NSString stringWithFormat:@"%@UserCenter/addFriendRequest",BASE_URL];
//        NSString * token =[DEFAULTS objectForKey:@"token"];
//        NSString * userId =[DEFAULTS objectForKey:@"uid"];
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

        NSDictionary * dic =[NSDictionary dictionaryWithObjectsAndKeys:[DLTUserCenter userCenter].token,@"token",user.uid,@"uid",textField.text,@"friendAccount", nil];
        [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
            if ([response[@"code"] intValue]==1) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:nil
                                          message:@"请求已发送"
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
                [alertView show];
            }else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:nil
                                          message:@"用户不存在"
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            
        } failureBlock:^(NSError *error) {
            
        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
