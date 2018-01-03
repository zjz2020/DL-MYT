//
//  DLFriendsCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLFriendsInfo;

typedef void(^DLFriendHeadImgBlock)(NSInteger imgTag);
typedef void(^DLClickHeadImgBlock)(DLFriendsInfo *userInfo);
@interface DLFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *msgContent;

@property (nonatomic, strong) DLFriendsInfo *frinedsInfo;
@property (nonatomic, copy) DLFriendHeadImgBlock headImgBlock;
@property (nonatomic, copy) DLClickHeadImgBlock clickBlock;

+ (instancetype)creatFriendsCellWithTableView:(UITableView *)tableView;



@end
