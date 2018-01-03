//
//  DLSeeMembersTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLSeeMembersTableViewController.h"
#import "DLFriendsCell.h"
#import "DLGroupMemberModel.h"
#import "DLUserInfDetailViewController.h"


@interface DLSeeMembersTableViewController ()

@end

@implementation DLSeeMembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"群成员(%ld)",(long)self.membersArr.count];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.membersArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DLFriendsCell *friendsCell = [DLFriendsCell creatFriendsCellWithTableView:tableView];
    DLGroupMemberInfo *model = self.membersArr[indexPath.row];
    [friendsCell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.headImg]]];
    friendsCell.nickName.text = model.Remrk;
    friendsCell.msgContent.text = model.note;
    friendsCell.headerImg.tag = indexPath.row + 100;
    friendsCell.headImgBlock = ^(NSInteger imgTag) {
        [self clickCellHeadImage:imgTag - 100];
    };
    return friendsCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)clickCellHeadImage:(NSInteger)tag {
    DLGroupMemberInfo *model = self.membersArr[tag];
    DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
    vc.otherUserId = model.Uid;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
