//
//  MaYiOpenView.h
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MaYiOpenViewDelegate <NSObject>

-(void)openViewBtnClick;

@end

@interface MaYiOpenView : UIView
@property (nonatomic , strong)  UIButton         * openBtn;   //开启按钮
@property (nonatomic , weak) id <MaYiOpenViewDelegate> delegate;

@end
