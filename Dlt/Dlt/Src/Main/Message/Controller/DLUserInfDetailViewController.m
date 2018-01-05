//
//  DLUserInfDetailViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLUserInfDetailViewController.h"
#import "UINavigationBar+Awesome.h"
#import "DLUserInfoHeadView.h"
#import "DLUserInfoSectionView.h"
#import "ClassinfomationCell.h"
#import "DLTitleTableViewCell.h"
#import "DLSeachGroupsCell.h"
#import "DltUICommon.h"
#import "DLGroupsModel.h"
#import "CircleoffriendCell.h"
#import "DLTCircleofFriendDynamicModel.h"
#import "DLFriendsSetTableViewController.h"
#import "DLGroupDetailViewController.h"
#import "DLTAddPhotoTableViewCell.h"
#import "DLTCircleoffriendDetailViewController.h"
#import "MSSBrowseNetworkViewController.h"
#import "DLPhotosCollectionViewController.h"
#import "BaseNC.h"
#import "ConversationViewController.h"


static NSString * const kCircleoffriendCellId = @"CircleoffriendCellId";
static NSString *const kAddPhotosCellId = @"kAddPhotosCellId_identifier";
static NSString *const kClassinfomationCell = @"kClassinfomationCell_identifier";

@interface DLUserInfDetailViewController ()<
  UITableViewDelegate,
  UITableViewDataSource,
  UIScrollViewDelegate,
  DLUserInfoHeadViewDelegate,
  DLUserInfoSectionViewDelegate,
  DLTCircleoffriendCellDelegate,
  DLTCircleoffriendDetailDelegate,
  AddPhotosCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DLUserInfoSectionView *sectionView;
@property (nonatomic, strong) DLUserInfoHeadView *headView;
/// 资料/动态 YES/NO
@property (nonatomic, assign) BOOL currentIsFiles;
@property (nonatomic, strong) NSMutableArray *groupArr;
@property (nonatomic, strong) NSMutableArray *dynamicArr;
@property (nonatomic, strong) DLTUserProfile *model;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *bottomBtn;
@end

@implementation DLUserInfDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
   
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
   
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    DLUserInfoHeadView *headView = [[DLUserInfoHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 333)];
    headView.delegate = self;
    self.headView = headView;
    
    self.title = @"用户资料";
    self.currentIsFiles = YES;
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    
    DLUserInfoSectionView *sectionView = [[DLUserInfoSectionView alloc] initWithFrame:CGRectMake(0, NAVIH, self.view.frame.size.width, 48)];
    sectionView.delegate = self;
    self.sectionView = sectionView;
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.hidden = YES;
    [self.view addSubview:sectionView];
    
    [self creatUI];
    
    [self dl_networkForOtherInfomation];
    [self dl_networkForOtherGroups];
    [self dl_networkForOtherDynamic];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.bottomView).with.offset(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(-64);
        make.left.right.mas_equalTo(self.view).with.offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).with.offset(0);
    }];
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentIsFiles) {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentIsFiles) {
        if (section == 2) {
            return 1 + self.groupArr.count;
        }
        if (section == 0) {
            if (ISNULLSTR(self.model.photos)) {
                return 0;
            }
        }
        return 2;
    }
    return self.dynamicArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIsFiles) {
        switch (indexPath.section) {
            case 0: {
                if (indexPath.row == 0) {
                    DLTitleTableViewCell *cell = [DLTitleTableViewCell creatTitleCellWithTableView:tableView];
                    cell.otherTitleLabel.text = @"";
                    cell.titleLabel.text = @"相册";
                    return cell;
                }
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
              cell.userProfile = self.model;
      
              return cell;
            }
                break;
            case 1: {
                
                if (indexPath.row == 0) {
                    DLTitleTableViewCell *cell = [DLTitleTableViewCell creatTitleCellWithTableView:tableView];
                    cell.otherTitleLabel.text = @"";
                    cell.titleLabel.text = @"个人信息";
                    return cell;
                }
                ClassinfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:kClassinfomationCell];
                if (!cell) {
                    cell = [[ClassinfomationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClassinfomationCell];
                }
                cell.model = self.model;
                return cell;
            }
                break;
            default: {
                if (indexPath.row == 0) {
                    DLTitleTableViewCell *cell = [DLTitleTableViewCell creatTitleCellWithTableView:tableView];
                    cell.otherTitleLabel.text = [NSString stringWithFormat:@"(%ld)",(long)self.groupArr.count];
                    return cell;
                }
                DLSeachGroupsCell *cell = [DLSeachGroupsCell creatSeachGroupCellWithTableView:tableView];
                cell.infoModel = self.groupArr[indexPath.row - 1];
                tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                return cell;
            }
                break;
        }
    }
    CircleoffriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleoffriendCellId];
    if (!cell) {
        cell = [[CircleoffriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCircleoffriendCellId];
    }
    cell.circleFriendsDelegate = self;
    cell.indexPath = indexPath;
    cell.model = self.dynamicArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIsFiles) {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    return 40;
                }
                return (kScreenSize.width - 60) / 3 + 20;
                break;
            case 1:
                if (indexPath.row == 0) {
                    return 40;
                }
                return 75;
                break;
            default: {
                if (indexPath.row == 0) {
                    return 40;
                }
                return 70;
            }
                break;
        }
    }
    id model = self.dynamicArr[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleoffriendCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.currentIsFiles) {
        if (section != 0) {
            if (ISNULLSTR(self.model.photos)) {
                if (section == 1) {
                    return 0;
                }
            }
            return 10;
        }
        return 0;
    }
    return 0;
}

/// 点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.currentIsFiles) {
        if (indexPath.section == 2 && indexPath.row > 0) {
            DLGroupsInfo *info = self.groupArr[indexPath.row - 1];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DLGroupDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupDetailViewController"];
            vc.groupsInfo = info;
            vc.isJoined = info.isMember;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat y = scrollView.contentOffset.y;
        if (y <= 91) {
            [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:y / 91]];
             [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
             [self.navigationController.navigationBar setShadowImage:nil];
        }
        self.sectionView.hidden = y > 165 ? NO : YES;
    }
}

#pragma mark - 自定义delegate
- (void)userInfoHeadView:(DLUserInfoHeadView *)headView clickButtonWithIndex:(NSInteger)index {
   self.sectionView.filesBtn.selected = headView.filesBtn.selected = (index == 0) ? YES : NO;
   self.sectionView.dynamicBtn.selected = headView.dynamicBtn.selected = !headView.filesBtn.selected;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = headView.underLine.frame;
            rect.origin.x = index * headView.frame.size.width / 2;
            headView.underLine.frame = rect;
            
            CGRect rect1 = self.sectionView.underLine.frame;
            rect1.origin.x = index * self.sectionView.frame.size.width / 2;
            self.sectionView.underLine.frame = rect1;
        }];
    });
    self.currentIsFiles = (index == 0) ? YES : NO;
    [self.tableView reloadData];
}

- (void)userInfoSectionView:(DLUserInfoSectionView *)sectionView clickButtonWithIndex:(NSInteger)index {
    self.headView.filesBtn.selected = sectionView.filesBtn.selected = (index == 0) ? YES : NO;
    self.headView.dynamicBtn.selected = sectionView.dynamicBtn.selected = !sectionView.filesBtn.selected;
    dispatch_async(dispatch_get_main_queue(), ^{
       [UIView animateWithDuration:0.25 animations:^{
           CGRect rect = sectionView.underLine.frame;
           rect.origin.x = index * sectionView.frame.size.width / 2;
           sectionView.underLine.frame = rect;
           
           CGRect rect1 = self.headView.underLine.frame;
           rect1.origin.x = index * self.headView.frame.size.width / 2;
           self.headView.underLine.frame = rect1;
       }];
    });
    self.currentIsFiles = (index == 0) ? YES : NO;
    [self.tableView reloadData];
}
//前往好友设置
- (void)setFriendsPermissions {
    DLFriendsSetTableViewController *vc = [DLFriendsSetTableViewController new];
    vc.otherUserId = self.otherUserId;
    vc.model = self.model;
    if (_isBalckFriend) {
        vc.isBlackFriend = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)ReportUser{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认用户存在色情、暴力等违规的内容吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sureReportUser];
        
    }];
    
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}
-(void)sureReportUser{
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSString *url = [NSString stringWithFormat:@"%@/Temp/UserReport",BASE_URL];
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"beuid":_otherUserId,
                             @"content":@"用户存在色情、暴力等违规的内容"
                             };
     [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        [DLAlert alertWithText:@"工作人员将核实，并进行处理"];
    } failureBlock:^(NSError *error) {
        [DLAlert alertWithText:@"网络延迟稍后重试"];
    } progress:nil];
}
#pragma mark -
#pragma mark - DLTCircleoffriendCellDelegate

- (DLTCircleofFriendDynamicModel *)userRequestThumbup:(DLTCircleofFriendDynamicModel *)oldModel{
  DLTCircleofFriendDynamicModel *likeModel = [oldModel copy];
  
  if (oldModel.isLiked) { // 取消 liked
    
    NSMutableArray *newLikes = [likeModel.likes mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", DLT_USER_CENTER.curUser.uid];
    NSArray *predicateArr = [newLikes filteredArrayUsingPredicate:predicate];
    if (predicateArr.count) {
      DLTCircleofFriendDynamicLikeModel *zan = predicateArr.firstObject;
      if ([newLikes containsObject:zan]) {
        [newLikes removeObject:zan];
      }
    }
    
    likeModel.likes = newLikes;
  }else{
    DLTCircleofFriendDynamicLikeModel *zan = [DLTCircleofFriendDynamicLikeModel new];
    zan.uid = DLT_USER_CENTER.curUser.uid;
    zan.userName = DLT_USER_CENTER.curUser.userName;
    [likeModel.likes addObject:zan];
  }
  
  likeModel.liked = !oldModel.isLiked;
  return likeModel;
}

- (void)circleoffriendCell:(CircleoffriendCell *)cell didClickIndex:(CGFloat)index {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  DLTCircleofFriendDynamicModel *model = self.dynamicArr[indexPath.row];
  
  if (index == 10086) {
    [self dl_networkForModel:model curIndex:indexPath];
  }
  
  if (index == 10087) {
    [self pushCircleoffriendDetailViewController:model];
  }    
}

- (void)pushCircleoffriendDetailViewController:(DLTCircleofFriendDynamicModel *)model{
  DLTCircleoffriendDetailViewController *viewController = [[DLTCircleoffriendDetailViewController alloc] initWithCircleoffriendDetailViewController:model];
  viewController.delegate = self;
  [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark - DLTCircleoffriendDetailDelegate

- (void)circleoffriendDetailDelegate:(DLTCircleoffriendDetailViewController *)viewController circleofFriendModel:(DLTCircleofFriendDynamicModel *)model{
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark - AddPhotosCellDelegate

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
     // NSLog(@"%@",[NSString stringWithFormat:@"%@%@",BASE_IMGURL,photos[i]]);
    browseItem.smallImageView = imageView;// 小图
    [browseItemArray addObject:browseItem];
  }
  
  MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
  // bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
  [bvc showBrowseViewController];
}

#pragma mark - 网络请求
- (void)dl_networkForOtherInfomation {
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/otherUserInfo",BASE_URL];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSParameterAssert(self.otherUserId);
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"toId" : self.otherUserId
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        //NSLog(@"%@",response);
        @strongify(self)
        if ([response[@"code"] integerValue] == 1) {
            DLTUserProfile *model = [DLTUserProfile modelWithJSON:response[@"data"]];
            self.model = model;  
            dispatch_async(dispatch_get_main_queue(), ^{
               @strongify(self)
                self.headView.model = model;
                [self.tableView reloadData];
                if (model.isFriend) {
                    if (!_isBalckFriend) {
                        [self.bottomBtn setTitle:@"发消息" forState:UIControlStateNormal];
                    }else{
                       [self.bottomBtn setTitle:@"取消拉黑" forState:UIControlStateNormal];
                    }
                    
                }
                
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

/// 获取群
- (void)dl_networkForOtherGroups {
    NSString *url = [NSString stringWithFormat:@"%@Group/otherUserGroups",BASE_URL];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSParameterAssert(self.otherUserId);
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"toId" : self.otherUserId
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        DLGroupsModel *model = [DLGroupsModel modelWithJSON:response];
        if ([response[@"code"] integerValue] == 1) {
            [self.groupArr addObjectsFromArray:model.data];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

/// 获取动态
- (void)dl_networkForOtherDynamic {
    NSString *url = [NSString stringWithFormat:@"%@Article/otherUserArticles",BASE_URL];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSParameterAssert(self.otherUserId);
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid" : user.uid,
                             @"toId" : self.otherUserId
                             };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        if ([response[@"code"] integerValue] == 1) {
            [self.dynamicArr removeAllObjects];
            NSArray *result = response[@"data"];
            for (NSDictionary *dic in result) {
                DLTCircleofFriendDynamicModel *model = [DLTCircleofFriendDynamicModel modelWithDictionary:dic];
                [self.dynamicArr addObject:model];
            }
            [self.tableView reloadData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

#pragma mark - 私有方法
- (CGFloat)cellContentViewWith {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - 懒加载
- (NSMutableArray *)groupArr {
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr;
}

- (NSMutableArray *)dynamicArr {
    if (!_dynamicArr) {
        _dynamicArr = [NSMutableArray array];
    }
    return _dynamicArr;
}

#pragma mark -
#pragma mark - 网络请求

- (void)dl_networkForModel:(DLTCircleofFriendDynamicModel *)model curIndex:(NSIndexPath *)indexPath{
  NSString *url = [NSString stringWithFormat:@"%@Article/dianZan",BASE_URL];
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  NSDictionary *params = @{@"token" : userCenter.token,
                           @"uid"   : userCenter.curUser.uid,
                           @"articleId" : model.articleId
                           };
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         @strongify(self);
                         if ([response[@"code"] intValue] == 1) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                             @strongify(self);
                             DLTCircleofFriendDynamicModel *likeModel = [self userRequestThumbup:model];
                             [self.dynamicArr replaceObjectAtIndex:indexPath.row withObject:likeModel];
                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             [MBProgressHUD showSuccess:@"操作成功"];
                           });
                         }
                         
                         else{ [MBProgressHUD showError:@"操作失败"];}
                         
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:@"操作失败"];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
  
}

#pragma mark - ui
- (void)creatUI {
    UIView *b = [[UIView alloc] init];
    self.bottomView = b;
    b.backgroundColor = [UIColor colorWithHexString:@"444444"];
    [self.view addSubview:b];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn = btn;
    [btn setTitle:@"加为好友" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionllll) forControlEvents:UIControlEventTouchUpInside];
    [b addSubview:btn];
}
//取消拉黑
- (void)actionllll {
    if (self.model.isFriend) {
        if (!_isBalckFriend) {
            ConversationViewController *conversation = [[ConversationViewController alloc] init];
            conversation.conversationType = ConversationType_PRIVATE;
            conversation.targetId = self.otherUserId;
            conversation.hidesBottomBarWhenPushed = YES;
            conversation.title = self.model.userName;
            [self.navigationController pushViewController:conversation animated:YES];
        }else{
            
            [self cancleBlkack];
            
        }
        
    } else {
        [self dl_networkForAddNewFriendsWithFriendId:self.otherUserId];
    }
}
//取消拉黑
-(void)cancleBlkack{
    [DLAlert alertShowLoad];
    DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
    NSDictionary *dic = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid"   : user.uid,
                          @"targetId"   : self.otherUserId,
                          
                          };
    NSString *url = [NSString stringWithFormat:@"%@usercenter/cancleBlack",BASE_URL];
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
       
        if ([response[@"code"] integerValue] == 1) {
            
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [DLAlert alertWithText:[response valueForKey:@"msg"]];
                            [self.bottomBtn setTitle:@"发消息" forState:UIControlStateNormal];
                            _isBalckFriend = NO;
                            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                            [center postNotificationName:@"RELOASBLACKXELLCENTER" object:nil];

                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [DLAlert alertWithText:@"设置失败"];
                        });
        }
    } failureBlock:^(NSError *error) {
        [DLAlert alertHideLoad];
    } progress:nil];

}
/// 添加好友
- (void)dl_networkForAddNewFriendsWithFriendId:(NSString *)friendsId {
    if (ISNULLSTR(friendsId)) return;
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/addFriendRequest",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid,
                             @"fid" : friendsId
                             };
    //    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        [self showMessageWarningWithMessage:response[@"msg"]];
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@",error);
    } progress:nil];
}

// alert
- (void)showMessageWarningWithMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
