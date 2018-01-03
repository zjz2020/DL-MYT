//
//  DLSeachPeopleCell.h
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLSeachPeopleCell,DLFriendsInfo;

@protocol DLSeachPeopleCellDelegate <NSObject>
@optional
- (void)seachPeopleCell:(DLSeachPeopleCell *)seachCell clickAddFriendWithIndx:(NSInteger)indx;
@end


@interface DLSeachPeopleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, weak) id<DLSeachPeopleCellDelegate>delegate;

@property (nonatomic, strong) DLFriendsInfo *infoModel;

+ (instancetype)creatSeachPeopleCellWithTableView:(UITableView *)tableView;

@end
