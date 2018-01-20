//
//  WSRedPacketView.m
//  Lottery
//
//  Created by tank on 2017/12/16.
//  Copyright © 2017年 tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WSRedPacketView.h"

//*******************************
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ViewScaleIphone5Value    ([UIScreen mainScreen].bounds.size.width/320.0f)

#define ReceiveAntMoney             @"mayi/get_mayi_rp"//领取蚂蚁红包


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
// CAAnimationDelegate is not available before iOS 10 SDK
@interface WSRedPacketView ()<UIGestureRecognizerDelegate>
#else
@interface WSRedPacketView () <CAAnimationDelegate,UIGestureRecognizerDelegate>
#endif

@property (nonatomic,strong) UIWindow       *alertWindow;
@property (nonatomic,strong) UIImageView    *backgroundImageView;
@property (nonatomic,strong) WSRewardConfig *data;
@property (nonatomic,strong) UIImageView    *avatarImageView;
@property (nonatomic,strong) UILabel        *userNameLabel;
@property (nonatomic,strong) UILabel        *tipsLabel;
@property (nonatomic,strong) UILabel        *messageLabel;
@property (nonatomic,strong) UILabel        *noRedPageLabel;
@property (nonatomic,strong) UIButton       *openButton;
@property (nonatomic,strong) UIButton       *closeButton;

@property (nonatomic,copy) WSCancelBlock    cancelBlock;
@property (nonatomic,copy) WSFinishBlock    finishBlock;

@end

@implementation WSRedPacketView

+ (instancetype)showRedPackerWithData:(WSRewardConfig *)data
                          cancelBlock:(WSCancelBlock)cancelBlock
                          finishBlock:(WSFinishBlock)finishBlock
{
    WSRedPacketView *redPacketView = [[self alloc]initRedPackerWithData:data
                                                          cancelBlock:cancelBlock
                                                          finishBlock:finishBlock];
    return redPacketView;
}

- (instancetype)initRedPackerWithData:(WSRewardConfig *)data
                          cancelBlock:(WSCancelBlock)cancelBlock
                          finishBlock:(WSFinishBlock)finishBlock
{
    self = [super init];
    
    if (self) {
        
        _data = data;
        
        [self.alertWindow addSubview:self.view];
        [self.alertWindow addSubview:self.backgroundImageView];
        [self.alertWindow addSubview:self.closeButton];
        
        self.cancelBlock = cancelBlock;
        self.finishBlock = finishBlock;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViewAction)];
        tapGesture.delegate = self;
        [self.view addGestureRecognizer:tapGesture];

    }
    return self;
}

- (UIWindow *)alertWindow
{
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        _alertWindow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [_alertWindow makeKeyAndVisible];
        _alertWindow.rootViewController = self;
    }
    return _alertWindow;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        
        UIImage *image =  [UIImage imageNamed:@"mayi_25"];
        
        CGFloat width = xyzW(283);
        CGFloat height = width * (image.size.height / image.size.width);
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25 * ViewScaleIphone5Value, xyzH(75), width, height)];
        _backgroundImageView.centerX = kScreenWidth/2;
        _backgroundImageView.image = image;
        
        [_backgroundImageView addSubview:self.openButton];
        [_backgroundImageView addSubview:self.avatarImageView];
        [_backgroundImageView addSubview:self.userNameLabel];
        [_backgroundImageView addSubview:self.tipsLabel];
        [_backgroundImageView addSubview:self.noRedPageLabel];
        [_backgroundImageView addSubview:self.messageLabel];
        if (_data.isGetRed) {
            self.userNameLabel.hidden = NO;
            self.tipsLabel.hidden = NO;
            self.noRedPageLabel.hidden = YES;
            self.messageLabel.hidden = NO;
        } else {
            self.userNameLabel.hidden = YES;
            self.tipsLabel.hidden = YES;
            self.noRedPageLabel.hidden = NO;
            self.messageLabel.hidden = NO;
        }
        self.backgroundImageView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        
        [UIView animateWithDuration:.15
                         animations:^{
                             self.backgroundImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         }completion:^(BOOL finish){
                             [UIView animateWithDuration:.15
                                              animations:^{
                                                  self.backgroundImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                              }completion:^(BOOL finish){
                                                  [UIView animateWithDuration:.15
                                                                   animations:^{
                                                                       self.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
                                                                   }];
                                              }];
                         }];
    }
    return _backgroundImageView;
}

- (UIButton *)openButton
{
    if (!_openButton) {

        CGFloat widthOrHeight = xyzW(100);
        
        _openButton = [[UIButton alloc]initWithFrame:CGRectMake(_backgroundImageView.frame.size.width/2 - widthOrHeight/2, CGRectGetMaxY(self.messageLabel.frame) + xyzW(30) , widthOrHeight,widthOrHeight)];
        if (_data.isGetRed) {
            [_openButton setImage:[UIImage imageNamed:@"mayi_26"] forState:UIControlStateNormal];
        } else {
             [_openButton setImage:[UIImage imageNamed:@"mayi_27"] forState:UIControlStateNormal];
            _openButton.userInteractionEnabled = NO;
        }
        
    }
    return _openButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backgroundImageView.frame) + xyzH(30), xyzH(34), xyzH(34))];
        _closeButton.centerX = kScreenWidth/2;
        [_closeButton addTarget:self action:@selector(closeViewAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"mayi_03"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_backgroundImageView.frame.size.width/2 - 24, xyzW(67), xyzW(65), xyzW(65))];
        _avatarImageView.centerX = _backgroundImageView.width/2;
        
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = xyzW(32.5);
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
          NSString *imagestr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,_data.avatarImageStr];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"friend_new"]];
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame) + xyzW(14), _backgroundImageView.width, 20)];
        _userNameLabel.textColor = rgb(247, 191, 154);
        _userNameLabel.font = [UIFont systemFontOfSize:17];
        _userNameLabel.text = _data.userName;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameLabel.frame) + xyzW(10), _backgroundImageView.width, 20)];
        _tipsLabel.textColor = rgb(247, 191, 154);
        _tipsLabel.font = [UIFont systemFontOfSize:17];
        NSString *tipStr = @"您抢到他的一个红包";
        _tipsLabel.text = tipStr;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UILabel *)noRedPageLabel{
    if (!_noRedPageLabel) {
        self.noRedPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame) + xyzW(35), self.backgroundImageView.width, xyzW(25))];
        _noRedPageLabel.textColor = rgb(247, 191, 154);
        _noRedPageLabel.font = [UIFont systemFontOfSize:xyzW(25)];
        NSString *tipStr = @"你手慢了";
        _noRedPageLabel.text = tipStr;
        _noRedPageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noRedPageLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipsLabel.frame) + xyzW(30), _backgroundImageView.frame.size.width, xyzW(20))];
        _messageLabel.textColor = rgb(255, 255, 255);
        _messageLabel.font = [UIFont systemFontOfSize:xyzW(20)];;
        _messageLabel.text = _data.content;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (void)closeViewAction{

    [UIView animateWithDuration:.2 animations:^{
        self.backgroundImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        self.closeButton.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:.01
//                         animations:^{
//                             self.backgroundImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
//                         }completion:^(BOOL finish){
//
//                         }];
        [self.alertWindow removeFromSuperview];
        self.alertWindow.rootViewController = nil;
        self.alertWindow = nil;
        
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];

}
///开启红包成功
- (void)openViewActionWithMoney:(CGFloat)money{
    [UIView animateWithDuration:.2 animations:^{
        self.backgroundImageView.transform = CGAffineTransformMakeScale(2.2, 2.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.01
                         animations:^{
//                             self.backgroundImageView.transform = CGAffineTransformMakeScale(0.25, 0.25);
                         }completion:^(BOOL finish){
                             [self.alertWindow removeFromSuperview];
                             self.alertWindow.rootViewController = nil;
                             self.alertWindow = nil;
                             
                             if (self.finishBlock) {
                                 self.finishBlock(money);
                             }
                             
                         }];
    }];
}
- (void)openRedPacketAction
{
//    if (!self.data.isGetRed) {
//        return;
//    }
    [_openButton.layer addAnimation:[self confirmViewRotateInfo] forKey:@"transform"];
}

- (CAKeyframeAnimation *)confirmViewRotateInfo
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.28, 0, 0.5, 0)],
                           nil];
    
    
    theAnimation.cumulative = YES;
    theAnimation.duration = .4;
    theAnimation.repeatCount = 3;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    
    return theAnimation;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {

    if ([_openButton pointInside:[touch locationInView:_openButton] withEvent:nil]) {
        
        [self openRedPacketAction];
        
        return NO;
    }

    if ([_closeButton pointInside:[touch locationInView:_closeButton] withEvent:nil]) {
        
        [self closeViewAction];
        
        return NO;
    }
    return NO;
//    return (![_backgroundImageView pointInside:[touch locationInView:_backgroundImageView] withEvent:nil]);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    //动画完成 进行数据请求
    [self antGetRedMoneyWithMoneyid:_data.redID userName:_data.userName userImageStr:_data.avatarImageStr];
    
//    if (self.finishBlock) {
//        self.finishBlock(_data.money);
//    }
//    _messageLabel.text = [NSString stringWithFormat:@"中奖金额%.2f",_data.money];
}
#pragma mark 蚂蚁领取红包
//蚂蚁领红包
- (void)antGetRedMoneyWithMoneyid:(NSString *)moneyid  userName:(NSString *)name userImageStr:(NSString *)headImageStr{
    NSString *antGetRedMoney = [NSString stringWithFormat:@"%@%@",BASE_URL,ReceiveAntMoney];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    if (![self judeCityCode]) {
        return;
    }
    NSDictionary *parameter = @{
                                @"cityCode":[DLTUserCenter userCenter].cityCode,
                                @"rpid":moneyid,
                                @"uid":user.uid,
                                @"token":user.token
                                };
    @weakify(self);
    [BANetManager ba_request_POSTWithUrlString:antGetRedMoney parameters:parameter successBlock:^(id response) {
        NSLog(@"GetRedMoney:%@",response);
        @strongify(self);
        //        MaYiRedPacketView *packeV = [[MaYiRedPacketView alloc] initWithFrame:self.view.bounds];
        //        packeV.delegate = self;
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        [window addSubview:packeV];
        if ([response[@"code"] isEqual:@0]) {//手慢了
            [self openViewActionWithMoney:-1];
            //            packeV.showType = MaYiRedPacketNone;
//            [self openRedPacketActionSucess:NO headImage:headImageStr redName:name];
        } else if ([response[@"code"] isEqual:@1]){//领取成功
            [self openViewActionWithMoney:_data.money];
        }
        //领取蚂蚁红包
        //         [self openRedPacketAction];
    } failureBlock:^(NSError *error) {
        NSLog(@"GetRedMoney:%@",error);
        [DLAlert alertWithText:@"抢红包失败,请刷新重试" afterDelay:3];
    } progress:nil];
}
//判断是否有cityCode
- (BOOL)judeCityCode{
    if (![DLTUserCenter userCenter].cityCode || [DLTUserCenter userCenter].cityCode.length < 4) {
        [DLAlert alertWithText:@"蚂蚁未获取到你的定位,请重试" afterDelay:3];
        return NO;
    }
    return YES;
}
- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
