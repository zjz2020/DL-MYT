//
//  OpenRdeVC.m
//  RedPacketViewDemo
//
//  Created by Fang on 2018/1/19.
//  Copyright © 2018年 tank. All rights reserved.
//

#import "OpenRdeVC.h"

@interface OpenRdeVC ()
@property (nonatomic, strong)UIImageView *imageV;
@end

@implementation OpenRdeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view.
}
- (void)creatUI{
    self.imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageV.userInteractionEnabled = YES;
    _imageV.image = [UIImage imageNamed:@"WechatIMG1.jpeg"];
    [self.view addSubview:_imageV];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
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
