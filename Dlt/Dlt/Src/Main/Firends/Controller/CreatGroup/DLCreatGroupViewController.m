//
//  DLCreatGroupViewController.m
//  Dlt
//
//  Created by Liuquan on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLCreatGroupViewController.h"
#import "DltUICommon.h"
#import "DLUploadImage.h"


NSString * const kCreatGroupSuccessNitificationName = @"CreatGroupSuccessNitificationName";

@interface DLCreatGroupViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *detailTextField;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) UILabel *groupDetailLabel;
@end

@implementation DLCreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建群组";
    [self addleftitem];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"9c9c9c"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;

}

- (void)creatUI {
    UIImageView *photo = [[UIImageView alloc] init];
    photo.frame = CGRectMake(0, 0, 100, 100);
    photo.center = CGPointMake(self.view.frame.size.width / 2, 75 + 50 + 64);
    self.photo = photo;
    photo.image = [UIImage imageNamed:@"group_photo"];
    [self.view addSubview:photo];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 65, 100, 25);
    self.groupLabel = label;
    label.text = @"群组头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"9C9C9C"];
    [photo addSubview:label];
    
    UITextField *name = [[UITextField alloc] init];
    name.frame = CGRectMake(25, CGRectGetMaxY(photo.frame) + 40, self.view.frame.size.width - 50, 55);
    name.placeholder = @"输入群名字(最多10个字)";
    name.borderStyle = UITextBorderStyleNone;
    self.nameTextField = name;
    [name addTarget:self action:@selector(nameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:name];
    
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(25, CGRectGetMaxY(name.frame), self.view.frame.size.width - 50, 0.5);
    line1.backgroundColor = [UIColor colorWithHexString:@"9C9C9C"];
    [self.view addSubview:line1];
    
    UILabel *label1 = [[UILabel alloc] init];
    self.groupDetailLabel = label1;
    label1.frame = CGRectMake(25, CGRectGetMaxY(name.frame) + 10, self.view.frame.size.width - 50, 20);
    label1.text = @"群介绍  0/300";
    label1.textColor = [UIColor colorWithHexString:@"2c2c2c"];
    [self.view addSubview:label1];
    
    UITextField *detail = [[UITextField alloc] init];
    detail.frame = CGRectMake(25, CGRectGetMaxY(label1.frame) + 20, self.view.frame.size.width - 50, 55);
    detail.placeholder = @"请输入10-300字群介绍";
    detail.borderStyle = UITextBorderStyleNone;
    self.detailTextField = detail;
    [detail addTarget:self action:@selector(nameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:detail];
    
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(25, CGRectGetMaxY(detail.frame), self.view.frame.size.width - 50, 0.5);
    line2.backgroundColor = [UIColor colorWithHexString:@"9C9C9C"];
    [self.view addSubview:line2];
    
    photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeGroupHeadImage)];
    [photo addGestureRecognizer:tapGes];
}

- (void)nameTextFieldDidChange:(UITextField *)textField {
    if (!ISNULLSTR(self.nameTextField.text) && (self.detailTextField.text.length >= 10 && self.detailTextField.text.length < 300) && self.nameTextField.text.length <= 10) {
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"9c9c9c"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if (self.nameTextField.text.length > 10) {
        [DLAlert alertWithText:@"群名称最多10个字"];
        self.nameTextField.text = [self.nameTextField.text substringToIndex:10];
    }
    if (textField == self.detailTextField) {
        self.groupDetailLabel.text = [NSString stringWithFormat:@"群介绍 %ld/300",(long)self.detailTextField.text.length];
    }
}
- (void)rightButtonAction {
    if (self.detailTextField.text.length < 10) {
        [DLAlert alertWithText:@"群详情最少10个字"];
        return;
    }
    [self dl_networkFoyCreatGroup:self.headImgUrl];
}
#pragma mark - 网络请求
- (void)dl_networkFoyCreatGroup:(NSString *)headImgUrl {
    if (ISNULLSTR(headImgUrl)) {
        [DLAlert alertWithText:@"请选择群组头像"];
        return;
    }
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    NSString *url = [NSString stringWithFormat:@"%@Group/createGroup",BASE_URL];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                          @"token" : [DLTUserCenter userCenter].token,
                          @"uid" : user.uid,
                          @"groupName" : self.nameTextField.text,
                          @"headImg" : headImgUrl,
                          @"note" : self.detailTextField.text
                          };
    @weakify(self)
    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
        @strongify(self)
        if ([response[@"code"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kCreatGroupSuccessNitificationName object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCreatGroupSuccessNitificationName object:nil];
}

/// 头像
- (void)changeGroupHeadImage {
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
        [DLAlert alertWithText:@"该设备不支持相机"];
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
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;

    DLUploadImage *uploadP = [DLUploadImage new];
    uploadP.data = UIImagePNGRepresentation(image);
    uploadP.name = @"imgs";
    uploadP.fileName = [NSString stringWithFormat:@"head_image.png"];
    uploadP.mimeType = @"image/png";
    
    NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
    NSDictionary *params = @{
                          @"uid" : user.uid,
                          @"token" :[DLTUserCenter userCenter].token
                          };
    @weakify(self)
    [uploadP UPLOAD:url parameters:params uploadParam:uploadP success:^(id response) {
        @strongify(self)
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{ // 主线程 更新ui
                self.photo.image = image;
                self.groupLabel.hidden = YES;
                self.headImgUrl = response[@"data"][@"src"];
            });
        }else {
            [DLAlert alertWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
       
    }];
}

@end
