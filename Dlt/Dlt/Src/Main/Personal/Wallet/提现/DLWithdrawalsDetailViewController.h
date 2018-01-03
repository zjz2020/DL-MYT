//
//  DLWithdrawalsDetailViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DLTPayType) {
    DLTPayType_Alipay = 1,  // 支付宝
    DLTPayType_WeChat,      // 微信
    DLTPayType_BankCard     // 银行卡
};


@interface DLWithdrawalsDetailViewController : UIViewController

@property (nonatomic, copy) NSDictionary *paramsDic;

@property (nonatomic, assign) DLTPayType payType;

@end
