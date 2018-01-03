//
//  PersonalViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "PersonalViewController.h"
#import "WalleatViewController.h"
#import "PersonalCell.h"
#import "FoundCell.h"
#import "GroupandStoreCell.h"
#import "JWShareView.h"
#import "MySetupViewController.h"
#import "MyqrcodeViewController.h"
#import "MKQRCode.h"
#import "RegisterPersonDataViewController.h"
#import "FriendsprofileViewController.h"
#import "DLTMyDynamicViewController.h"
//#import "DLThirdShare.h"
#import "BlackFriendsViewController.h"
#import "DLWebViewViewController.h"
#import "DLTPersonalProfileViewController.h"
#import "DLPhotosCollectionViewController.h"
#import "ChangephoneViewController.h"


#define PersonalCellIdenifer @"PersonalCellIdenifer"
#define FoundCellIdenifer @"FoundCellIdenifer"
#define GroupandStoreCellIdenifer @"GroupandStoreCellIdenifer"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[PersonalCell class] forCellReuseIdentifier:PersonalCellIdenifer];
    [self.tableView registerClass:[FoundCell class] forCellReuseIdentifier:FoundCellIdenifer];
    [self.tableView registerClass:[GroupandStoreCell class] forCellReuseIdentifier:GroupandStoreCellIdenifer];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    if (row==0) {
        return 145;
    }else if (row==1 || row==3 || row ==5)
    {
        return 54;
    }else
    {
        return 64;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row==0) {
        PersonalCell * cell = [tableView dequeueReusableCellWithIdentifier:PersonalCellIdenifer];
        if (cell == nil) {
            cell = [[PersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PersonalCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        DLTUserProfile * user = DLT_USER_CENTER.curUser;
       NSString *imagestr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,user.userHeadImg];
        [cell.myIcon sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"personal_19"]];
        cell.nameLabel.text = user.userName;
        cell.mytNumbel.text = [NSString stringWithFormat:@"蚂蚁通号:%@",user.phone];
        
//        cell.userinfo = userinfo.data;
        return cell;
    }else if (row==1)
    {
        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenifer];
        if (cell == nil) {
            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"personal_02",@"title":@"我的动态"}];
        
        return cell;

    }

    else if (row==2)
    {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        if ([user.uid isEqualToString:@"286"] || [user.uid isEqualToString:@"3422"]) {
             [cell file:@{@"icon":@"personal_04",@"title":@"修改密码"}];
        }else{
             [cell file:@{@"icon":@"personal_04",@"title":@"我的钱包"}];
        }
        
        
        return cell;

    }else if (row==3)
    {
        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenifer];
        if (cell == nil) {
            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"personal_05",@"title":@"我的二维码"}];
        
        return cell;

    }else if (row==4)
    {
        FoundCell * cell = [tableView dequeueReusableCellWithIdentifier:FoundCellIdenifer];
        if (cell == nil) {
            cell = [[FoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FoundCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"personal_06",@"title":@"黑名单"}];
        
        return cell;

    }else if (row==5)
    {
        GroupandStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:GroupandStoreCellIdenifer];
        if (cell == nil) {
            cell = [[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellIdenifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"personal_07",@"title":@"设置"}];
        
        return cell;

    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row == 0) {
      DLTPersonalProfileViewController *profile = [[DLTPersonalProfileViewController alloc]init];
      [self.navigationController pushViewController:profile animated:YES];       
    }else if (row==2)
    {
        
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        if ([user.uid isEqualToString:@"286"] || [user.uid isEqualToString:@"3422"]) {
            
            UIViewController *sdView = nil;
            sdView= [[ChangephoneViewController alloc]init];
            
            [self.navigationController pushViewController:sdView animated:YES];
        }else{
            UIViewController *sdView = nil;
            sdView= [[WalleatViewController alloc]init];
            
            [self.navigationController pushViewController:sdView animated:YES];
        }
       
    }else if (row==4)
    {
        BlackFriendsViewController *sdView = [BlackFriendsViewController new];
        [self.navigationController pushViewController:sdView animated:YES];
//        NSArray *contentArray = @[@{@"name":@"微信好友",@"icon":@"personal_29"},
//                                  @{@"name":@"蚂蚁圈",@"icon":@"personal_30"},
//                                  @{@"name":@"面对面",@"icon":@"personal_31"}
//                                  ];
//        JWShareView *_shareView = [[JWShareView alloc] init];
//        @weakify(self);
//        _shareView.cancle = ^{
//            @strongify(self);
//            self.tabBarController.tabBar.hidden = NO;
//        };
//        [_shareView addShareItems:[[[UIApplication sharedApplication] windows] lastObject] shareItems:contentArray selectShareItem:^(NSInteger tag, NSString *title) {
//            if (tag==0) {
//                DLThirdShare *thirdShare = [DLThirdShare thirdShareInstance];
//                thirdShare.shareUrl = @"http://www.mayiton.com";
//                thirdShare.shareImage = [UIImage imageNamed:@"shareImg.png"];
//                thirdShare.shareTitle = @"蚂蚁通";
//                [thirdShare shareToWechat:ShareWechatType_Session];
//            } else if (tag == 1) {
//                DLThirdShare *thirdShare = [DLThirdShare thirdShareInstance];
//                thirdShare.shareUrl = @"http://www.mayiton.com";
//                thirdShare.shareImage = [UIImage imageNamed:@"shareImg.png"];
//                thirdShare.shareTitle = @"蚂蚁通";
//                [thirdShare shareToWechat:ShareWechatType_Circle];
//            } else {
//                DLWebViewViewController *vc = [DLWebViewViewController new];
//                vc.loadUrl = @"http://www.mayiton.com";
//                
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }];
//     self.tabBarController.tabBar.hidden = YES;
    }else if ( row==5)
    {
        self.hidesBottomBarWhenPushed = YES;
        MySetupViewController * setup = [[MySetupViewController alloc]init];
        [self.navigationController pushViewController:setup animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (row==3)
    {
        self.hidesBottomBarWhenPushed = YES;
        MyqrcodeViewController * qrcode = [[MyqrcodeViewController alloc]init];
        qrcode.qrcode = [self generateImage];
        [self.navigationController pushViewController:qrcode animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (row==1)
    {
        DLTMyDynamicViewController *dynamic = [[DLTMyDynamicViewController alloc] init];
       [self.navigationController pushViewController:dynamic animated:YES];
    }
}
-(UIImage *)generateImage
{
    MKQRCode *code = [[MKQRCode alloc] init];
    [code setInfo:@"https://github.com/ymkil/MKQRCode" withSize:300];
//    code.centerImg = [UIImage imageNamed:@"Login_00"];
    code.style = MKQRCodeStyleCenterImage;
    return [code generateImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
