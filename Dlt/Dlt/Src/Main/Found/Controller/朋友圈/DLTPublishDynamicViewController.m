//
//  DLTPublishDynamicViewController.m
//  Dlt
//
//  Created by Gavin on 17/5/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "DLTPublishDynamicViewController.h"
#import "DLTComposeToolbar.h"
#import "DltUICommon.h"
#import "UITextView+YZEmotion.h"
#import "DLTTextView.h"

#import "DLTComposePhotosView.h"
#import "DLTAssets.h"
#import "DLTPublishDynamicVisibleAlertView.h"

typedef NS_ENUM(NSInteger, DLTPublishDynamicType){
  DLTPublishDynamicTypeText,    // 文本
  DLTPublishDynamicTypeImages,  // 照片
  DLTPublishDynamicTypeVideo    // 视频
};

@interface DLTPublishDynamicViewController () <
 DLTComposeToolbarDelegate,
 UIImagePickerControllerDelegate,
 UINavigationControllerDelegate,
 TZImagePickerControllerDelegate,
 DLTEmotionKeyboardDelegate
>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;
@property (nonatomic , weak) DLTComposeToolbar *toolbar;
@property (nonatomic , weak) DLTTextView *textView;

@property (nonatomic , weak) DLTComposePhotosView *photosView;

//是否正在切换键盘
@property (nonatomic ,assign, getter=isChangingKeyboard) BOOL ChangingKeyboard;

@property (nonatomic , strong) NSMutableArray *selectedArray;

@property (nonatomic , assign) DLTPublishDynamicType  publishType;

@property (nonatomic , copy) NSString  *tempStr;

@end

@implementation DLTPublishDynamicViewController {
  RACCompoundDisposable *_disposable;
}

- (void)dealloc
{
  
}

- (NSString *)tempStr{
  if (!_tempStr) {
    _tempStr = [[NSString alloc] init];
  }
  return _tempStr;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (UIImagePickerController *)imagePickerVc {
  if (_imagePickerVc == nil) {
    _imagePickerVc = [[UIImagePickerController alloc] init];
    _imagePickerVc.delegate = self;
    // set appearance / 改变相册选择页的导航栏外观
    _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    UIBarButtonItem *tzBarItem, *BarItem;
    if (iOS9Later) {
      tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
      BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
    } else {
      tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
      BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
    }
    NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
    [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
  }
  return _imagePickerVc;
}

// 懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard{
  // 创建表情键盘
  if (_emotionKeyboard == nil) {
    
    YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
    emotionKeyboard.delegate = self;
    _emotionKeyboard = emotionKeyboard;
  }
  return _emotionKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _disposable = [RACCompoundDisposable compoundDisposable];
  _selectedArray = @[].mutableCopy;
  
  [self setupNavigationItem];
  [self setupTextView];
  [self setupPhotosView];
  [self setupToolbar];
  
    @weakify(self);
  [[self.textView rac_textSignal] subscribeNext:^(NSString *text) {
    @strongify(self);
     self.navigationItem.rightBarButtonItem.enabled = (text.length > 0);
  }];
  

  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_textView becomeFirstResponder];
  });
  
}

- (void)back:(NSString *)image{
  UIButton * backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 0, 25, 25)];
  [backBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
  [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
  self.navigationItem.leftBarButtonItem = leftitem;
}

- (void)setupNavigationItem {
  [self back:@"friends_15"];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self action:@selector(send)];
  self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setupTextView {
  DLTTextView *textView = [[DLTTextView alloc] initWithFrame:(CGRect){CGPointZero,self.view.width, 200}];
  textView.alwaysBounceVertical = YES ;
  textView.mainView = self;
  textView.backgroundColor = [UIColor whiteColor];
  textView.placeholder = @"分享你的新鲜事吧";
  textView.placeholderColor = rgb(156, 156, 156);
  textView.font = [UIFont systemFontOfSize:16];
  [self.view addSubview:textView];
  
  self.emotionKeyboard.textView = textView;
  textView.inputView = nil; // 切换到系统键盘
  [textView reloadInputViews];
  
  self.textView = textView;
  
  [textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(200);
    make.top.and.left.and.right.equalTo(self.view);
  }];

  
  @weakify(self);
  [_disposable addDisposable: [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification
                                                                                     object:nil]
                               subscribeNext:^(NSNotification *notification) {
                                 @strongify(self);
                                 [self keyboardWillShow:notification];
    
  }]];
  
  [_disposable addDisposable: [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification
                                                                                     object:nil]
                               subscribeNext:^(NSNotification *notification) {
                                 @strongify(self);
                                 [self keyboardWillHide:notification];
  }]];
  
}

// 添加工具条
- (void)setupToolbar {
  DLTComposeToolbar *toolbar = [[DLTComposeToolbar alloc] init];
  toolbar.width = self.view.width;
  toolbar.height = 44;
  toolbar.delegate = self;
  self.toolbar = toolbar;
  self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height, WIDTH, 44);
  toolbar.y = self.view.height - toolbar.height;
  [self.view addSubview: self.toolbar];
}

// 添加显示图片的相册控件
- (void)setupPhotosView{
  DLTComposePhotosView *photosView = [[DLTComposePhotosView alloc] init];
  [photosView.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  
  photosView.addButton.hidden = YES;
  [self.view addSubview:photosView];
   self.photosView = photosView;
  
  [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(200);
    make.left.and.right.equalTo(self.view);
    make.top.equalTo(_textView.mas_bottom);
  }];
  
}

- (void)send {
  [self.emotionKeyboard requestSendMessageContent];
}


- (void)backclick{
  [self->_textView resignFirstResponder];
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出此次编辑?"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleAlert];
  [self presentViewController:alertController animated:YES completion:nil];

  [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {}]];
  
  @weakify(self);
  [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                      @strongify(self);
                                                      [self.navigationController dismissViewControllerAnimated:YES
                                                                                                    completion:NULL];
  }]];

}

#pragma mark
#pragma mark - DLTComposeToolbarDelegate

- (void)addButtonClicked{
  [self openAlbum:0];
}

- (void)composeTool:(DLTComposeToolbar *)toolbar didClickedButton:(DLTComposeToolbarButtonType)buttonType{  
  switch (buttonType) {
    case DLTComposeToolbarButtonTypeCamera: // 照相机
    {      
      // 不能再选择照片的情况下选择视频
      if (self.photosView.isContainPhotoType) {[MBProgressHUD showError:@"选择照片时,不能选择视频"];}
      else{
        if (self.photosView.selecteds < 2 && self.photosView.selecteds > 0 ) {
          [MBProgressHUD showError:@"您每次只能选择一个视频上传"]; return;
        }
        [self openCamera];
      }
    }
     
      break;
      
    case DLTComposeToolbarButtonTypePicture: // 相册
      [self openAlbum:0];
      break;
      
    case DLTComposeToolbarButtonTypeEmotion: // 表情
      [self openEmotion];
      break;
    case DLTComposeToolbarButtonTypeVisible: // 是否可见()公开
      [self openVisibleAlertView];
      break;
    default:
      break;
  }
}


/**
 *  打开照相机
 */
- (void)openCamera{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate: nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"去手机相册选择", nil];
  [sheet showInView:self.view];
  
  @weakify(self);
  [[sheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
    @strongify(self);
    CGFloat buttonIndex = [index integerValue];
    if (buttonIndex == 0) { // 拍摄视频
        [self pushWechatShortVideoController];
    }
    
    if (buttonIndex == 1) {
      [self openAlbum:1];
    }
  }];
  
  
}

#pragma mark - UIImagePickerController

- (void)pushWechatShortVideoController{
//  WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
//  wechatShortVideoController.delegate = self;
//  [self.navigationController presentViewController:wechatShortVideoController animated:YES completion:NULL];
  
  if (![self isVideoRecordingAvailable]) {
    return;
  }
  
  UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
  if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    self.imagePickerVc.sourceType = sourceType;
    self.imagePickerVc.mediaTypes = @[(NSString *)kUTTypeMovie];
    self.imagePickerVc.videoMaximumDuration = 10;
    
    //      if(iOS8Later) {
    //        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //      }
    
    [self presentViewController:_imagePickerVc animated:YES completion:nil];
  } else {
    NSLog(@"模拟器中无法打开照相机,请在真机中使用");
  }
  
}



- (void)takePhoto{
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
  if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
    // 无相机权限 做一个友好的提示
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    [alert show];
    // 拍照之前还需要检查相册权限
  } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    alert.tag = 1;
    [alert show];
  } else if ([TZImageManager authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      return [self takePhoto];
    });
  } else{ // 调用相机

  }
}

#pragma mark - Private methods

- (BOOL)isVideoRecordingAvailable{
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
      return YES;
    }
  }
  return NO;
}


/**
 *  打开相册
 */
- (void)openAlbum:(NSUInteger)type{
  if (self.photosView.isContainVideoType) {[MBProgressHUD showError:@"选择视频时,不能选择照片"]; return;}
  
  NSInteger maxCount = (type == 1)? 1: 9 - _selectedArray.count;
  
  TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
  if (type == 0) { //选择照片
    imagePickerVc.allowPickingVideo = NO; // NO 不能选择视频
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.sortAscendingByModificationDate = NO;
  }
  
  if (type == 1) { //选择视频
  imagePickerVc.allowPickingVideo = YES;
  imagePickerVc.allowPickingImage = NO; // 如果设置为NO,用户将不能选择发送图片
  imagePickerVc.allowTakePicture = NO;
  }
  
  imagePickerVc.allowPickingOriginalPhoto = NO;
  [self presentViewController:imagePickerVc animated:YES completion:NULL];
}

/**
 *  打开表情
 */
- (void)openEmotion{

  // 正在切换键盘
  self.ChangingKeyboard = YES;
  if (self.textView.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
    // 显示表情图片
    self.toolbar.showEmotionButton = YES;
  } else { // 当前显示的是系统自带的键盘，切换为自定义键盘
    // 如果临时更换了文本框的键盘，一定要重新打开键盘
    self.textView.yz_emotionKeyboard = self.emotionKeyboard;
    
    // 不显示表情图片
    self.toolbar.showEmotionButton = NO;
  }
  
  // 关闭键盘
  [self.textView resignFirstResponder];
  // 关闭键盘只后，changKeyboard 为no
  self.ChangingKeyboard = NO;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // 打开键盘
    [self.textView becomeFirstResponder];
  });
  
}

/**
 *
 */
- (void)openVisibleAlertView{
  [_textView resignFirstResponder];
  DLTPublishDynamicVisibleAlertView *alert = [DLTPublishDynamicVisibleAlertView new];
  @weakify(self);
  [alert pop:self.toolbar.isVisibleType visibleChange:^(DLTPublishDynamicVisibleType type) {
    @strongify(self);
    self.toolbar.visibleType = type;
  }];
}

#pragma mark -
#pragma mark - TZImagePickerControllerDelegate

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的handle
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

  NSMutableArray *temp = [NSMutableArray new];
  [photos enumerateObjectsUsingBlock:^(UIImage *coverImage, NSUInteger idx, BOOL * _Nonnull stop) {
    DLTAssets *model = [[DLTAssets alloc] initAssetWithMediaType:DLTAssetModelMediaTypePhoto];
    model.thumbnail = coverImage;
    model.originalPhoto = coverImage;
    [temp addObject:model];
  }];
  
  [self addPhotosViewData:temp.copy];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
  
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
  @weakify(self);
  [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    @strongify(self)
    DLTAssets *assets = [[DLTAssets alloc] initAssetWithMediaType:DLTAssetModelMediaTypeVideo];
    assets.thumbnail = coverImage;
    assets.videoURL = [NSURL URLWithString:outputPath];

    [self addPhotosViewData:@[assets]];
  }];

}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset{
  
}

- (void)addPhotosViewData:(NSArray <DLTAssets *>*)assets { // mediaType:(DLTAssetModelMediaType)type
  // 记录选中的DLTAssets
  [_selectedArray addObjectsFromArray:assets];
  
  self.photosView.assetsArray = [NSMutableArray arrayWithArray:_selectedArray];
  [self.photosView reloadPhotosView];
}


#pragma mark -
#pragma mark - WechatShortVideoDelegate

- (void)finishWechatShortVideoCapture:(NSURL *)filePath {
  NSLog(@"filePath is %@", filePath); 
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
  AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
 
  UIImage *thumbnail =  [[TZImageManager manager] getThumbnailImage:videoURL];
  @weakify(self);
  [[TZImageManager manager] startExportVideoWithVideoAsset:videoAsset completion:^(NSString *outputPath) {
       NSLog(@"outputPath %@", outputPath);
    @strongify(self)
    DLTAssets *assets = [[DLTAssets alloc] initAssetWithMediaType:DLTAssetModelMediaTypeVideo];
    assets.thumbnail = thumbnail;
    assets.videoURL = [NSURL URLWithString:outputPath];

   [self addPhotosViewData:@[assets]];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - 键盘处理
/**
 *  键盘即将隐藏：工具条（toolbar）随着键盘移动
 */
- (void)keyboardWillHide:(NSNotification *)note
{
  //需要判断是否自定义切换的键盘
  if (self.isChangingKeyboard) {
    self.ChangingKeyboard = NO;
    return;
  }
  
  // 1.键盘弹出需要的时间
  CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  // 2.动画
  [UIView animateWithDuration:duration animations:^{
     self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height , WIDTH, 44);
  }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note{
  // 1.键盘弹出需要的时间
  CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  // 2.动画
  [UIView animateWithDuration:duration animations:^{
    // 取出键盘高度
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
      self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - keyboardH - 44, WIDTH, 44);
  }];
}


#pragma mark -
#pragma mark - touchesBegan

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
}


#pragma mark -
#pragma mark - DLTEmotionKeyboardDelegate


- (void)emotionKeyboard:(YZEmotionKeyboard *)keyboard didClickedSendEmotionDescribeMessages:(NSString *)content{
//    NSLog(@"didClickedSendEmotionLocationNameMessages: %@",content);
   [_textView resignFirstResponder];
  
  // 发布朋友圈
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  hud.mode = MBProgressHUDModeDeterminate;
  hud.labelText =  @"发朋友圈中...";

  _publishType = DLTPublishDynamicTypeText;
  
  if (self.photosView.selecteds > 0) {
    _publishType = [self.photosView isContainVideoType]? DLTPublishDynamicTypeVideo :DLTPublishDynamicTypeImages;
  }
  
  // 如果上传的是图片
  if (_publishType == DLTPublishDynamicTypeImages) {
    [self dl_networkForUploadFileType:DLTPublishDynamicTypeImages
                             withText:content];
  }

  // 如果上传的是视频
  if (_publishType == DLTPublishDynamicTypeVideo) {
    #warning 暂时没支持视频上传, 所以先上传视频的缩略图
    [self dl_networkForUploadFileType:DLTPublishDynamicTypeVideo
                             withText:content];
  }
  
  // 如果上传的纯文本
  if (_publishType == DLTPublishDynamicTypeText) {
    [self dl_networkForPublishDynamicText:content imgSrcs:nil];
  }
  
}


/**
 发布上传动态公共 .

 @param dynamic 是否发布成功
 */
- (void)publishedDynamic:(BOOL)dynamic{
  if (dynamic) {
    [_textView resetTextView];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(publishDynamicViewController:didPublishDynamicMessages:publishedDynamic:)]) {
    [self.delegate publishDynamicViewController:self didPublishDynamicMessages:nil publishedDynamic:dynamic];
  }
}

#pragma mark -
#pragma mark - 网络请求

// 发布朋友圈
- (void)dl_networkForPublishDynamicText:(NSString *)text imgSrcs:(NSString *)imgSrcs{
  NSString *url = [NSString stringWithFormat:@"%@Article/addArticle",BASE_URL];
//  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

  NSMutableDictionary *params = @{
                           @"token" : [DLTUserCenter userCenter].token,
                           @"uid"   : user.uid,
                           @"text"  : text
                           }.mutableCopy;
  if (imgSrcs.length > 0) {
    [params setObject:imgSrcs forKey:@"imgSrcs"];
  }
 
    NSLog(@"*****params: %@",params);
  
  MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         @strongify(self);
                         [hud hide:YES];
                         [self publishedDynamic:YES];
                         
                    } failureBlock:^(NSError *error) {
                      [hud hide:YES];
                      [MBProgressHUD showError:error.localizedDescription];
                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                        
                      }];

}

static bool isFailur;
- (void)dl_networkForUploadFileType:(DLTPublishDynamicType)type  withText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
  
  self->_tempStr = nil;
  isFailur = NO;
  
   dispatch_group_t batch_api_group = dispatch_group_create();
  
  @weakify(self)
  [self.photosView.selectedPhotos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     dispatch_group_enter(batch_api_group);
    @strongify(self);
    [self dl_networkForUploadFileWithImageArray:@[obj]
                                   successBlock:^(id response) {
                                      @strongify(self);
                                     if ([response[@"code"] intValue] == 1){ // code  == 1 代表成功
                                       NSString *imgSrcs = response[@"data"][@"src"];
                                       self.tempStr = [self.tempStr stringByAppendingString:[NSString stringWithFormat:@"%@;",imgSrcs]];
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
      //处理
      NSString *strUrl = [self.tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
      NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:strUrl];
      NSString *newStr = [mutableStr substringToIndex:mutableStr.length -1];
      NSLog(@"newStr: %@",newStr);
      
       [self dl_networkForPublishDynamicText:text imgSrcs:newStr];
      NSArray *componets = [newStr componentsSeparatedByString:@";"];
      NSLog(@"componets componets: %@",componets);
    }
    else{
      [hud hide:YES];
      [MBProgressHUD showError:@"发朋友圈出错了,请重试!"];
    }
  });
}

// 上传图片
- (BAURLSessionTask *)dl_networkForUploadFileWithImageArray:(NSArray *)images successBlock:(void(^)(id response))success failurBlock:(void(^)(NSError *error))failur{
  NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
//  NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

  NSDictionary *params = @{
                           @"token" : [DLTUserCenter userCenter].token,
                           @"uid"   : user.uid,
                           @"isOriginal": @"1"
                           };
  return [BANetManager ba_uploadImageWithUrlString:url
                                        parameters:params
                                        imageArray:images
                                          fileName:@""
                                      successBlock:success
                                       failurBlock:failur
                                    upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                      
                                      }];
}



@end
