//
//  DLPrivateRedPacketViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLPrivateRedpacketDelegate <NSObject>
@optional
- (void)privateRedpacketViewController:(UIViewController *)controller sureSendRedpacker:(NSDictionary *)content;
@end

extern NSString * const kRemarkKey;
extern NSString * const ktotalMoneyKey;
extern NSString * const kPassWordKey;

@interface DLPrivateRedPacketViewController : UIViewController

@property (nonatomic, weak) id<DLPrivateRedpacketDelegate>delegate;

@end
