//
//  WSRewardConfig.h
//  RedPacketViewDemo
//
//  Created by tank on 2017/12/19.
//  Copyright © 2017年 tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WSRewardConfig : NSObject

@property (nonatomic, assign) float     money;
@property (nonatomic, strong) UIImage   *avatarImage;
//头像字符串
@property (nonatomic, copy) NSString *avatarImageStr;
//是否获取红包
@property (nonatomic, assign, getter=isGetRed)BOOL GedRed;
//红包ID
@property (nonatomic, copy)NSString *redID;

@property (nonatomic, copy  ) NSString  *content;
@property (nonatomic, copy  ) NSString  *userName;

@end
