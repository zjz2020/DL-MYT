//
//  DLMessageListCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCConversationModel;
@interface DLMessageListCell : RCConversationBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *unreadMsgCount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (nonatomic, assign) BOOL isFriendsRequest;

@property (nonatomic, strong) RCConversationModel *conversationModel;

+ (instancetype)creatMessageListCellWithTableView:(UITableView *)tableView;

@end
