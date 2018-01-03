//
//  DLMyExtionViewController.m
//  Dlt
//
//  Created by USER on 2017/9/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLMyExtionViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLEditpromotionViewController.h"
#import "DLTaskViewController.h"
#import "DLApplyAdvertiserViewController.h"
@interface DLMyExtionViewController ()
@property (nonatomic , strong)UIButton *AdvertiserBtn;

@end

@implementation DLMyExtionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_isApply) {
        self.navigationItem.title = @"项目推广类型";
    }else{
        self.navigationItem.title = @"我的推广";
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addMianView];
    
}
-(void)addMianView{
    UILabel *topLable = [UILabel new];
    topLable.font = [UIFont systemFontOfSize:24];
    UIImageView *leftImg = [UIImageView new];
    UILabel *leftLable = [UILabel new];
    leftLable.font = [UIFont systemFontOfSize:17];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn addTarget:self action:@selector(upLeftButton) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImg = [UIImageView new];
    UILabel *rightLabel = [UILabel new];
    rightLabel.font = [UIFont systemFontOfSize:17];
    
    if (_isApply) {
        topLable.text = @"请选择项目推广类型";
        leftImg.image = [UIImage imageNamed:@"imageText"];
        leftLable.text = @"图文推广";
        rightImg.image = [UIImage imageNamed:@"connent"];
        rightLabel.text = @"链接推广";
        
    }else{
        topLable.text = @"请选择你的身份";
        leftImg.image = [UIImage imageNamed:@"salary2_01"];
        leftLable.text = @"努力推广员";
        rightImg.image = [UIImage imageNamed:@"salary2_02"];
        rightLabel.text = @"土豪广告主";
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn addTarget:self action:@selector(upRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[topLable,leftImg,leftLable,leftBtn,rightImg,rightLabel,rightBtn]];
    
    topLable.sd_layout
    .topSpaceToView(self.view, 65+NAVIH)
    .centerXEqualToView(self.view)
    .heightIs(30);
    [topLable setSingleLineAutoResizeWithMaxWidth:300];
    leftImg.sd_layout
    .topSpaceToView(topLable, 65)
    .leftSpaceToView(self.view, 65)
    .heightIs(90)
    .widthIs(90);
    leftLable.sd_layout
    .topSpaceToView(leftImg, 15)
    .heightIs(20)
    .centerXEqualToView(leftImg);
    [leftLable setSingleLineAutoResizeWithMaxWidth:200];
    leftBtn.sd_layout
    .topEqualToView(leftImg)
    .leftEqualToView(leftImg)
    .rightEqualToView(leftImg)
    .bottomEqualToView(leftLable);
    rightImg.sd_layout
    .topSpaceToView(topLable, 65)
    .rightSpaceToView(self.view, 65)
    .heightIs(90)
    .widthIs(90);
    rightLabel.sd_layout
    .topSpaceToView(rightImg, 15)
    .heightIs(20)
    .centerXEqualToView(rightImg);
    [rightLabel setSingleLineAutoResizeWithMaxWidth:200];
    rightBtn.sd_layout
    .topEqualToView(rightImg)
    .leftEqualToView(rightImg)
    .rightEqualToView(rightImg)
    .bottomEqualToView(rightLabel);
    if (_isApply) {
        UILabel *rightDownLabel =[UILabel new];
        rightDownLabel.textColor = [UIColor grayColor];
        rightDownLabel.font = [UIFont systemFontOfSize:12];
        rightDownLabel.textAlignment  = NSTextAlignmentCenter;
        rightDownLabel.text = @"微信转发次数计费20元/次";
        UILabel *leftDownLabel = [UILabel new];
        leftDownLabel.textColor = [UIColor grayColor];
        leftDownLabel.textAlignment  = NSTextAlignmentCenter;
        leftDownLabel.font = [UIFont systemFontOfSize:12];
        leftDownLabel.text = @"微信发布次数计费10元/次";
     
        
        [self.view sd_addSubviews:@[leftDownLabel,rightDownLabel]];
        leftDownLabel.sd_layout
        .topSpaceToView(leftLable, 15)
        .leftEqualToView(leftImg)
        .rightEqualToView(leftImg)
        .autoHeightRatio(0);
        rightDownLabel.sd_layout
        .topSpaceToView(rightLabel, 15)
        .leftEqualToView(rightImg)
        .rightEqualToView(rightImg)
        .autoHeightRatio(0);
        if (!_isAdvertiser) {
            _AdvertiserBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _AdvertiserBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            _AdvertiserBtn.backgroundColor = DLBLUECOLOR;
            _AdvertiserBtn.layer.masksToBounds = YES;
            _AdvertiserBtn.layer.cornerRadius = 10;
            [_AdvertiserBtn setTintColor:[UIColor whiteColor]];
            [_AdvertiserBtn setTitle:@"广告主申请" forState:0];
            [_AdvertiserBtn addTarget:self action:@selector(upAdvertiserBtnButton) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_AdvertiserBtn];
            _AdvertiserBtn.sd_layout
            .topSpaceToView(leftDownLabel, 75)
            .centerXEqualToView(self.view)
            .heightIs(40)
            .widthIs(260);
        }
    }
}
//点击努力推广员
-(void)upLeftButton{
    if (_isApply) {
        if (_isAdvertiser) {
            DLEditpromotionViewController *sdView = [DLEditpromotionViewController new];
            sdView.islink = NO;
            [self.navigationController pushViewController:sdView animated:YES];

        }else{
            DLApplyAdvertiserViewController *sdView = [DLApplyAdvertiserViewController new];
            [self.navigationController pushViewController:sdView animated:YES];
        }
        
    }else{
        DLTaskViewController *sdView = [DLTaskViewController new];
        [self.navigationController pushViewController:sdView animated:YES];
    }
    
}
//点击土豪广告主
-(void)upRightButton{
    if (_isApply) {
        if (_isAdvertiser) {
            DLEditpromotionViewController *sdView = [DLEditpromotionViewController new];
            sdView.islink = YES;
            [self.navigationController pushViewController:sdView animated:YES];
        }else{
            DLApplyAdvertiserViewController *sdView = [DLApplyAdvertiserViewController new];
            [self.navigationController pushViewController:sdView animated:YES];
        }
        
    }else{
        DLTaskViewController *sdView = [DLTaskViewController new];
        sdView.isVulgarTycoon = YES;
        [self.navigationController pushViewController:sdView animated:YES];

    }
    
}
//点击广告主申请
-(void)upAdvertiserBtnButton{
    DLApplyAdvertiserViewController *sdView = [DLApplyAdvertiserViewController new];
    [self.navigationController pushViewController:sdView animated:YES];
}

@end
