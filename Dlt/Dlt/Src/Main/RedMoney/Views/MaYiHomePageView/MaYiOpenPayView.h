//
//  MaYiOpenPayView.h
//  Dlt
//
//  Created by 陈杭 on 2018/1/12.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocalViewController.h"

typedef NS_ENUM(NSInteger , MaYiOpenPayType) {
    
    MaYiOpenPayBalance = 0,   //余额
    MaYiOpenPayALiPay ,       //支付宝
    
};

@protocol MaYiOpenPayViewDelegate <NSObject>

-(void)openPaySelectPayMethod:(MaYiOpenPayType)payType andPassWord:(NSString *)passWord;

-(void)openPayJumpProtocalCtr:(ProtocalViewController *)protocolCtr;

@end

@interface MaYiOpenPayView : UIView

@property (nonatomic , assign) MaYiOpenPayType      payType;
@property (nonatomic , weak) id <MaYiOpenPayViewDelegate>  delegate;

-(void)show;
-(void)hide;
@end
