//
//  DLMyNewFriendsCell.h
//  Dlt
//
//  Created by Liuquan on 17/6/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLMyNewFriendModel,DLMyNewFriendsCell;


@protocol DLMyNewFriendsCellDelegate <NSObject>
@optional
- (void)myNewFriendCell:(DLMyNewFriendsCell *)cell clickRefuseButtonWtihModel:(DLMyNewFriendModel *)model;
- (void)myNewFriendCell:(DLMyNewFriendsCell *)cell clickRAgreeButtonWtihModel:(DLMyNewFriendModel *)model;
- (void)myNewFriendCell:(DLMyNewFriendsCell *)cell clickHeadImageSeeUserInfomation:(DLMyNewFriendModel *)model;
@end



@interface DLMyNewFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

@property (nonatomic, strong) DLMyNewFriendModel *infoModel;

@property (nonatomic, weak) id<DLMyNewFriendsCellDelegate>delegate;


+ (instancetype)creatCellWithTableView:(UITableView *)tableView;

@end
