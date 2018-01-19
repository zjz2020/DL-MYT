//
//  DLPhotosCollectionViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


#import "DLPhotosCollectionViewController.h"
#import "RCHttpTools.h"
#import "UINavigationBar+Awesome.h"
#import "MSSBrowseNetworkViewController.h"


#define kStartTag  100

static NSString * const kPhotosItemId = @"PhotosItemId";

@interface DLPhotosItem ()


@end

@implementation DLPhotosItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = [UIImage imageNamed:@"wallet_11"];
        [self addSubview:self.imageView];
        
        self.imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDeleteImage:)];
        longPress.minimumPressDuration = 0.5;
        [self.imageView addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressDeleteImage:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSInteger tag = longPress.view.tag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(photosItem:longPressItemWithItemTag:)]) {
            [self.delegate photosItem:self longPressItemWithItemTag:tag];
        }
    }
}
@end


@interface DLPhotosCollectionViewController ()<
  UICollectionViewDelegateFlowLayout,
  UIActionSheetDelegate,
  TZImagePickerControllerDelegate,
  DLPhotosItemDelegate,
  UIAlertViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic , strong)UIImagePickerController *imagePicker;
@end

@implementation DLPhotosCollectionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.title = @"相册";
         self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView registerClass:[DLPhotosItem class] forCellWithReuseIdentifier:kPhotosItemId];
        
        UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbtn.frame = RectMake_LFL(0, 0, 20, 20);
        [rightbtn setImage:[UIImage imageNamed:@"Okami_00"] forState:UIControlStateNormal];
        [rightbtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
        self.navigationItem.rightBarButtonItem = rightitem;
        
        UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
        [backBtn setImage:[UIImage imageNamed:@"friends_15"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = leftitem;
        
        NSArray *arr = [DLTUserCenter userCenter].curUser.photoNames;
        for (NSString *str in arr) {
            [self.dataArr addObject:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,str]];
        }
        [self.collectionView reloadData];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)rightClick {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
}

- (void)backclick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self takePhotos];
    } else if (buttonIndex == 1) {
        [self addPhotos];
    }
}

// 拍照
- (void)takePhotos {

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

// 从相册选取图片
- (void)addPhotos {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO; // NO 不能选择视频
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePickerVc animated:YES completion:NULL];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [self.selectedArray addObjectsFromArray:photos];
    [self uploadGroupImage];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        @weakify(self)
        [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
            @strongify(self)
            [self.selectedArray removeAllObjects];
            [self.selectedArray addObject:image];
            [self uploadGroupImage];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
                                               NSString *imgSrcs = response[@"data"][@"src"];
                                               [temp addObject:imgSrcs];
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
            [self uploadPhotosImageUrl:imagesUrl];
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

#pragma mark - 上传相册图片
- (void)uploadPhotosImageUrl:(NSString *)url {
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid,
                             @"photos": url
                             };

    NSString *path = [NSString stringWithFormat:@"%@UserCenter/modifyUserInfo",BASE_URL];

    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:path parameters:params successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [DLAlert alertWithText:@"上传成功"];
                NSArray *arr = [response[@"data"][@"photos"] componentsSeparatedByString:@";"];
                DLTUserProfile *profie = [DLTUserCenter userCenter].curUser;
                NSArray *localImages = profie.photoNames;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:localImages];
                [temp addObjectsFromArray:arr];
                profie.photoNames = temp.mutableCopy;
                [[DLTUserCenter userCenter] setUserProfile:profie];
                [self.dataArr removeAllObjects];
                for (NSString *str in arr) {
                    [self.dataArr addObject:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,str]];
                }
                [self.collectionView reloadData];
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {return 1;}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DLPhotosItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotosItemId forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.item]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    cell.imageView.tag = indexPath.row + kStartTag;
    cell.delegate = self;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 10, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenSize.width - 60) / 3, (kScreenSize.width - 60) / 3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *browseItemArray = @[].mutableCopy;
    for(int i = 0; i < self.dataArr.count; i++) {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc] init];
        browseItem.bigImageUrl = self.dataArr[i]; // 大图url地址
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.item];
    [self.navigationController pushViewController:bvc animated:YES];
}

#pragma mark - 自定义代理
- (void)photosItem:(id)item longPressItemWithItemTag:(NSInteger)tag {
    self.imageIndex = tag - kStartTag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否删除该照片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *str = self.dataArr[self.imageIndex];
        NSString *path = [self deleteImageHostPath:str];
        [self dl_networkForDeleteSelectedPhotoWithUrl:path];
    }
}

#pragma mark - 删除图片
- (void)dl_networkForDeleteSelectedPhotoWithUrl:(NSString *)imageUrl {
    NSString *url = [NSString stringWithFormat:@"%@UserCenter/delPhotosImg",BASE_URL];
    NSDictionary *dic = @{
                          @"imgUrl" : imageUrl,
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid" : [DLTUserCenter userCenter].curUser.uid
                          };
    [BANetManager ba_request_POSTWithUrlString:url parameters:dic successBlock:^(id response) {
        if ([response[@"code"] integerValue]== 1) {
            @weakify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
               [DLAlert alertWithText:@"删除成功"];
                [self.dataArr removeObjectAtIndex:self.imageIndex];
                DLTUserProfile *profile = [DLTUserCenter userCenter].curUser;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:profile.photoNames];
                [temp removeObjectAtIndex:self.imageIndex];
                profile.photoNames = temp.mutableCopy;
                 [[DLTUserCenter userCenter] setUserProfile:profile];
                [self.collectionView reloadData];
            });
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
