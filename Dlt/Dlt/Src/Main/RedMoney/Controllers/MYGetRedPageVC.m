//
//  MYGetRedPageVC.m
//  Dlt
//
//  Created by Fang on 2018/1/19.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MYGetRedPageVC.h"
#import "MaYiRedPacketDetailController.h"

@interface MYGetRedPageVC ()
@property (nonatomic,strong) UIImageView *headImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *montyLabel;
@property (nonatomic,strong) UILabel *yuanLabel;
@property (nonatomic, strong) UILabel *noRedPageLabel;
@end

@implementation MYGetRedPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢红包";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    // Do any additional setup after loading the view.
}
- (void)creatUI{
    UIImageView *lowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, xyzH(345))];
    lowImageView.image = [UIImage imageNamed:@"mayi_28"];
    lowImageView.userInteractionEnabled = YES;
    [self.view addSubview:lowImageView];
    
    //头像
    self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, xyzW(30), xyzH(68), xyzH(68))];
    
    NSString *imagestr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,self.headImageStr];
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"friend_new"]];
    _headImageV.layer.masksToBounds = YES;
    _headImageV.layer.cornerRadius = xyzH(34);
    _headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageV.layer.borderWidth = 1;
    _headImageV.centerX = kScreenWidth/2;
    
    //名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageV.frame) + xyzH(15),kScreenWidth , xyzH(17))];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:xyzH(17)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = [NSString stringWithFormat:@"%@%@",self.nameStr,@"的红包"];
    
    //恭喜您抢到
    UILabel *gongx = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) +xyzH(15), kScreenWidth, xyzH(17))];
    gongx.textColor = [UIColor whiteColor];
    gongx.font = [UIFont systemFontOfSize:xyzH(17)];
    gongx.textAlignment = NSTextAlignmentCenter;
    gongx.text = @"恭喜你抢到";
    
    //金额
    self.montyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(gongx.frame) + xyzH(30), kScreenWidth/2 + 20, xyzH(40))];
    _montyLabel.text = @"1.00";
    _montyLabel.textAlignment = NSTextAlignmentRight;
    _montyLabel.textColor = rgb(255, 241, 0);
    _montyLabel.font = [UIFont systemFontOfSize:40];
    
    self.yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_montyLabel.frame) + 5, 0, 50, xyzH(25))];
    _yuanLabel.bottom = _montyLabel.bottom;
    _yuanLabel.text = @"元";
    _yuanLabel.textColor = rgb(255, 241, 0);
    
    self.noRedPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headImageV.frame) + xyzW(40), kScreenWidth, xyzW(25))];
    _noRedPageLabel.textColor = rgb(247, 191, 154);
    _noRedPageLabel.font = [UIFont systemFontOfSize:xyzW(25)];
    NSString *tipStr = @"你手慢了";
    _noRedPageLabel.text = tipStr;
    _noRedPageLabel.textAlignment = NSTextAlignmentCenter;
    
    //不要气馁
    UILabel *buQInei = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noRedPageLabel.frame) + xyzW(30), kScreenWidth, xyzW(25))];
    buQInei.text = @"不要气馁,再接再励 !";
    buQInei.font = [UIFont systemFontOfSize:xyzW(25)];
    buQInei.textAlignment = NSTextAlignmentCenter;
    buQInei.textColor = [UIColor whiteColor];
    
    //抢更多红包
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, CGRectGetMaxY(_montyLabel.frame) + xyzH(30), xyzW(130), xyzH(28));
    moreBtn.layer.masksToBounds = YES;
    moreBtn.layer.cornerRadius = xyzW(14);
    moreBtn.centerX = kScreenWidth/2;
    moreBtn.backgroundColor = rgb(255, 241, 0);
    [moreBtn setTitle:@"抢更多红包" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitleColor:rgb(44, 44, 44) forState:UIControlStateNormal];
    
    //添加控件
    [lowImageView addSubview:_headImageV];
    [lowImageView addSubview:_nameLabel];
    [lowImageView addSubview:gongx];
    [lowImageView addSubview:_montyLabel];
    [lowImageView addSubview:_yuanLabel];
    [lowImageView addSubview:_noRedPageLabel];
    [lowImageView addSubview:buQInei];
    [lowImageView addSubview:moreBtn];
    
    if (self.haveOrNO) {//获取红包
        self.nameLabel.hidden = NO;
        gongx.hidden = NO;
        _montyLabel.hidden = NO;
        _yuanLabel.hidden = NO;
        _noRedPageLabel.hidden = YES;
        buQInei.hidden = YES;
    } else {//没有获取红包
        self.nameLabel.hidden = YES;
        gongx.hidden = YES;
        _montyLabel.hidden = YES;
        _yuanLabel.hidden = YES;
        _noRedPageLabel.hidden = NO;
        buQInei.hidden = NO;
    }
    
    //查看领取记录
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看领取记录>" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, CGRectGetMaxY(lowImageView.frame) + xyzH(30), kScreenWidth, xyzH(20));
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickHistoryBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clickHistoryBtn{
    MaYiRedPacketDetailController *redPacket = [[MaYiRedPacketDetailController alloc] init];
    [self.navigationController pushViewController:redPacket animated:YES];
}
- (void)clickMoreBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
