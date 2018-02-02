//
//  RegisterPersonDataViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//
#import <Photos/PHPhotoLibrary.h>
#import "RegisterPersonDataViewController.h"
#import "XFDaterView.h"
#import "HcdDateTimePickerView.h"
#import "DLUploadImage.h"
#import "DLAlert.h"
#import "MainTabbarViewController.h"
#import "AppDelegate.h"
#import "ZWBucket.h"
#import "HZQDatePickerView.h"
#import "LoginViewController.h"
#define ScreenRect [UIScreen mainScreen].applicationFrame
#define ScreenRectHeight [UIScreen mainScreen].applicationFrame.size.height
#define ScreenRectWidth [UIScreen mainScreen].applicationFrame.size.width

typedef NS_ENUM(NSInteger, DLTUserGenderType){
  DLTUserGenderTypeOther  = 0,  // 其他
  DLTUserGenderTypeBoy,         // 男孩
  DLTUserGenderTypeGirl,        // 女孩
};


@interface RegisterPersonDataViewController ()<UITextFieldDelegate,XFDaterViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,HZQDatePickerViewDelegate>
{
    UIView * personDataview;
    UILabel * datepicker;
    XFDaterView*dater;
    HcdDateTimePickerView * dateTimePickerView;
    HZQDatePickerView * _picker;

    NSString * date;
    UIButton * clickBtn;
    UIButton * clickBtn1;
    UITextField * niname;
    UIButton *normalBtn;
    NSString * username;
    NSString * birthday;
    UIButton * completeBtn;
   
}
@property(nonatomic,strong)UIImageView *addImageBtn;
@property(nonatomic,strong)UIButton *backBtn;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, assign) DLTUserGenderType  userGenderType;
@property (nonatomic, strong) NSString *headImageUrl;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation RegisterPersonDataViewController
#pragma clang diagnostic pop
- (void)viewDidLoad {
    [super viewDidLoad];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
  
  _userGenderType = DLTUserGenderTypeOther;
  
    [self setup];
    // Do any additional setup after loading the view.
}
-(UIImageView *)addImageBtn
{
    if (_addImageBtn == nil) {
        _addImageBtn = [[UIImageView alloc]initWithFrame:RectMake_LFL(260/2, 130/2, 230/2, 230/2)];
        _addImageBtn.image = [UIImage imageNamed:@"Login_12"];
        _addImageBtn.layer.cornerRadius = 230/4;
        _addImageBtn.layer.masksToBounds = YES;
        _addImageBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorIcon)];
        [_addImageBtn addGestureRecognizer:tap];

    }
    return _addImageBtn;
}
- (UIAlertController *)alertController
{
    if (_alertController == nil)
    {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_alertController addAction:cancelAction];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                          {
                                              [self takePhotoActionMethod];
                                          }];
        [_alertController addAction:takePhotoAction];
        
        UIAlertAction *localPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:0 handler:^(UIAlertAction * _Nonnull action) {
            [self localPhotoActionMethod];
        }];
        [_alertController addAction:localPhotoAction];
    }
    return _alertController;
}


-(void)setup
{
    personDataview = [[UIView alloc]initWithFrame:RectMake_LFL(58/2, 0, 630/2, 385/2)];
    personDataview.top_sd = self.addImageBtn.bottom_sd + 25;
    [self.view addSubview:personDataview];
    
     niname = [[UITextField alloc]initWithFrame:RectMake_LFL(0, 0, 630/2, 55)];
    niname.delegate = self;
    niname.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    niname.placeholder = @"昵称";
    niname.font = AdaptedFontSize(17);
    [niname addTarget:self action:@selector(nicheng:) forControlEvents:UIControlEventEditingChanged];
    [personDataview addSubview:niname];
    
    UILabel * line = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 630/2, 0.5)];
    line.top_sd = niname.bottom_sd;
    line.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
    [personDataview addSubview:line];
    
    datepicker = [[UILabel alloc]initWithFrame:RectMake_LFL(line.left_sd, 0, 630/2, 55)];
    datepicker.top_sd = line.bottom_sd;
    datepicker.font = AdaptedFontSize(17);
    datepicker.userInteractionEnabled = YES;
    datepicker.text = @"出生日期";
    datepicker.textColor = [UIColor colorWithHexString:@"a1a1a1"];;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick)];
    [datepicker addGestureRecognizer:tap];

    [personDataview addSubview:datepicker];
    
    UILabel * line1 = [[UILabel alloc]initWithFrame:RectMake_LFL(niname.left_sd, 0, 630/2, 0.5)];
    line1.top_sd = datepicker.bottom_sd;
    line1.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
    [personDataview addSubview:line1];
    
    
    UILabel * man = [[UILabel alloc]initWithFrame:RectMake_LFL(line1.left_sd, 0, 24, 17)];
    man.top_sd = line1.bottom_sd + 21;
    man.text = @"男";
    man.font = AdaptedFontSize(17);
    [personDataview addSubview:man];
    
    clickBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(234/2, 0, 20, 20)];
    clickBtn.top_sd = line1.bottom_sd + 20;
    [clickBtn setImage:[UIImage imageNamed:@"Login_13"] forState:UIControlStateNormal];
    [clickBtn setImage:[UIImage imageNamed:@"Login_14"] forState:UIControlStateSelected];
    [clickBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    clickBtn.tag = DLTUserGenderTypeBoy;
    
    [personDataview addSubview:clickBtn];
    
    UILabel * line2 = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0.5, 42)];
    line2.left_sd = clickBtn.right_sd + 20;
    line2.top_sd = line1.bottom_sd + 5;
    line2.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
    [personDataview addSubview:line2];
    
    UILabel * wuman = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 34, 17)];
    wuman.left_sd = line2.right_sd + 15;
    wuman.top_sd = line1.bottom_sd +21;
    wuman.font = AdaptedFontSize(17);
    wuman.text = @"女";
    [personDataview addSubview:wuman];
    
    
     clickBtn1 = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    clickBtn1.left_sd = WIDTH -80;
    clickBtn1.top_sd = line1.bottom_sd + 20;
    [clickBtn1 setImage:[UIImage imageNamed:@"Login_13"] forState:UIControlStateNormal];
    [clickBtn1 setImage:[UIImage imageNamed:@"Login_14"] forState:UIControlStateSelected];
      [clickBtn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    clickBtn1.tag = DLTUserGenderTypeGirl;
    
    [personDataview addSubview:clickBtn1];
    
    UILabel * line3 = [[UILabel alloc]initWithFrame:RectMake_LFL(line1.left_sd, 0, 0, 0.5)];
    line3.top_sd = man.bottom_sd + 21;
    line3.width_sd = line.width_sd;
    line3.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
    [personDataview addSubview:line3];
    
    UILabel * content = [[UILabel alloc]initWithFrame:RectMake_LFL(line.left_sd, 0, 0, 17)];
    content.top_sd = line3.bottom_sd + 15;
    content.width_sd = line3.width_sd;
    content.font = AdaptedFontSize(17);
    content.textColor = [UIColor colorWithHexString:@"9c9c9c"];
    content.text = @"注册成功后,性别不可以修改";
    [personDataview addSubview:content];
    
     completeBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(58/2, 0, 0, 55)];
    completeBtn.top_sd = self.addImageBtn.bottom_sd + 516/2;
    completeBtn.width_sd = line.width_sd;
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
//    completeBtn.backgroundColor = [UIColor colorWithHexString:@"#9c9c9c"];
        completeBtn.backgroundColor = [UIColor colorWithHexString:@"0080f5"];
    completeBtn.layer.cornerRadius = 4;
    completeBtn.layer.masksToBounds = YES;
//    completeBtn.userInteractionEnabled = NO;
    [self.view addSubview:completeBtn];
    
 
    
    
    [self.view addSubview:self.addImageBtn];
    [self.view addSubview:self.backBtn];
    [_addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (260/2);
        make.top.mas_equalTo(130/2);
        make.width.height.mas_equalTo(230/2);
    }];
    
    
    
    [personDataview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(410/2);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(WIDTH-60);
        make.height.mas_equalTo(378/2);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(niname.mas_bottom).offset(0);
        make.left.mas_equalTo(niname);
        make.width.mas_equalTo(niname);
        make.height.mas_equalTo(0.5);
    }];
    
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personDataview.mas_bottom).offset(40);
        make.left.mas_equalTo(niname);
        make.width.mas_equalTo(niname);
        make.height.mas_equalTo(55);
    }];
    
    
    

}
-(UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(15, 22, 24, 24)];
        [_backBtn setImage:[UIImage imageNamed:@"Login_08"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)click:(UIButton *)btn {
    if (normalBtn != btn) {
        normalBtn.selected = NO;
        btn.selected = YES;
        normalBtn = btn;
    }
}

-(void)nicheng:(UITextField *)text
{
    username = text.text;
}
-(void)tapclick
{

    [self setupDateView:DateTypeOfStart];
}
- (void)setupDateView:(DateType)type {
    
    _picker = [HZQDatePickerView instanceDatePickerView];
    _picker.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight);
    [_picker setBackgroundColor:[UIColor clearColor]];
    _picker.delegate = self;
    _picker.type = type;
    // 今天开始往后的日期
    //    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    [_picker.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_picker];
    
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
      //  NSLog(@"%d - %@", type, date);
    
    switch (type) {
        case DateTypeOfStart:
            datepicker.text = date;
            
            break;
            
            //        case DateTypeOfEnd:
            //            _endLabel.text = [NSString stringWithFormat:@"结束日期:%@", date];
            //
            //            break;
            
        default:
            break;
    }
}
-(void)complete:(UIButton *)btn
{
    [DLAlert alertShowLoad];
  if (self.headImageUrl == nil) {
    [BAAlertView showTitle:nil message:@"请先上传您的头像."]; return;
  }
    if ([datepicker.text isEqualToString:@"出生日期"]) {
         [BAAlertView showTitle:nil message:@"请选择出生日期"]; return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = _uid;
    params[@"userName"] = username;
    params[@"sex"] = clickBtn.selected ? @"1" : @"2";
    params[@"birthday"] = datepicker.text;
    params[@"headImg"] = self.headImageUrl;
   
  [[[DLTUserCenter userCenter] setUserInfo:params]
                             subscribeNext:^(id response) {
                                 [DLAlert alertHideLoad];
                                if ([response[@"code"]integerValue]==1) {
                                    [self succssRegister];
                                }else{
                                    [DLAlert alertWithText:response[@"msg"]];
                                }
                            } error:^(NSError * _Nullable error) {
                                [DLAlert alertWithText:@"请检查网络"];
                            } completed:^{
                              
                            }];
}
-(void)succssRegister{
    NSString *password = [CLMd5Tool MD5ForLower32Bate:_pwd];
    
    [[[DLTUserCenter userCenter] login:_account
                              password:password]
     subscribeNext:^(id response) {
      
         int code = [response[@"code"] intValue];
         
         if (code == 1){ // 登录成功
             [DLAlert alertWithText:@"注册成功请登录"];
            
         }
         //注册成功
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [[AppDelegate  shareAppdelegate] logoutCompleted];
         });
        
     }
     error:^(NSError * _Nullable error) {
         
         //注册成功
        
         dispatch_async(dispatch_get_main_queue(), ^{
             [[AppDelegate  shareAppdelegate] logoutCompleted];
         });
         
         
         
     }
     
     completed:^{
         
     }];

}

- (void)takePhotoActionMethod
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)localPhotoActionMethod
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)selectorIcon
{
//            [self presentViewController:self.alertController animated:YES completion:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self)weakSelf = self;
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [weakSelf didSeletCameraOrPhotoLibrary:UIImagePickerControllerSourceTypeCamera];
        
    }];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"从相册选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [weakSelf didSeletCameraOrPhotoLibrary:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:shareAction];
    [alertController addAction:reportAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

    
    
}
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
#pragma mark --  UIImagePickerControllerDelegate
/** 拍照后 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *lastImage = [self originImage:image scaleToSize:CGSizeMake(120, 120)];
    if (lastImage) {
        @weakify(self)
        [[[NSOperationQueue alloc]init] addOperationWithBlock:^{ // 子线程上传
            @strongify(self)
            [self uploadImage:lastImage];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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

/// 上传图片单张
- (void)uploadImage:(UIImage *)image {
    DLUploadImage *uploadP = [DLUploadImage new];
    uploadP.data = UIImagePNGRepresentation(image);
    uploadP.name = @"imgs";
    uploadP.fileName = [NSString stringWithFormat:@"head_image.png"];
    uploadP.mimeType = @"image/png";
    
    NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                             @"uid" : _uid,
                             @"token" :_token
                             };
    @weakify(self);
    [uploadP UPLOAD:url parameters:params uploadParam:uploadP success:^(id response) {
        @strongify(self);
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{ // 主线程 更新ui
           _addImageBtn.image = image;
                if(response[@"data"]){
                    NSDictionary  * dic = response[@"data"];
                    if(dic){
                         self.headImageUrl = dic[@"src"];
                    }
                }
            });
        }else {
            [DLAlert alertWithText:response[@"msg"]];
        }
        if ([response[@"code"]integerValue]==-1) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
