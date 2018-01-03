//
//  EditProfileViewController.m
//  Dlt
//
//  Created by USER on 2017/6/5.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
#import "EditProfileViewController.h"
#import "ChangephoneCell.h"
#import "ChagepasswordCell.h"
#import "HcdDateTimePickerView.h"
#import "DLTPersonalProfileViewController.h"
#import "HZQDatePickerView.h"
#import "LTAlertView.h"
#import "SingelCell.h"
#import "SingerViewController.h"
#import "DltUICommon.h"
#import "CityPickView.h"
#import "UINavigationBar+Awesome.h"
#import "DLGroupsModel.h"

#define ChangephoneCellInderifer @"ChangephoneCellInderifer"
#define ChagepasswordCellInderifer @"ChagepasswordCellInderifer"
#define SingelCellInderifer @"SingelCellInderifer"

@interface EditProfileViewController ()<
  HZQDatePickerViewDelegate,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate
>
{
  NSString * imagestr;
  HZQDatePickerView *_pikerView;
  ChangephoneCell * nianlianCell;
//  NSString * _username;
  NSString * _birthday;
  NSString * _sex;
  NSString * _singer;
  
  CityPickView *_cityPickView;
  UIView *_pickViewBackgroundView;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"编辑资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self back:@"friends_15"];
    [self rightTitle:@"保存"];
  
    [self.tableView registerClass:[ChangephoneCell class] forCellReuseIdentifier:ChangephoneCellInderifer];
    [self.tableView registerClass:[ChagepasswordCell class] forCellReuseIdentifier:ChagepasswordCellInderifer];
      [self.tableView registerClass:[SingelCell class] forCellReuseIdentifier:SingelCellInderifer];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];

//   self.navigationController.navigationBar.hidden = NO;
  [self.tableView reloadData];
}


- (void)rightclicks{
  @weakify(self);
    DLTUserProfile * userid = [DLTUserCenter userCenter].curUser;
    if (_birthday == nil) {
        return[DLAlert alertWithText:@"您还未修改信息"];
    }
    else{
      NSDictionary *params = @{@"uid":userid.uid,
                               @"token":[DLTUserCenter userCenter].token,
                               @"birthday":_birthday
                               };
      [[DLT_USER_CENTER setModifyUserInfo:params]
       subscribeNext:^(id response) {
         @strongify(self);
         DLTUserProfile *userProfile = DLT_USER_CENTER.curUser.copy;
         userProfile.birthday = [self timeIntervalSince:self->_birthday] ;
         [self updateUserProfile:userProfile];
         
         [DLAlert alertWithText:@"保存成功"];
         [self backclick];
         
       } error:^(NSError * _Nullable error) {
         
       } completed:^{
         
       }];
    }
}

- (void)backclick{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row==0) {return 70;}
  else{return 54;}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   @weakify(self);
   DLTUserProfile *userProfile = DLT_USER_CENTER.curUser;
  
    if (indexPath.row==0) {
        ChagepasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:ChagepasswordCellInderifer];
        if (cell == nil) {
            cell = [[ChagepasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangephoneCellInderifer];
        }
        [cell filedata:@{@"title":@"头像"}];
       NSString *headURL = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,DLT_USER_CENTER.curUser.userHeadImg];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:headURL]
                     placeholderImage:[UIImage imageNamed:@"wallet_11"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
  
  
    else if (indexPath.row == 1){
        SingelCell * cell = [tableView dequeueReusableCellWithIdentifier:SingelCellInderifer];
        if (cell == nil) {
            cell = [[SingelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SingelCellInderifer];
        }
        [cell file:@{@"title":@"昵称"}];
        cell.singer.textColor = [UIColor colorWithHexString:@"9c9c9c"];
       cell.singer.text = ISNULLSTR(userProfile.userName)? @"未设置" : userProfile.userName;
     cell.issinger = ^{
         @strongify(self);
         SingerViewController * profile = [[SingerViewController alloc]init];
         profile.titleStr = @"昵称";
         [self.navigationController pushViewController:profile animated:YES];
     };
      
      return cell;
    }
  
    else if (indexPath.row==2){
        ChangephoneCell * cell = [tableView dequeueReusableCellWithIdentifier:ChangephoneCellInderifer];
        if (cell == nil) {
            cell = [[ChangephoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangephoneCellInderifer];
        }
        [cell filedata:@{@"title":@"性别"}];
        cell.userName.hidden = YES;
        cell.dateStr.hidden = YES;
       _sex= cell.sexStr.text = userProfile.sex?@"男":@"女";
        return cell;
    }
  
    else if (indexPath.row == 3){
        nianlianCell = [tableView dequeueReusableCellWithIdentifier:ChangephoneCellInderifer];
        if (nianlianCell == nil) {
            nianlianCell = [[ChangephoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangephoneCellInderifer];
        }
        [nianlianCell filedata:@{@"title":@"年龄"}];
        nianlianCell.sexStr.hidden = YES;
        nianlianCell.userName.hidden = YES;
        nianlianCell.dateStr.text = [userProfile.birthday userBirthdayWithTimeIntervalSince1970];
   nianlianCell.isdate = ^{
       @strongify(self);
     [self setupDateView:DateTypeOfStart];
};
    return nianlianCell;
    }
  
    else if (indexPath.row == 4){
        SingelCell * cell = [tableView dequeueReusableCellWithIdentifier:SingelCellInderifer];
        if (cell == nil) {
            cell = [[SingelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SingelCellInderifer];
        }
        [cell file:@{@"title":@"地区"}];
        cell.singer.textColor = [UIColor colorWithHexString:@"909090"];
        if (ISNULLSTR(userProfile.area)) {cell.singer.text = @"未设置";}
        else{ cell.singer.text =userProfile.area;}

      cell.issinger = ^{
        @strongify(self);
        [self addPickView];
      };
      
        return cell;
    }
  
    else if (indexPath.row==5){
        SingelCell * cell = [tableView dequeueReusableCellWithIdentifier:SingelCellInderifer];
        if (cell == nil) {
            cell = [[SingelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SingelCellInderifer];
        }
        [cell file:@{@"title":@"签名"}];
        cell.singer.textColor = [UIColor colorWithHexString:@"909090"];
        cell.singer.text = ISNULLSTR(userProfile.note)? @"未设置" : userProfile.note;
        cell.issinger = ^{
            @strongify(self);
            SingerViewController * profile = [[SingerViewController alloc]init];
            profile.titleStr = @"签名";
            [self.navigationController pushViewController:profile animated:YES];
        };
        return cell;
    }
  
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self presentAlertController];
    }
}

- (void)setupDateView:(DateType)type {
  _pikerView = [HZQDatePickerView instanceDatePickerView];
  _pikerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
  [_pikerView setBackgroundColor:[UIColor clearColor]];
  _pikerView.delegate = self;
  _pikerView.type = type;
  [_pikerView.datePickerView setMaximumDate:[NSDate date]];
  [self.view addSubview:_pikerView];
}

- (void)updateUserArea:(NSString *)area{
  DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
  NSDictionary *params = @{@"token":[DLTUserCenter userCenter].token,
                           @"uid":user.uid,
                           @"area":area};
  
  @weakify(self);
  [[DLT_USER_CENTER setModifyUserInfo:params]
   subscribeNext:^(id  _Nullable x) {
      @strongify(self);
     DLTUserProfile *userProfile = DLT_USER_CENTER.curUser.copy;
     userProfile.area = area;
      [self updateUserProfile:userProfile];
       [DLAlert alertWithText:@"修改地区成功"];
   } error:^(NSError * _Nullable error) {
     [DLAlert alertWithText:@"修改信息失败"];
   } completed:^{
     
   }];
  
}

- (void)updateUserProfile:(DLTUserProfile *)profile{
  [DLT_USER_CENTER setUserProfile:profile];
  [self.tableView reloadData];
}

- (void)addPickView{
  @weakify(self);
  _cityPickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, kScreenHeight,kScreenWidth, 256)];
  _cityPickView.address = @"浙江省-杭州市-余杭区";  //设置默认城市，弹出之后显示的是这个
  _cityPickView.backgroundColor = [UIColor whiteColor];//设置背景颜色
  _cityPickView.toolshidden = NO; //默认是显示的，如不需要，toolsHidden设置为yes
  //每次滚动结束都会返回值
  _cityPickView.confirmblock = ^(NSString *proVince,NSString *city,NSString *area){
//      @strongify(self);
//     [self dismissViewAnimation];
  };
  //点击确定按钮回调
  _cityPickView.doneBlock = ^(NSString *proVince,NSString *city,NSString *area){
      @strongify(self);
      NSString *address = [NSString stringWithFormat:@"%@-%@",proVince,city];
      [self updateUserArea:address];
      [self dismissViewAnimation];
  };
  //点击取消按钮回调
  _cityPickView.cancelblock = ^(){
     @strongify(self);
     [self dismissViewAnimation];
  };

  _pickViewBackgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [_pickViewBackgroundView addSubview:_cityPickView];
  [self.view addSubview:_pickViewBackgroundView];
  
  [self showViewAnimation];
}

- (void)showViewAnimation{
    self.tableView.scrollEnabled = NO;
  [UIView animateWithDuration:.4 animations:^{
     _pickViewBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    _cityPickView.transform =  CGAffineTransformMakeTranslation(0, -(256+64));
  } completion:^(BOOL finished) {
    
  }];
}

- (void)dismissViewAnimation {
  if (!_pickViewBackgroundView) {
    return;
  }
    self.tableView.scrollEnabled = YES;
  [UIView animateWithDuration:.35 animations:^{
    _cityPickView.transform = CGAffineTransformIdentity;
  } completion:^(BOOL finished) {
    _pickViewBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    [_pickViewBackgroundView removeFromSuperview];
  }];
}


- (void)getSelectDate:(NSString *)date type:(DateType)type {
    switch (type) {
        case DateTypeOfStart:
      {
        _birthday = date;
         nianlianCell.dateStr.text = [[self timeIntervalSince:_birthday] userBirthdayWithTimeIntervalSince1970];
      }
            break;
        default:
            break;
    }
}

- (NSString *)timeIntervalSince:(NSString *)date{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-MM-dd";
  NSDate *curDate = [formatter dateFromString:date];
  return [NSString stringWithFormat:@"%ld", (long)[curDate timeIntervalSince1970]];
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

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)didSeletCameraOrPhotoLibrary:(UIImagePickerControllerSourceType)pickerType {
  if (pickerType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
  {
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
    UIImage *newImage = [self originImage:image scaleToSize:CGSizeMake(120, 120)];
    [self dl_networkForUpdateAvatar:newImage]; // 上传头像
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


- (void)dl_networkForUpdateAvatar:(UIImage *)image{
  @weakify(self)
  [[[DLT_USER_CENTER updateUserAvatar:image]
    takeUntil:self.rac_willDeallocSignal]
   subscribeNext:^(NSString *avatarURL) {
     @strongify(self)
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       @strongify(self)
        [self.tableView reloadData];
     });
     [self refreshRCIMUserInfo];
     
     DLTUserProfile *newUser = DLT_USER_CENTER.curUser.copy;
     newUser.userHeadImg = avatarURL;
     [DLT_USER_CENTER setUserProfile:newUser];
     
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
    [self dl_networkForGroupList];
}
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
                                          DLTUserProfile *user = DLT_USER_CENTER.curUser;
                                          RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.uid name:user.userName portrait:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,user.userHeadImg]];
                                          for (DLGroupsInfo *info in modelArray) {
                                              [[RCIM sharedRCIM] refreshGroupUserInfoCache:userInfo withUserId:userInfo.userId withGroupId:info.groupId];
                                              RCGroup *group = [[RCGroup alloc]initWithGroupId:info.groupId groupName:info.groupName portraitUri:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg]];
                                              [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:info.groupId];
                                          }
                                          
                                      }
                                      
                                  } failureBlock:^(NSError *error) {
                                      
                                  } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                      
                                  }];
}

@end
