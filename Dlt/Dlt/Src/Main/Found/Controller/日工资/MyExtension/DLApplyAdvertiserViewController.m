//
//  DLApplyAdvertiserViewController.m
//  Dlt
//
//  Created by USER on 2017/10/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLApplyAdvertiserViewController.h"
#import "DLApplyEndViewController.h"
#import "DLAdverAgreementViewController.h"
@interface DLApplyAdvertiserViewController ()<UITextFieldDelegate>
@property (nonatomic , strong)UITextField *workField;
@property (nonatomic , strong)UITextField *weixinField;
@property (nonatomic , strong)UITextField *phoneField;
@property (nonatomic , strong)UIButton *ApplyAdverBtn;
@property (nonatomic , strong)UIButton *chooseBtn;
@end

@implementation DLApplyAdvertiserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    self.navigationItem.title = @"广告主开户申请";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self AddMainView];
}
-(void)AddMainView{
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self SetUpTopView:topView];
    UIButton *pushNoticeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [pushNoticeBtn setTitle:@"申请开户协议书" forState:0];
    [pushNoticeBtn addTarget:self action:@selector(upPushNoticeButton) forControlEvents:UIControlEventTouchUpInside];
    [pushNoticeBtn setTintColor:[UIColor blackColor]];
    pushNoticeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *Image = [[UIImage imageNamed:@"bc_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chooseBtn setImage:Image forState:0];
    _chooseBtn.tag = 10010;
    [_chooseBtn addTarget:self action:@selector(upChooseButton) forControlEvents:UIControlEventTouchUpInside];
    _ApplyAdverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _ApplyAdverBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _ApplyAdverBtn.backgroundColor = [UIColor grayColor];
    _ApplyAdverBtn.layer.masksToBounds = YES;
    _ApplyAdverBtn.layer.cornerRadius = 10;
    [_ApplyAdverBtn setTintColor:[UIColor whiteColor]];
    [_ApplyAdverBtn setTitle:@"广告主申请" forState:0];
    [_ApplyAdverBtn addTarget:self action:@selector(upApplyAdverBtnButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[topView,pushNoticeBtn,_chooseBtn,_ApplyAdverBtn]];
    topView.sd_layout
    .topSpaceToView(self.view, NAVIH+10)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    pushNoticeBtn.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(topView, 25);
    [pushNoticeBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:20];
    _chooseBtn.sd_layout
    .topSpaceToView(topView, 25)
    .heightIs(20)
    .widthIs(20)
    .rightSpaceToView(pushNoticeBtn, 5);
     _ApplyAdverBtn.sd_layout
    .topSpaceToView(pushNoticeBtn, 25)
    .centerXEqualToView(self.view)
    .heightIs(40)
    .widthIs(260);
}
-(void )SetUpTopView:(UIView *)topView{
    NSArray *fieldArray = @[@"推广行业",@"微信号",@"手机号"];
    CGFloat edge =0;
    CGFloat h =0;
    CGFloat length = self.view.frame.size.width;
    CGFloat H = 54;
    for (int i =0; i< fieldArray.count; i++) {
        UITextField *textField = [UITextField new];
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = fieldArray[i];
        [self setTextFieldLeftPadding:textField forWidth:20];
        textField.frame =CGRectMake( edge, h, length, H);
        if (i  > 0) {
            h=h+textField.frame.size.height + 1;
            textField.frame =CGRectMake(edge, h, length, H);
            
        }
        [topView addSubview:textField];
        if (i == 0) {
            _workField = textField;
            
        }
        if (i == 1) {
            _weixinField = textField;
        }
        if (i == 2) {
      
            _phoneField = textField;
            _phoneField.keyboardType = UIKeyboardTypeNumberPad;
            [topView setupAutoHeightWithBottomView:textField bottomMargin:1];
        }
        
        
    }
    
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    [self ButtonIsAdopt];
}
//点击了申请开户协议书
-(void)upPushNoticeButton{
    DLAdverAgreementViewController *sdView = [DLAdverAgreementViewController new];
    [self.navigationController pushViewController:sdView animated:YES];
    
}
//点击了方框
-(void)upChooseButton{
    if (_chooseBtn.tag == 10010) {
        _chooseBtn.tag = 10086;
        UIImage *Image = [[UIImage imageNamed:@"bc_03.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_chooseBtn setImage:Image forState:0];
        
    }else{
         _chooseBtn.tag = 10010;
        UIImage *Image = [[UIImage imageNamed:@"bc_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_chooseBtn setImage:Image forState:0];
    }
    [self ButtonIsAdopt];
}
//点击了广告主申请
-(void)upApplyAdverBtnButton{
    if (_chooseBtn.tag == 10086) {
        DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
        NSString *url = [NSString stringWithFormat:@"%@promote/ApplyAder",BASE_URL];
       
        NSDictionary *param = @{
                                    @"token" : [DLTUserCenter userCenter].token,
                                    @"uid" : user.uid,
                                    @"wxnum":_weixinField.text,
                                    @"industry":_workField.text,
                                    @"phone":_phoneField.text
                                    };
        
        [BANetManager ba_request_POSTWithUrlString:url parameters:param successBlock:^(id response) {
            NSString *str = [NSString stringWithFormat:@"%@",[response valueForKey:@"code"]];
            if ([str isEqualToString:@"1"]) {
                DLApplyEndViewController *sdView = [DLApplyEndViewController new];
                sdView.isAdver = YES;
                [self.navigationController pushViewController:sdView animated:YES];

            }else{
                [DLAlert alertWithText:[response valueForKey:@"msg"]];
            }
            
        } failureBlock:^(NSError *error) {
            [DLAlert alertWithText:@"网络延迟稍后重试"];
        } progress:nil];

       

    }else{
        [DLAlert alertWithText:@"填写完整并同意开户协议"];
    }
}
//判断按钮是否可以点击
-(void)ButtonIsAdopt{
    if (![_workField.text isEqualToString:@""]&&![_weixinField.text isEqualToString:@""] &&![_phoneField.text isEqualToString:@""]&&_chooseBtn.tag ==10086) {
        _ApplyAdverBtn.backgroundColor = DLBLUECOLOR;
    }else{
        _ApplyAdverBtn.backgroundColor = [UIColor grayColor];
    }
}
@end
