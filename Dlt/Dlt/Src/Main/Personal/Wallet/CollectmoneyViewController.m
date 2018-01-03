//
//  CollectmoneyViewController.m
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "CollectmoneyViewController.h"
#import "MKQRCode.h"


@interface CollectmoneyViewController ()
@property(nonatomic, strong) UIImageView *qrCodeImage;
@property(nonatomic, strong) UILabel *alertLabel;

@end

@implementation CollectmoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收钱";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self addleftitem];
}
-(void)initUI {
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75 + NAVIH, self.view.frame.size.width, 25)];
    self.alertLabel.font = AdaptedFontSize(17);
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    self.alertLabel.textColor = [UIColor colorWithHexString:@"444444"];
    self.alertLabel.text = @"无需加好友,扫二维码向我付款";
    [self.view addSubview:self.alertLabel];
    
    self.qrCodeImage = [[UIImageView alloc]init];
    self.qrCodeImage.frame = CGRectMake(50, CGRectGetMaxY(self.alertLabel.frame) + 44, kScreenSize.width - 100, kScreenSize.width - 100);
    self.qrCodeImage.layer.borderColor = [UIColor colorWithHexString:@"f6f6f6"].CGColor;
    self.qrCodeImage.layer.borderWidth = 1;
    self.qrCodeImage.top_sd = self.alertLabel.bottom_sd + 40;
    self.qrCodeImage.image = [self generateImage];
    [self.view addSubview:self.qrCodeImage];
}

// 生成二维码
-(UIImage *)generateImage {
    MKQRCode *code = [[MKQRCode alloc] init];
    NSDictionary *dic = @{
                          @"action" : @"transfer",
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
