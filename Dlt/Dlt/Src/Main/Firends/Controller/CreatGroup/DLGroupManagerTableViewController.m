//
//  DLGroupManagerTableViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//  群组管理

#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "DLGroupManagerTableViewController.h"
#import "DLGroupMemberCell.h"
#import "DLChangeGroupName.h"
#import "DltUICommon.h"
#import "RCDataBaseManager.h"
#import "RCHttpTools.h"
#import "DLGroupHeadImg.h"
#import "DltUICommon.h"
#import "DLGroupMemberTableViewController.h"
#import "DLGroupModel.h"
#import "DLTAssets.h"
#import "BaseNC.h"


@interface DLGroupManagerTableViewController ()<
  UIAlertViewDelegate,
  DLGroupHeadImgDelegate,
  UIActionSheetDelegate,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  TZImagePickerControllerDelegate
>
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupDetail;
@property (nonatomic, strong) NSMutableArray *imageUrl;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic , assign) NSInteger selectedIndex;
@end

@implementation DLGroupManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组管理";
    _selectedArray = @[].mutableCopy;
    self.imageUrl = [NSMutableArray array];
    @weakify(self)
    [[RCHttpTools shareInstance] getGroupInfoForUsByGroupId:self.groupId handle:^(DLGroupInfo *groupInfo) {
        @strongify(self)
        self.groupName = groupInfo.name;
        self.groupDetail = groupInfo.note;
        if (!ISNULLSTR(groupInfo.imgs)) {
            [self.imageUrl removeAllObjects];
            NSArray *arr = [groupInfo.imgs componentsSeparatedByString:@";"];
            for (NSString *imagesUrl in arr) {
                [self.imageUrl addObject:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,imagesUrl]];
            }
        }
        [self.tableView reloadData];
    }];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - tableView/ delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        }
            break;
        case 1: {
            return 2;
        }
            break;
        case 2: {
            return 1;
        }
            break;
        default: {
            return 1;
        }
            break;
    };
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupManagerCellId"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GroupManagerCellId"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        switch (indexPath.section) {
            case 1: {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"群组名称";
                    cell.detailTextLabel.text = self.groupName;
                } else {
                    cell.textLabel.text = @"群组介绍";
                    cell.detailTextLabel.text = self.groupDetail;
                }
            }
                break;
            case 2: {
                cell.textLabel.text = @"群员管理";
            }
                break;
            default: {
                cell.textLabel.text = @"转让群主";
            }
                break;
        }
        return cell;
    } else {
        DLGroupHeadImg *headImgCell = [[DLGroupHeadImg alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headImageCellId"];
        headImgCell.imageArr = self.imageUrl;
        headImgCell.delegate = self;
        return headImgCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return 54;
    }
    CGFloat height;
    if (self.imageUrl.count >= 4) {
        height = ((kScreenSize.width - 50) / 4) * 2 + 15 + 10 + 50;
    } else {
        height = ((kScreenSize.width - 50) / 4) + 15 + 50;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 1: {
            if (indexPath.row == 0) {
                [self changeMyGroupCard];
            } else {
                DLChangeGroupName *changeView = [[DLChangeGroupName alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [[UIApplication sharedApplication].keyWindow addSubview:changeView];
                @weakify(self)
                changeView.groupNameBlock = ^(NSString *note) {
                    @strongify(self)
                    @weakify(self)
                    [DLAlert alertShowLoad];
                    [[RCHttpTools shareInstance] changeGroupNoteByGroupId:self.groupId newGroupNote:note handle:^(BOOL isSuccess) {
                       @strongify(self)
                        if (isSuccess) {
                            self.groupDetail = note;
                            [self.tableView reloadData];
                        }
                        [DLAlert alertHideLoad];
                    }];
                };
            }
        }
            break;
        case 2: {
            [self managerGroupMembers:YES andSetTitle:@"成员管理"];
        }
            break;
        case 3: {
           [self managerGroupMembers:NO andSetTitle:@"转让群主"];
        }
            break;
        default: {
            
        }
            break;
    }
}

- (void)managerGroupMembers:(BOOL)isManager andSetTitle:(NSString *)title {
    DLGroupMemberTableViewController *vc = [DLGroupMemberTableViewController new];
    vc.isAdmin = self.isAdmin;
    vc.isMainGrouper = self.isMainGrouper;
    vc.groupId = self.groupId;
    vc.isManager = isManager;
    [self.navigationController pushViewController:vc animated:YES];
}


// 修改群名字
- (void)changeMyGroupCard {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改群名片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入新的名称";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [DLAlert alertShowLoad];
        UITextField *textField = [alertView textFieldAtIndex:0];
        @weakify(self)
        [[RCHttpTools shareInstance] changeGroupNameByGroupId:self.groupId
                                              targetGroupName:textField.text
                                                       handle:^(BOOL isSuccess) {
                                                           @strongify(self)
                                                           if (isSuccess) {
                                                               [DLAlert alertWithText:@"修改成功"];
                                                              self.groupName = textField.text;
                                                               [self.tableView reloadData];
                                                           } else {
                                                               [DLAlert alertWithText:@"修改失败"];
                                                           }
                                                       }];
    }
}

#pragma mark - 代理
// 添加头像
- (void)addMoreHeadImage {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选", nil];
    [sheet showInView:self.view];
    sheet.tag = 1000;
}

// 设置或删除头像
- (void)groupHeadImg:(DLGroupHeadImg *)headImgCell deleteOrSetImage:(NSInteger)index {
    self.selectedIndex = index;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"设为头像", nil];
    [sheet showInView:self.view];
    sheet.tag = 1001;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0) {
            //拍照
        }
        if (buttonIndex == 1) {
            // 相册
             NSInteger maxCount = 8 - _selectedArray.count - self.imageUrl.count;
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
            imagePickerVc.allowPickingVideo = NO; // NO 不能选择视频
            imagePickerVc.allowTakePicture = YES;
            imagePickerVc.sortAscendingByModificationDate = NO;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            [self presentViewController:imagePickerVc animated:YES completion:NULL];
        }
        return;
    }
    if (actionSheet.tag == 1001) {
        NSString *imageUrl = self.imageUrl[self.selectedIndex];
        if (buttonIndex == 0) {
            if (!ISNULLSTR(imageUrl)) {
                NSString *str = [self deleteImageHostPath:imageUrl];
                @weakify(self)
                [[RCHttpTools shareInstance] deleteGroupImageByGroupId:self.groupId deleteImageUrl:str handle:^(BOOL isSuccess) {
                    @strongify(self)
                    if (isSuccess) {
                        [self.imageUrl removeObjectAtIndex:self.selectedIndex];
                        [self.tableView reloadData];
                        [DLAlert alertWithText:@"删除成功"];
                    } else {
                        [DLAlert alertWithText:@"设置失败"];
                    }
                }];
            }
        }
        if (buttonIndex == 1) {
            if (!ISNULLSTR(imageUrl)) {
                NSString *str = [self deleteImageHostPath:imageUrl];
                [[RCHttpTools shareInstance] changeGroupHeadImgByGroupId:self.groupId forHeadImgUrl:str handle:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [DLAlert alertWithText:@"设置成功"];
                    } else {
                        [DLAlert alertWithText:@"设置失败"];
                    }
//                    nsno
                    // 这里要刷新数据
                }];
            } else {
                [DLAlert alertWithText:@"设置失败"];
            }
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [_selectedArray addObjectsFromArray:photos];
    [self uploadGroupImage];
}


#pragma mark - 上传图片
static bool isFailur;
- (void)uploadGroupImage {
    [DLAlert alertShowLoad];
    NSMutableArray *temp = [NSMutableArray array];
    isFailur = NO;
    dispatch_group_t batch_api_group = dispatch_group_create();
    @weakify(self)
    [self.selectedArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(batch_api_group);
        @strongify(self);
        [self dl_networkForUploadFileWithImageArray:@[obj]
                                       successBlock:^(id response) {
                                           if ([response[@"code"] intValue] == 1){ // code  == 1 代表成功
                                               if(response[@"data"]){
                                                   NSDictionary  * dic = response[@"data"];
                                                   if(dic){
                                                       NSString *imgSrcs = dic[@"src"];
                                                       if(imgSrcs){
                                                           [temp addObject:imgSrcs];
                                                       }
                                                   }
                                               }
                                           }
                                           else{isFailur = YES;}
                                           dispatch_group_leave(batch_api_group);
                                           
                                       } failurBlock:^(NSError *error) {
                                           isFailur = YES;
                                           dispatch_group_leave(batch_api_group);
                                       }];
    }];
    
    dispatch_group_notify(batch_api_group, dispatch_get_main_queue(), ^{
        @strongify(self);
        if (!isFailur) {
            NSString *imagesUrl = [temp componentsJoinedByString:@";"];
            [[RCHttpTools shareInstance] changeGroupImagesByGroupId:self.groupId groupImages:imagesUrl handle:^(BOOL isSuccess,NSString *imageUrl) {
                if (isSuccess) {
                    [self.imageUrl removeAllObjects];
                    for (NSString *imgUrl in [imageUrl componentsSeparatedByString:@";"]) {
                        [self.imageUrl addObject:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,imgUrl]];
                    }
                    [DLAlert alertWithText:@"上传成功"];
                    [self.tableView reloadData];
                }
            }];
        }
        else{
            [DLAlert alertWithText:@"上传图片错误，请重新上传"];
        }
    });
}

- (BAURLSessionTask *)dl_networkForUploadFileWithImageArray:(NSArray *)images successBlock:(void(^)(id response))success failurBlock:(void(^)(NSError *error))failur{
    NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid
                             };
    return [BANetManager ba_uploadImageWithUrlString:url
                                          parameters:params
                                          imageArray:images
                                            fileName:@"groupImage"
                                        successBlock:success
                                         failurBlock:failur
                                      upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                          
                                      }];
}

- (NSString *)deleteImageHostPath:(NSString *)imagePath {
    if ([imagePath hasPrefix:BASE_IMGURL]) {
        return [imagePath substringFromIndex:BASE_IMGURL.length];
    }
    return imagePath;
}
@end
