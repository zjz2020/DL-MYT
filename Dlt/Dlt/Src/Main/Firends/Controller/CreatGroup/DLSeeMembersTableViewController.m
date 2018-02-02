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
#import "NSString+PinYin.h"

@interface DLSeeMembersTableViewController ()
///字母分区
@property (nonatomic, strong)NSMutableDictionary *friendsList;
@property (nonatomic, strong)NSMutableArray *listArray;

@end

@implementation DLSeeMembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = [NSString stringWithFormat:@"群成员(%ld)",(long)self.membersArr.count];
}

#pragma mark - Table view data source
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.listArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = self.listArray[section];
    NSMutableArray *array = [self.friendsList objectForKey:key];
    return array.count;
    //    return self.membersArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = self.listArray[section];
    return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DLFriendsCell *friendsCell = [DLFriendsCell creatFriendsCellWithTableView:tableView];
    NSString *key = self.listArray[indexPath.section];
    NSArray *array = [self.friendsList objectForKey:key];
    //        DLGroupMemberInfo *model = self.membersArr[indexPath.row];
    DLGroupMemberInfo *model = array[indexPath.row];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)clickCellHeadImage:(NSInteger)tag {
    DLGroupMemberInfo *model = self.membersArr[tag];
    DLUserInfDetailViewController *vc = [DLUserInfDetailViewController new];
    vc.otherUserId = model.Uid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setMembersArr:(NSArray *)membersArr{
    _membersArr = membersArr;
    for (DLGroupMemberInfo *info in _membersArr) {
        info.firstLetter = [NSString getFirstNameWithText:info.Remrk];
    }
    [self backFirstLetterWithArray:_membersArr];
}

//处理获取的好友列表
- (void)backFirstLetterWithArray:(NSArray *)friendArray {
    if (!_friendsList) {
        self.friendsList = [NSMutableDictionary new];
    }
    [self.friendsList removeAllObjects];
    [self.listArray removeAllObjects];
    for (DLGroupMemberInfo *friendInfo in self.membersArr) {
        if ([self.friendsList.allKeys containsObject:friendInfo.firstLetter]) {//包含  添加到mArray;
            NSMutableArray *gFriendArray = [self.friendsList objectForKey:friendInfo.firstLetter];
            [gFriendArray addObject:friendInfo];
        } else {
            NSMutableArray *mArray = [NSMutableArray new];
            [mArray addObject:friendInfo];
            [self.friendsList setObject:mArray forKey:friendInfo.firstLetter];
        }
    }
    self.listArray = [[[self.friendsList allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    //    [self.tableView reloadData];
}
@end
