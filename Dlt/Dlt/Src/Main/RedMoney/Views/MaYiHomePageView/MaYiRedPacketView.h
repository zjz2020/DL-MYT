//
//  MaYiRedPacketView.h
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MaYiRedPacketType) {
    
    MaYiRedPacketNone = 0,   //没抢到
    MaYiRedPacketGet,       //抢到
    
};

@protocol MaYiRedPacketViewDelegate <NSObject>

-(void)redPacketCheckBtnClick;

@end

@interface MaYiRedPacketView : UIView

@property (nonatomic , assign) MaYiRedPacketType      showType;
@property (nonatomic , weak) id <MaYiRedPacketViewDelegate>  delegate;

@end
