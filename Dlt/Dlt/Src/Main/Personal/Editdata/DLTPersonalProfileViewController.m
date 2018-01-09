//
//  DLTPersonalProfileViewController.m
//  Dlt
//
//  Created by Gavin on 2017/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "DLTPersonalProfileViewController.h"
#import "UINavigationBar+Status.h"
#import "ImageTableViewCell.h"
#import "SelectorphoteCell.h"
#import "ClassinfomationCell.h"
#import "JoingroupCell.h"
#import "JoingroupsCell.h"
#import "DLUploadImage.h"
#import "DLAlert.h"
#import "DltUICommon.h"
#import "RCHttpTools.h"
#import "DLGroupsModel.h"
#import "DLSeachGroupsCell.h"
#import "DLTAddPhotoTableViewCell.h"
#import "DLTPersonalProfileHeaderView.h"
#import "EditProfileViewController.h"
#import "MSSBrowseNetworkViewController.h"
#import "DLPhotosCollectionViewController.h"
#import "BaseNC.h"

#define  kAddPhotosCellId  @"DLTAddPhotoTableViewCellIdentifier"
#define  kClassinfomationCellIdentifier @"DLTClassinfomationCellIdentifier"

typedef NS_ENUM(NSInteger,DLTPersonaProfileUploadImageType){
  DLTPersonaProfileUploadImageTypeDefine,
  DLTPersonaProfileUploadImageTypeAvatar,
  DLTPersonaProfileUploadImageTypeBackground,
  DLTPersonaProfileUploadImageTypePictures,
};

@interface DLTPersonalProfileViewController () <
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
AddPhotosCellDelegate,
TZImagePickerControllerDelegate
>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DLTPersonalProfileHeaderView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray *groupInfoArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;

@property (nonatomic, assign) DLTPersonaProfileUploadImageType uploadType;

@end

@implementation DLTPersonalProfileViewController {
  UIImage *_selectedAvatarImage;
  UIImage *_selectedBackgroundImage;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//  self.title = @"个人资料";

   self.uploadType = DLTPersonaProfileUploadImageTypeDefine;
   self.sectionTitleArray = @[@"相册",@"个人信息",@"加入群聊"];
  
  [self setupTableView];
  [self loadDataSource];
  
  // 用户信息变更订阅
  @weakify(self)
  [[[DLT_USER_CENTER.userInfoChangeSignal takeUntil:self.rac_willDeallocSignal]
    deliverOnMainThread]
   subscribeNext:^(id  _Nullable x) {
     @strongify(self);
     [self.tableHeaderView updatePersonalProfile:DLT_USER_CENTER.curUser];
     [self.tableView reloadData];
   }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationController.navigationBar.hidden = YES;
  [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  self.navigationController.navigationBar.hidden = NO;
}

- (void)loadDataSource{
  [self.tableHeaderView updatePersonalProfile:DLT_USER_CENTER.curUser];
  
  [self dl_networkForUserInfo];
  [self dl_networkForGroupList];
}

- (void)setupTableView{
  _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.tableHeaderView = self.tableHeaderView;
  _tableView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_tableView];
  
  [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
}

#pragma mark - propertys

- (DLTPersonalProfileHeaderView *)tableHeaderView{
  if (!_tableHeaderView) {
    _tableHeaderView  = [[DLTPersonalProfileHeaderView alloc] initWithFrame:(CGRect){CGPointZero,kScreenWidth,282}];
   [_tableHeaderView.backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
   [_tableHeaderView.editorBtn addTarget:self action:@selector(editorClick) forControlEvents:UIControlEventTouchUpInside];
  [_tableHeaderView.userAvatarImageView ui_imageViewAddGestureRecognizerTarget:self action:@selector(clickUserAvatar)];
  [_tableHeaderView.userBackgroundImageview ui_imageViewAddGestureRecognizerTarget:self action:@selector(clickUserBackground)];
  }
  return  _tableHeaderView;
}

- (void)clickUserAvatar{
  self.uploadType = DLTPersonaProfileUploadImageTypeAvatar;
  [self presentAlertController];
}

- (void)clickUserBackground{
  self.uploadType = DLTPersonaProfileUploadImageTypeBackground;
  [self presentAlertController];
}

- (void)presentAlertController{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  
  @weakify(self);
  UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    @strongify(self);
    [self didSeletCameraOrPhotoLibrary:UIImagePickerControllerSourceTypeCamera];
  }];
  UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"从相册选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    @strongify(self);
    [self didSeletCameraOrPhotoLibrary:UIImagePickerControllerSourceTypePhotoLibrary];
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  [alertController addAction:shareAction];
  [alertController addAction:reportAction];
  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)backclick{
 [self.navigationController popViewControllerAnimated:YES];
}

- (void)editorClick{  
  EditProfileViewController * editData = [[EditProfileViewController alloc]init];
  [self.navigationController pushViewController:editData animated:YES];
}

- (NSMutableArray *)groupInfoArray{
  if (!_groupInfoArray) {
    _groupInfoArray = @[].mutableCopy;
  }
  return _groupInfoArray;
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (section == 0) return 1;
  else if (section == 1) return 1;
  else return self.groupInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSInteger section = indexPath.section; NSInteger row = indexPath.row;
  
  if (section == 0){
    DLTAddPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddPhotosCellId];
    if (!cell) {
      cell = [[DLTAddPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAddPhotosCellId];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.photosDelegate = self;
      @weakify(self);
      cell.DLTEnterPhotoAlbum_Block = ^(){
        @strongify(self);
        [self presentPhotosCollectionViewController];
      };
    }        
    cell.userProfile = DLT_USER_CENTER.curUser;
    
    return cell;
  }
  
  else if (section == 1) {
      ClassinfomationCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassinfomationCellIdentifier];
      if (cell == nil) {
        cell = [[ClassinfomationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClassinfomationCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      cell.model = DLT_USER_CENTER.curUser;
    
      return cell;
  }
  
  else  {
    DLSeachGroupsCell *peopleCell = [DLSeachGroupsCell creatSeachGroupCellWithTableView:tableView];
    if (section == 2) {
      peopleCell.infoModel = self.groupInfoArray[row];
    }

    return peopleCell;
  }
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSInteger section = indexPath.section;
  
  if (section == 0) return 135;
  else if (section == 1) return 90;
  else return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  DLTPersonalProfileHeaderSectionView *headerSectionView  = [[DLTPersonalProfileHeaderSectionView alloc] initWithFrame:(CGRect){CGPointZero,kScreenWidth,50}];
  
  if (section == 0) {
   [headerSectionView.enterAlbumBtn addTarget:self action:@selector(enterAlbum:) forControlEvents:UIControlEventTouchUpInside];
  }

  headerSectionView.enterAlbumBtn.hidden = (section == 0)? NO : YES;
  headerSectionView.title = self.sectionTitleArray[section];
  
  return headerSectionView;
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)didSeletCameraOrPhotoLibrary:(UIImagePickerControllerSourceType)pickerType {
  if (pickerType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    //        [DLAlert alertWithText:@"该设备不支持相机"];
    return;
  }
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
  imagePickerController.view.backgroundColor = [UIColor whiteColor];
  imagePickerController.delegate = self;
  imagePickerController.allowsEditing = YES;
  imagePickerController.sourceType = pickerType;
  [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  
 
  if (image) {
    
    if (self.uploadType == DLTPersonaProfileUploadImageTypeAvatar) {
       UIImage *newImage = [self originImage:image scaleToSize:CGSizeMake(120, 120)];
        [self dl_networkForUpdateAvatar:newImage]; // 上传头像
    }
    
    else if (self.uploadType == DLTPersonaProfileUploadImageTypeBackground){
       [self dl_networkForUploadbackImage:image]; // 上传背景
    }
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [picker dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  压缩重新绘制图片
 */
- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)newSize {
  UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
  UIGraphicsBeginImageContext(newSize);  //size 为CGSize类型，即你所需要的图片尺寸
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

#pragma makr -
#pragma makr - AddPhotosCellDelegate

- (void)presentPhotosCollectionViewController{
  DLPhotosCollectionViewController *vc = [DLPhotosCollectionViewController new];
  BaseNC *nc = [[BaseNC alloc] initWithRootViewController:vc];
  [self presentViewController:nc animated:YES completion:nil];
}

- (void)addPhotoTableViewCell:(DLTAddPhotoTableViewCell *)cell
                cellForPhotos:(NSArray <NSString *>*)photos
            cellForImageViews:(NSArray <UIImageView *>*)imageViews
                didClickIndex:(NSInteger )index
{
  NSMutableArray *browseItemArray = @[].mutableCopy;
  for(int i = 0; i < photos.count; i++) {
    UIImageView *imageView = imageViews[i];
    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc] init];
    browseItem.bigImageUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,photos[i]];; // 大图url地址
    browseItem.smallImageView = imageView;// 小图
    [browseItemArray addObject:browseItem];
  }
  
  MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
  // bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
  [bvc showBrowseViewController];
}

- (void)enterAlbum:(UIButton *)button{
  [self presentPhotosCollectionViewController];
}

#pragma mark -
#pragma mark - 数据请求

- (void)dl_networkForUserInfo {
  //[DLT_USER_CENTER requestUpdateUserInfo];
}

/// 获取群数据
- (void)dl_networkForGroupList {
  NSDictionary * dic = @{@"token":DLT_USER_CENTER.token,
                         @"uid":DLT_USER_CENTER.curUser.uid
                         };
  NSString *url = [NSString stringWithFormat:@"%@Group/myGroups",BASE_URL];
  @weakify(self)
  [BANetManager ba_request_POSTWithUrlString:url
                                  parameters:dic
                                successBlock:^(id response) {
                                    @strongify(self)
                                    if ([response[@"code"] integerValue] == 1) {
                                      NSArray *models = response[@"data"];
                                        
                                      NSMutableArray *modelArray = [NSMutableArray new];
                                      for (NSDictionary *model in models) {
                                        DLGroupsInfo *info = [DLGroupsInfo modelWithDictionary:model];
                                         [modelArray addObject:info];
                                      }
                                      
                                      [self.groupInfoArray addObjectsFromArray:modelArray];
                                      [self.tableView reloadSection:2
                                                   withRowAnimation:UITableViewRowAnimationNone];
                                    }
                                  
                            } failureBlock:^(NSError *error) {
                              
                            } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                              
                            }];
}

- (void)dl_networkForUploadbackImage:(UIImage *)image{
   _selectedBackgroundImage = image;
  
  NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
  NSDictionary *params = @{@"uid" : DLT_USER_CENTER.curUser.uid,
                           @"token" :DLT_USER_CENTER.token
                           };
  
    @weakify(self)
   [BANetManager ba_uploadImageWithUrlString:url
                                  parameters:params
                                  imageArray:@[image]
                                    fileName:@""
                                successBlock:^(id response) {
                                  @strongify(self);
                                  if ([response[@"code"] integerValue] == 1){
                                    NSString *backImageURL = response[@"data"][@"src"] ;
                                    [self dl_networkForUpdateUserBackImage:backImageURL];
                                  }
                                  else{
                                   [DLAlert alertWithText:@"上传背景照片出错了"];
                                  }
                                  
                                } failurBlock:^(NSError *error) {
                                 [DLAlert alertWithText:@"上传背景照片出错了"];
                                } upLoadProgress:NULL];
}

- (void)dl_networkForUpdateUserBackImage:(NSString *)backURL{
  NSDictionary *params = @{
                           @"token" : DLT_USER_CENTER.token,
                           @"uid"   : DLT_USER_CENTER.curUser.uid,
                           @"bgImg": backURL
                           };

   NSString *path = [NSString stringWithFormat:@"%@UserCenter/modifyUserInfo",BASE_URL];
  @weakify(self)
  [BANetManager ba_request_POSTWithUrlString:path
                                  parameters:params
                                successBlock:^(id response) {
                                    if ([response[@"code"] integerValue] == 1) {                                  
                                      @strongify(self)
                                       NSString *backImageURL = response[@"data"][@"bgImg"];
                                      DLTUserProfile *newUser = DLT_USER_CENTER.curUser.copy;
                                      newUser.bgImg = backImageURL;
                                      [DLT_USER_CENTER setUserProfile:newUser];
                                      
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        @strongify(self)
                                        self.tableHeaderView.userBackgroundImageview.image = self->_selectedBackgroundImage;
                                      });
                                     }
                                    else{
                                      [DLAlert alertWithText:@"上传背景照片出错了"];
                                    }
                                  } failureBlock:^(NSError *error) {
                                       [DLAlert alertWithText:@"上传背景照片出错了"];
                                  } progress:nil];
}

- (void)dl_networkForUpdateAvatar:(UIImage *)image{
  _selectedAvatarImage = image;
  @weakify(self)
  [[[DLT_USER_CENTER updateUserAvatar:image]
                           takeUntil:self.rac_willDeallocSignal]
                         subscribeNext:^(NSString *avatarURL) {
                           @strongify(self)
                           DLTUserProfile *newUser = DLT_USER_CENTER.curUser.copy;
                           newUser.userHeadImg = avatarURL;
                           [DLT_USER_CENTER setUserProfile:newUser];
                           
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             @strongify(self)
                             self.tableHeaderView.userAvatarImageView.image = self->_selectedAvatarImage;
                           });
                           
                           [self refreshRCIMUserInfo];
                        } error:^(NSError * _Nullable error) {
                           [DLAlert alertWithText:@"上传照片出错了"];
                        } completed:^{
                          
                        }];
}

- (void)refreshRCIMUserInfo{
  DLTUserProfile *user = DLT_USER_CENTER.curUser;
  RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.uid name:user.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,user.userHeadImg]];
  [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:user.uid];
  [RCIM sharedRCIM].currentUserInfo = userInfo;
  for (DLGroupsInfo *info in self.groupInfoArray) {
    [[RCIM sharedRCIM] refreshGroupUserInfoCache:userInfo withUserId:userInfo.userId withGroupId:info.groupId];
      RCGroup *group = [[RCGroup alloc]initWithGroupId:info.groupId groupName:info.groupName portraitUri:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg]];
      [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:info.groupId];
  }
}


@end
