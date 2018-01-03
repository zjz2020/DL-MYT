//
//  DLInvitationNewMemberVC.h
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InvitationSuccessBlock)();
@interface DLInvitationNewMemberVC : UITableViewController
@property (nonatomic, copy) NSString *groupId;

// 这个装着DLGroupMemberInfo 的数组（这个群所有成员的数组）
@property (nonatomic, strong) NSArray *membersArr;
@property (nonatomic, copy) InvitationSuccessBlock successBlock;
@end





@interface DLInvitationNewMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

@end
