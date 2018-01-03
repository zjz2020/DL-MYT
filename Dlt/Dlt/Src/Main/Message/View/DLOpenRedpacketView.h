//
//  DLOpenRedpacketView.h
//  Dlt
//
//  Created by Liuquan on 17/6/8.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLOpenRedpacketView,DLRedpackerInfo,DLFriendPacketModel;

@protocol DLOpenRedpacketViewDelegate <NSObject>
@optional
- (void)openRedpacketView:(DLOpenRedpacketView *)redpackerView targetRedpacketInfo:(DLRedpackerInfo *)redpackerInfo;
- (void)openRedpacketView:(DLOpenRedpacketView *)redpackerView checkRedpackerDetail:(DLRedpackerInfo *)redpackerInfo;
- (void)openRedpacketView:(DLOpenRedpacketView *)redpackerView recevieFriendRedpacket:(DLFriendPacketModel *)model;
@end

@interface DLOpenRedpacketView : UIView

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, weak) id<DLOpenRedpacketViewDelegate>delegate;

@property (nonatomic, strong) DLRedpackerInfo *redpackerInfo;

@property (nonatomic, strong) DLFriendPacketModel *friendPacketModel;
@end
