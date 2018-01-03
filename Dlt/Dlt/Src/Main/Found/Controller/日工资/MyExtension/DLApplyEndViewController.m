//
//  DLApplyEndViewController.m
//  Dlt
//
//  Created by USER on 2017/9/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLApplyEndViewController.h"
#import "DLAdverAgreementViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
@interface DLApplyEndViewController ()
@property (nonatomic , strong)UIButton *weixinLabel;
@end

@implementation DLApplyEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_isAdver) {
        self.navigationItem.title = @"广告主开户申请";
    }else{
        self.navigationItem.title = @"申请推广员";
    }
    [self setupMainView];
    [self httpWeixinLabel];
}
-(void)httpWeixinLabel{
    
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@promote/WechatNum",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid
                             };
    
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {

       [_weixinLabel setTitle: [NSString stringWithFormat:@"微信号：%@",response[@"data"]] forState:0];
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"网络延迟稍后重试"];
    } progress:nil];

}
-(void)setupMainView{
    
    UILabel *topLabel = [UILabel new];
    topLabel.text  = @"官方审核微信号";
    _weixinLabel = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _weixinLabel.layer.borderColor = UICOLORRGB(216, 216, 216, 1.0).CGColor;
    _weixinLabel.layer.borderWidth = 1;
    [_weixinLabel setTintColor:[UIColor blackColor]];
    UILabel *downLabel = [UILabel new];
    downLabel.font = [UIFont systemFontOfSize:14];
    if (_isAdver) {
         downLabel.text = @"申请广告主请加官方微信进行审核";
    }else{
         downLabel.text = @"申请加入微信审核请填写好你的真实姓名";
    }
    downLabel.textColor = [UIColor grayColor];
    UIButton *knowBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [knowBtn setTitle:@"申请推广员须知" forState:0];
    [knowBtn addTarget:self action:@selector(upKnowButton) forControlEvents:UIControlEventTouchUpInside];
    [knowBtn setTintColor:[UIColor blackColor]];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIImageView *knowImg = [UIImageView new];
    knowImg.image = [UIImage imageNamed:@"salary1_03"];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = DLBLUECOLOR;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 10;
    [sureBtn setTintColor:[UIColor whiteColor]];
    [sureBtn setTitle:@"完成" forState:0];
    [sureBtn addTarget:self action:@selector(upSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[topLabel,_weixinLabel,downLabel,knowBtn,knowImg,sureBtn]];
    topLabel.sd_layout
    .topSpaceToView(self.view, NAVIH+60)
    .centerXEqualToView(self.view)
    .heightIs(15);
    [topLabel setSingleLineAutoResizeWithMaxWidth:200];
    _weixinLabel.sd_layout
    .topSpaceToView(topLabel, 30)
    .centerXEqualToView(self.view);
    [_weixinLabel setupAutoSizeWithHorizontalPadding:35 buttonHeight:50];
    downLabel.sd_layout
    .topSpaceToView(_weixinLabel, 20)
    .centerXEqualToView(self.view)
    .heightIs(15);
    [downLabel setSingleLineAutoResizeWithMaxWidth:300];
    if (!_isAdver) {
        knowBtn.sd_layout
        .topSpaceToView(downLabel, 60)
        .centerXEqualToView(self.view);
        [knowBtn setupAutoSizeWithHorizontalPadding:5 buttonHeight:20];
        knowImg.sd_layout
        .topEqualToView(knowBtn)
        .rightSpaceToView(knowBtn, 0)
        .heightIs(20)
        .widthIs(20);
    }
    
    sureBtn.sd_layout
    .topSpaceToView(knowBtn, 40)
    .heightIs(45)
    .centerXEqualToView(self.view)
    .widthIs(315);
    if (_isAdver) {
        sureBtn.sd_layout
        .topSpaceToView(downLabel, 60);
    }
}
//点击了申请推广员须知
-(void)upKnowButton{
    DLAdverAgreementViewController *sdView = [DLAdverAgreementViewController new];
    sdView.isApply = YES;
    [self.navigationController pushViewController:sdView animated:YES];
}
//点击了完成
-(void)upSureButton{
    [DLAlert alertWithText:@"申请成功等待审核"];
    UIViewController *viewCtl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCtl animated:YES];
}
@end
