//
//  MyqrcodeViewController.m
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "MyqrcodeViewController.h"
#import "MKQRCode.h"

@interface MyqrcodeViewController ()
@property(nonatomic, strong) UIImageView *qrCodeImage;

@end

@implementation MyqrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.title = @"我的二维码";
    [self addleftitem];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
}
-(void)initUI {
    self.qrCodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width - 60, kScreenSize.width - 60)];
    self.qrCodeImage.center = CGPointMake(kScreenSize.width / 2, kScreenSize.height / 2);
    self.qrCodeImage.image = [self generateImage];
    [self.view addSubview:self.qrCodeImage];
}

// 生成二维码
-(UIImage *)generateImage {
    MKQRCode *code = [[MKQRCode alloc] init];
    NSDictionary *dic = @{
                          @"action" : @"addFriend",
                          @"uid" : [DLTUserCenter userCenter].curUser.uid
                          };
    NSString *content = [self convertToJSON:dic];
    [code setInfo:content withSize:300];
    code.centerImg = [UIImage imageNamed:@"Login_00"];
    code.style = MKQRCodeStyleCenterImage;
    return [code generateImage];
}

- (NSString *)convertToJSON:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        [DLAlert alertWithText:@"出错了"];
        return nil;
    }else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString.copy;
}


@end
