//
//  DLGroupRedpacketViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLGroupRedpacketViewController;

typedef NS_ENUM(NSInteger, DLGroupRedpackerType) {
    DLGroupRedpackerType_Random = 100,   // 随机红包
    DLGroupRedpackerType_Fixed = 101     // 固定红包
};

@protocol DLGroupRedpacketVCDelegate <NSObject>
@optional
- (void)groupRedpackerViewController:(DLGroupRedpacketViewController *)controller
             sendRedpackerWithParams:(NSMutableDictionary *)params;
@end

extern NSString * const kGroupRedpackerDetailKey;
extern NSString * const kGroupRedpackertMoneyKey;
extern NSString * const kGroupPayPassWordKey;
extern NSString * const kGroupRedpackerTypeKey;
extern NSString * const kGroupRedpackerCountKey;


@interface DLGroupRedpacketViewController : UIViewController

@property (nonatomic, assign) DLGroupRedpackerType redpackerType;

@property (nonatomic, assign) NSInteger membersCount;

@property (nonatomic, weak) id<DLGroupRedpacketVCDelegate>delegate;

@end
