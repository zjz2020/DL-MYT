//
//  DLPayTypeView.h
//  Dlt
//
//  Created by Liuquan on 17/6/8.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLPayTypeView;

typedef NS_ENUM(NSUInteger, DLRedpackerPaytype){
    DLRedpackerPaytype_Balance  = 100,        // 余额支付
    DLRedpackerPaytype_Alipay   = 101,        // 支付宝支付
    DLRedpackerPaytype_WechatPay   = 102      // 微信支付
};


@protocol DLPayTypeViewDelegate <NSObject>
@optional
- (void)payTypeView:(DLPayTypeView *)payView andPayCount:(NSString *)payCount andPayType:(DLRedpackerPaytype)payType;
@end


@interface DLPayTypeView : UIView

@property (nonatomic, assign) DLRedpackerPaytype payType;

@property (nonatomic, strong) NSString *payCount;

@property (nonatomic, weak) id<DLPayTypeViewDelegate>delegate;

+ (DLPayTypeView *)shareInstance;

- (void)popAnimationView:(UIView *)supView;

@end
