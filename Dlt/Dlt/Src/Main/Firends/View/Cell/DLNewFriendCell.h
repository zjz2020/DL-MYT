//
//  DLNewFriendCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLNewFriendCell;

@protocol DLNewFriendCellDelegate <NSObject>
@optional
- (void)dl_friendCell:(DLNewFriendCell *)cell clickButtonWithTag:(NSInteger)tag;

@end

@interface DLNewFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;


@property (nonatomic, weak) id<DLNewFriendCellDelegate>delegate;

+ (instancetype)creatNewFriendCellWithTableView:(UITableView *)tableView;

@end
