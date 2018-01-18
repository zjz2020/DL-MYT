//
//  DLShowMyQRCodeView.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLShowMyQRCodeView.h"
#import "MKQRCode.h"


@interface DLShowMyQRCodeView ()
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *qrcodeImg;

@end

@implementation DLShowMyQRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self initUI];
    }
    return self;
}

- (void)initUI {
   
    UIView *backView = [[UIView alloc] init];
    self.backView = backView;
    backView.frame = CGRectMake(0, 0, kScreenWidth - 40, kScreenWidth);
    backView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    UIImageView *qr = [[UIImageView alloc] init];
    qr.frame = CGRectMake(30, 30, backView.frame.size.width - 60, backView.frame.size.width - 60);
    qr.image = [self creatQRCode];
    qr.layer.borderWidth = 1;
    qr.layer.borderColor = [UIColor colorWithHexString:@"F6F6F6"].CGColor;
    [backView addSubview:qr];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, CGRectGetMaxY(qr.frame) + 25, backView.frame.size.width, 20);
    label.text = @"扫描二维码，立即加我为蚂蚁通好友";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"9C9C9C"];
    [backView addSubview:label];
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [backView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [backView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [backView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [backView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView = nil;
        [self removeFromSuperview];
    }];
}
-(UIImage *)creatQRCode{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    MKQRCode *code = [[MKQRCode alloc] init];
    NSDictionary *dic = @{
                          @"action" : @"addFriend",
                          @"uid" : [DLTUserCenter userCenter].curUser.uid
                          };
    NSString *content = [self convertToJSON:dic];
    [code setInfo:content withSize:300];
//    [code setInfo:[user objectForKey:@"uid"] withSize:300];
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
