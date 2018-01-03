//
//  DLWalletPayModel.m
//  Dlt
//
//  Created by Liuquan on 17/6/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLWalletPayModel.h"

@implementation DLWalletPayModel

+ (NSArray *)paymodelInstance {
    
    DLWalletPayModel *model1 = [DLWalletPayModel new];
    model1.icon = @"wallet_08";
    model1.title = @"支付宝";
    model1.content = @"推荐使用支付宝";
    model1.isSelectedPay = YES;
    model1.isOpen = YES;
    model1.payType = @"aliPay";
    
    DLWalletPayModel *model2 = [DLWalletPayModel new];
    model2.icon = @"wallet_09";
    model2.title = @"微信";
    model2.content = @"推荐安装微信5.0及以上版本使用";
    model2.isSelectedPay = NO;
    model2.isOpen = NO;
    model2.payType = @"weChatPay";
    
    DLWalletPayModel *model3 = [DLWalletPayModel new];
    model3.icon = @"wallet_10";
    model3.title = @"银行卡";
    model3.content = @"选择你的银行卡";
    model3.isSelectedPay = NO;
    model3.isOpen = NO;
    model3.payType = @"bankCard";
    
    return @[model1,model2,model3];
    //return @[model1];
}

@end
