//
//  DLEditpromotionViewController.m
//  Dlt
//
//  Created by USER on 2017/9/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLEditpromotionViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "SDPhotoBrowser.h"
#import "SuPhotoPicker.h"
#import "DLCostViewController.h"
#import "TKImageView.h"
#import "ActionSheetCustomPicker.h"
#import <MJExtension/MJExtension.h>
@interface DLEditpromotionViewController ()<UITextViewDelegate,SDPhotoBrowserDelegate,ActionSheetCustomPickerDelegate>
@property (nonatomic , strong)UIScrollView *mainView;
@property (nonatomic , strong)UITextField *titleField;


@property (nonatomic , strong)UIView *topView;
@property (nonatomic , strong)UIView *midView;
@property (nonatomic , strong)UIView *downView;

@property (nonatomic , strong)UITextView *topTextView;
@property (nonatomic , strong)UITextView *midTextView;
@property (nonatomic , strong)UITextView *downTextView;

@property (nonatomic , strong)UIView *topImageView;
@property (nonatomic , strong)UIView *midImageView;
@property (nonatomic , strong)UIView *downImageView;

@property (nonatomic , strong)NSMutableArray *topPhotos;
@property (nonatomic , strong)NSMutableArray *midPhotos;
@property (nonatomic , strong)NSMutableArray *downPhotos;

@property (nonatomic , strong)NSString *topPhotosStr;
@property (nonatomic , strong)NSString *midPhotosStr;
@property (nonatomic , strong)NSString *downPhotosStr;

@property (nonatomic , strong)UILabel *topLabel;
@property (nonatomic , strong)UILabel *midLabel;
@property (nonatomic , strong)UILabel *downLabel;

@property (nonatomic , strong)TKImageView *tkImageView;
@property (nonatomic , strong)UIView *tkImageMainView;
@property (nonatomic , strong)NSString *lastTkStr;
@property (nonatomic , strong)UIButton *coverBtn;
@property (nonatomic , strong)UIButton *cityCodeBtn;

@property (nonatomic,strong) NSArray *addressArr;
@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *countryArr;
@property (nonatomic,assign) NSInteger index1;
@property (nonatomic,assign) NSInteger index2;
@property (nonatomic , strong)NSString *cityCodeStr;
@property (nonatomic,strong) ActionSheetCustomPicker *picker;
@end

@implementation DLEditpromotionViewController
-(NSMutableArray *)topPhotos{
    if (_topPhotos == nil) {
        _topPhotos = [NSMutableArray array];
        
    }return _topPhotos;
}
-(NSMutableArray *)midPhotos{
    if (_midPhotos == nil) {
        _midPhotos = [NSMutableArray array];
    }return _midPhotos;
}
-(NSMutableArray *)downPhotos{
    if (_downPhotos == nil) {
        _downPhotos = [NSMutableArray array];
    }return _downPhotos;
}
-(UIButton *)coverBtn{
    if (_coverBtn == nil) {
        _coverBtn= [UIButton buttonWithType:UIButtonTypeSystem];
    }return _coverBtn;
}
- (NSArray *)provinceArr
{
    if (_provinceArr == nil) {
        _provinceArr = [[NSArray alloc] init];
    }
    return _provinceArr;
}
-(NSArray *)countryArr
{
    if(_countryArr == nil)
    {
        _countryArr = [[NSArray alloc] init];
    }
    return _countryArr;
}



-(NSArray *)addressArr
{
    if (_addressArr == nil) {
        _addressArr = [[NSArray alloc] init];
    }
    return _addressArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cityCodeStr = @"100000";
    self.view.backgroundColor = [UIColor whiteColor];
    if (_islink) {
         self.navigationItem.title = @"链接推广";
    }else{
         self.navigationItem.title = @"图文推广";
    }
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addMainScrollView];
    [self calculateFirstData];
}

-(void)addMainScrollView{
    _mainView = [UIScrollView new];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .topSpaceToView(self.view, NAVIH)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    UIView *topView = [UIView new];
    [self addImageTextView:topView row:0];
    UIView *line = [UIView new];
    line.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    _cityCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cityCodeBtn setTintColor:[UIColor blackColor]];
    _cityCodeBtn.layer.borderColor = [UICOLORRGB(232, 232, 232, 1.0) CGColor];
    _cityCodeBtn.layer.borderWidth = 2.0f;
    _cityCodeBtn.layer.cornerRadius = 4.0f;
    _cityCodeBtn.layer.masksToBounds = YES;
    [_cityCodeBtn setTitle:@"推广地区（默认全国）" forState:0];
    _cityCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _cityCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cityCodeBtn addTarget:self action:@selector(upCityCodeButton) forControlEvents:UIControlEventTouchUpInside];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.backgroundColor = DLBLUECOLOR;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 10;
    [nextBtn setTintColor:[UIColor whiteColor]];
    if (_islink) {
        [nextBtn setTitle:@"完成" forState:0];
    }else{
       [nextBtn setTitle:@"下一步" forState:0];
    }
    
    [nextBtn addTarget:self action:@selector(upNextButton) forControlEvents:UIControlEventTouchUpInside];
    if (_islink) {
        _titleField = [UITextField new];
        _titleField.placeholder = @"标题";
        UIColor *color = [UIColor grayColor];
        _titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_titleField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _titleField.font = [UIFont systemFontOfSize:17];
        
        
        UIView *middleView = [UIView new];
        [self addImageTextView:middleView row:1];
        UIView *downView = [UIView new];
        [self addImageTextView:downView row:2];
        
        [_mainView sd_addSubviews:@[_titleField,line,topView,middleView,downView,_cityCodeBtn, nextBtn] ];
        _titleField.sd_layout
        .topSpaceToView(_mainView, 0)
        .leftSpaceToView(_mainView, 15)
        .rightSpaceToView(_mainView, 15)
        .heightIs(54);
        line.sd_layout
        .topSpaceToView(_titleField, 0)
        .heightIs(1)
        .leftSpaceToView(_mainView, 0)
        .rightSpaceToView(_mainView, 0);
        topView.sd_layout
        .topSpaceToView(line, 0)
        .leftSpaceToView(_mainView, 0)
        .rightSpaceToView(_mainView, 0);
        middleView.sd_layout
        .topSpaceToView(topView, 0)
        .leftSpaceToView(_mainView, 0)
        .rightSpaceToView(_mainView, 0);
        downView.sd_layout
        .topSpaceToView(middleView, 0)
        .leftSpaceToView(_mainView, 0)
        .rightSpaceToView(_mainView, 0);
        _cityCodeBtn.sd_layout
        .topSpaceToView(downView, 20)
        .leftSpaceToView(_mainView, 10);
        [_cityCodeBtn setupAutoSizeWithHorizontalPadding:10 buttonHeight:38];
        nextBtn.sd_layout
        .topSpaceToView(_cityCodeBtn, 10)
        .centerXEqualToView(_mainView)
        .heightIs(45)
        .widthIs(315);
        [_mainView setupAutoContentSizeWithBottomView:nextBtn bottomMargin:20];
    }else{
        [_mainView sd_addSubviews:@[topView,line,_cityCodeBtn, nextBtn]];
        topView.sd_layout
        .topSpaceToView(_mainView, 0)
        .leftSpaceToView(_mainView, 0)
        .rightSpaceToView(_mainView, 0)
        .heightIs(165);
        line.sd_layout
        .topSpaceToView(topView, 25)
        .leftSpaceToView(_mainView, 0)
        .rightSpaceToView(_mainView, 0)
        .heightIs(1);
        _cityCodeBtn.sd_layout
        .topSpaceToView(line, 20)
        .leftSpaceToView(_mainView, 10);
         [_cityCodeBtn setupAutoSizeWithHorizontalPadding:10 buttonHeight:38];
        nextBtn.sd_layout
        .topSpaceToView(_cityCodeBtn, 10)
        .centerXEqualToView(_mainView)
        .heightIs(45)
        .widthIs(315);
        [_mainView setupAutoContentSizeWithBottomView:nextBtn bottomMargin:20];    }
    
}
-(void)upCityCodeButton{
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2)]];
    self.picker.tapDismissAction  = TapActionSuccess;
    // 可以自定义左边和右边的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"确认" forState:UIControlStateNormal];
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    
    [self.picker showActionSheetPicker];}
-(void)addImageTextView:(UIView *)view row:(int)row{
    UITextView *textView = [UITextView new];
    textView.delegate = self;
    if (_islink) {
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = UICOLORRGB(232, 232, 232, 1.0).CGColor;
    }
    
    textView.font = [UIFont systemFontOfSize:17];

    UILabel *  label = [[UILabel alloc]initWithFrame:CGRectMake(7 , 7, self.view.bounds.size.width-10, 21)];
    label.text = @"描述你的广告词";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor grayColor];
    label.enabled = NO;//lable必须设置为不可用
    [textView addSubview:label];


    if (row == 0) {
        _topImageView = [UIView new];
        _topLabel = label;
        _topView = view;
        _topTextView = textView;
        
    }else if (row == 1){
        _midImageView = [UIView new];
        _midView = view;
        _midLabel = label;
        _midTextView = textView;
        
    }else{
        _downImageView = [UIView new];
        _downView = view;
        _downLabel = label;
        _downTextView = textView;
       
    }
   [self  upPhotos:nil row:row];
    
   
    
}
//实现UITextView的代理
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView isEqual:_topTextView]) {
        if (textView.text.length == 0) {
            
            _topLabel.text = @"描述你的广告词内容";
        }else{
            _topLabel.text = @"";
            
        }

    }else if ([textView isEqual:_midTextView]){
        if (textView.text.length == 0) {
            
            _midLabel.text = @"描述你的广告词内容";
        }else{
            _midLabel.text = @"";
            
        }
    }else{
        if (textView.text.length == 0) {
            
            _downLabel.text = @"描述你的广告词内容";
        }else{
            _downLabel.text = @"";
            
        }
    }
    
}

-(void)upImageButton:(UIButton *)btn{
   
    __weak typeof(self) weakSelf = self;
    [_topTextView resignFirstResponder];
    if (_islink) {
        [_midTextView resignFirstResponder];
        [_downTextView resignFirstResponder];
    }
    SuPhotoPicker *picker = [[SuPhotoPicker alloc]init];
    
    picker.selectedCount = 5;
    
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
        [DLAlert alertShowLoad];
       
        if (btn.tag == 100) {

        [weakSelf.topPhotos addObjectsFromArray:photos];
        [weakSelf httpImageNameData:0];

        }else if (btn.tag == 101){

            [weakSelf.midPhotos addObjectsFromArray:photos];
            [weakSelf httpImageNameData:1];

        }else{

            [weakSelf.downPhotos addObjectsFromArray:photos];
            [weakSelf httpImageNameData:2];

        }
           }];
}
-(void)upPhotos:(NSArray *)imgs row:(int)row{
    //图片长度值
    CGFloat length = (WIDTH - 50)/4;
    // 保存前一个button的宽以及前一个button距离屏幕边缘的距
     CGFloat edge =0;
    if (row == 0) {
        edge =length + 10;
    }
   
    //设置button 距离父视图的高
    CGFloat h =10;

    UIView *imageView = [UIView new];
    //添加封面
    if (row == 0) {
        if (self.coverBtn.tag == 10086) {
            [self.coverBtn setBackgroundImage:[_tkImageView currentCroppedImage] forState:UIControlStateNormal];
        }else{
           [self.coverBtn setBackgroundImage:[UIImage imageNamed:@"fengmianadd.png"] forState:UIControlStateNormal];
        }
       
        [_coverBtn addTarget:self action:@selector(upCoverBtnButton) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:_coverBtn];
        _coverBtn.frame =CGRectMake(10,h , length  , length );
    }
    
    
    // 添加图片按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.tag = row +100;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"applyadd.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(upImageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (imgs.count > 4) {
        addBtn.hidden = YES;
    }else{
        addBtn.hidden = NO;
    }
   
    for (int i =0; i< imgs.count; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeSystem];
        if (row == 0) {
            button.tag =10+i;
        }else if (row == 1){
            button.tag =100+i;
        }else{
            button.tag =1000+i;
        }
        button.backgroundColor =[UIColor whiteColor];
        [button addTarget:self action:@selector(upButtonSeeImage:) forControlEvents:(UIControlEventTouchUpInside)];
        UIImage *buttonimage = imgs[i];
        buttonimage = [buttonimage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [button.imageView  setContentMode:UIViewContentModeScaleAspectFill];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentFill;
        
        button.contentVerticalAlignment=UIControlContentVerticalAlignmentFill;
        
        [button setImage:buttonimage forState:UIControlStateNormal];
        CGFloat deleH = 20;
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        deleBtn.frame = CGRectMake(0, 0, deleH, deleH);
        UIImage *deleImage = [UIImage imageNamed:@"salary2_03.png"];
        deleImage = [deleImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [deleBtn.imageView  setContentMode:UIViewContentModeScaleAspectFill];
        deleBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentFill;
        deleBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentFill;
       
        if (row == 0) {
             deleBtn.tag = 10 + i;
        }else if (row == 1){
             deleBtn.tag = 100 + i;
        }else{
             deleBtn.tag = 1000 + i;
        }
        [deleBtn addTarget:self action:@selector(selectClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [deleBtn setImage:deleImage forState:UIControlStateNormal];
        [button addSubview:deleBtn];
        
        //设置button的frame
            button.frame =CGRectMake(edge+10, h, length, length);
       
        
        
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if (edge+length >self.view.bounds.size.width) {
            //换行时将左边距设置为10
            edge =0;
            //距离父视图的高度变化
            h=h+button.frame.size.height +10;
            //标签换行后的frame
            button.frame =CGRectMake(edge+10, h, length, length);
        }
        //获取前一个button的尾部位置位置
        edge = button.frame.size.width +button.frame.origin.x;
        
        [imageView addSubview:button];
        
        if (i == imgs.count - 1) {
            if (edge+length >self.view.bounds.size.width) {
                //换行时将左边距设置为10
                edge =0;
                //距离父视图的高度变化
                h=h+button.frame.size.height +10;
                //标签换行后的frame
            }
             addBtn.frame =CGRectMake(edge+10, h, length, length);
        }
        
    }
    
    if (imgs == nil) {
        if (row == 0) {
            addBtn.frame =CGRectMake(edge+10,h , length  , length );
        }else{
            addBtn.frame =CGRectMake(10,h , length  , length );
        }
        
    }
    [imageView addSubview:addBtn];
  [imageView setupAutoHeightWithBottomView:addBtn bottomMargin:0];
    CGFloat left = 10;
    if (row == 0) {
        _topImageView = imageView;
        [_topView sd_addSubviews:@[_topTextView,_topImageView]];
        _topTextView.sd_layout
        .topSpaceToView(_topView, 15)
        .leftSpaceToView(_topView, left)
        .heightIs(90)
        .rightSpaceToView(_topView, left);
        _topImageView.sd_layout
        .topSpaceToView(_topTextView, 20)
        .leftSpaceToView(_topView, 0)
        .rightSpaceToView(_topView, 0)
        .heightIs(90);
        [_topView setupAutoHeightWithBottomView:_topImageView bottomMargin:0];
        
    }else if (row == 1){
        _midImageView = imageView;
        [_midView sd_addSubviews:@[_midTextView,_midImageView]];
        _midTextView.sd_layout
        .topSpaceToView(_midView, 15)
        .leftSpaceToView(_midView, left)
        .heightIs(90)
        .rightSpaceToView(_midView, left);
        _midImageView.sd_layout
        .topSpaceToView(_midTextView, 20)
        .leftSpaceToView(_midView, 0)
        .rightSpaceToView(_midView, 0)
        .heightIs(90);
        [_midView setupAutoHeightWithBottomView:_midImageView bottomMargin:0];
        
    }else{
        
        _downImageView = imageView;
        [_downView sd_addSubviews:@[_downTextView,_downImageView]];
        _downTextView.sd_layout
        .topSpaceToView(_downView, 15)
        .leftSpaceToView(_downView, left)
        .heightIs(90)
        .rightSpaceToView(_downView, left);
        _downImageView.sd_layout
        .topSpaceToView(_downTextView, 20)
        .leftSpaceToView(_downView, 0)
        .rightSpaceToView(_downView, 0)
        .heightIs(90);
        [_downView setupAutoHeightWithBottomView:_downImageView bottomMargin:0];
    }
    
}
//点击了封面图片
-(void)upCoverBtnButton{
    [_topTextView resignFirstResponder];
    SuPhotoPicker *picker = [[SuPhotoPicker alloc]init];
    
    picker.selectedCount = 1;
    
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self addTkImageMianView:photos[0]];
         });

        
       
    }];

}
-(void)addTkImageMianView:(UIImage *)image{
    _tkImageMainView = [UIView new];
    _tkImageMainView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    _tkImageMainView.backgroundColor = [UIColor blackColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [leftBtn addTarget:self action:@selector(upTkImageLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"取消" forState:0];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"截取" forState:0];
     [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(upTkImageRightButton) forControlEvents:UIControlEventTouchUpInside];
    _tkImageView = [[TKImageView alloc]init];
    _tkImageView.toCropImage = image;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 22;
    _tkImageView.cropAreaCornerHeight = 22;
    _tkImageView.cropAspectRatio = WIDTH/200.0;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 1;
    _tkImageView.cropAreaMidLineWidth = 15;
    _tkImageView.cropAreaMidLineHeight = 4;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 1;
    _tkImageView.initialScaleFactor = .8f;
    
    [_tkImageMainView sd_addSubviews:@[_tkImageView , leftBtn , rightBtn]];
    leftBtn.sd_layout
    .bottomSpaceToView(_tkImageMainView, 10)
    .leftSpaceToView(_tkImageMainView, 10);
    [leftBtn setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
    rightBtn.sd_layout
    .bottomSpaceToView(_tkImageMainView, 10)
    .rightSpaceToView(_tkImageMainView, 10);
    [rightBtn setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
    _tkImageView.sd_layout
    .topSpaceToView(_tkImageMainView, 10)
    .leftSpaceToView(_tkImageMainView, 0)
    .rightSpaceToView(_tkImageMainView, 0)
    .bottomSpaceToView(leftBtn, 10);
    [self.view addSubview:_tkImageMainView];
}
//点击了封面编辑取消按钮
-(void)upTkImageLeftButton{
    [_tkImageMainView removeFromSuperview];
}
//点击了封面编辑截取按钮
-(void)upTkImageRightButton{
    [DLAlert alertShowLoad];
    NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid
                             };
    __weak typeof(self)weakSelf = self;
     [BANetManager ba_uploadImageWithUrlString:url parameters:params imageArray:@[[_tkImageView currentCroppedImage]] fileName:@"groupImage" successBlock:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [DLAlert alertHideLoad];
            if ( [str isEqualToString:@"1"]) {
                if(response[@"data"]){
                    NSDictionary  * dic = response[@"data"];
                    if(dic){
                        NSString *imageStr = dic[@"src"];
                        [DLAlert alertHideLoad];
                        [weakSelf.coverBtn setBackgroundImage:[_tkImageView currentCroppedImage] forState:UIControlStateNormal];
                        weakSelf.coverBtn.tag = 10086;
                        weakSelf.lastTkStr = imageStr;
                        [weakSelf.tkImageMainView removeFromSuperview];
                    }
                }
            }else{
                [DLAlert alertWithText:response[@"msg"]];
            }
        });
        
     } failurBlock:^(NSError *error) {
          [DLAlert alertWithText:@"保持网络畅通"];
     } upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
         
     }];
}
-(void)httpImageNameData:(int)row{
    NSArray *imgArray;
    if (row == 0) {
        imgArray = _topPhotos;
    }else if (row == 1){
        imgArray = _midPhotos;
    }else if (row == 2){
        imgArray = _downPhotos;
    }
    NSString *url = [NSString stringWithFormat:@"%@Upload/uploadFile",BASE_URL];
    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
    
    NSDictionary *params = @{
                             @"token" : [DLTUserCenter userCenter].token,
                             @"uid"   : user.uid
                             };
    __weak typeof(self)weakSelf = self;
    for (int i = 0; i < imgArray.count; i++) {
        [BANetManager ba_uploadImageWithUrlString:url parameters:params imageArray:@[imgArray[i]] fileName:@"groupImage" successBlock:^(id response) {
            NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ( [str isEqualToString:@"1"]) {
                    if(response[@"data"]){
                        NSDictionary  * dic = response[@"data"];
                        if(dic){
                            NSString *imageStr = dic[@"src"];
                            imageStr = [NSString stringWithFormat:@"{{%@}}",imageStr];
                            if (row == 0) {
                                if (_topImageView&&i == imgArray.count - 1) {
                                    [_topImageView removeFromSuperview];
                                }
                                if (i==0 ) {
                                    weakSelf.topPhotosStr = imageStr;
                                    
                                }else{
                                    weakSelf.topPhotosStr = [NSString stringWithFormat:@"%@%@",weakSelf.topPhotosStr,imageStr];
                                }
                                if (i == imgArray.count - 1) {
                                    [DLAlert alertHideLoad];
                                    [weakSelf upPhotos:weakSelf.topPhotos row:0];
                                }
                                
                                
                            }else if (row == 1){
                                if (_midImageView&&i == imgArray.count - 1) {
                                    [_midImageView removeFromSuperview];
                                }
                                
                                if (i==0) {
                                    weakSelf.midPhotosStr = imageStr;
                                }else{
                                    weakSelf.midPhotosStr = [NSString stringWithFormat:@"%@%@",weakSelf.midPhotosStr,imageStr];
                                }
                                if (i == imgArray.count - 1) {
                                    [DLAlert alertHideLoad];
                                    [weakSelf upPhotos:weakSelf.midPhotos row:1];
                                }
                                
                                
                            }else{
                                if (_downImageView&&i == imgArray.count - 1) {
                                    [_downImageView removeFromSuperview];
                                }
                                
                                if (i==0) {
                                    weakSelf.downPhotosStr = imageStr;
                                }else{
                                    weakSelf.downPhotosStr = [NSString stringWithFormat:@"%@%@",weakSelf.downPhotosStr,imageStr];
                                }
                                if (i == imgArray.count - 1) {
                                    [DLAlert alertHideLoad];
                                    [weakSelf upPhotos:weakSelf.downPhotos row:2];
                                }
                            }
                        }
                    }
                }else{
                    [DLAlert alertWithText:response[@"msg"]];
                }
                
            });
            
        } failurBlock:^(NSError *error) {
            [DLAlert alertWithText:@"请保持网络畅通"];
        } upLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            
        }];

    }
}
//点击图片
-(void)upButtonSeeImage:(UIButton *)btn{
    int I = btn.tag;
    
    SDPhotoBrowser *browser = [SDPhotoBrowser new];
    if (I<100) {
        browser.currentImageIndex = btn.tag - 10;
        browser.tag = 0;
        browser.sourceImagesContainerView = self.topImageView;
        browser.noShowAnimal = YES;
        browser.imageCount = self.topPhotos.count;
    }else if (I >= 1000){
        browser.tag = 1;
        browser.currentImageIndex = btn.tag - 1000;
        browser.sourceImagesContainerView = self.downImageView;
        browser.imageCount = self.downPhotos.count;
    }else{
        browser.tag = 2;
         browser.currentImageIndex = btn.tag - 100;
        browser.sourceImagesContainerView = self.midImageView;
        browser.imageCount = self.midPhotos.count;
    }
   
    browser.delegate = self;
    [browser show];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    if (browser.tag == 0) {
         return self.topPhotos[index];
    }else if (browser.tag == 1){
         return self.midPhotos[index];
    }else{
         return self.downPhotos[index];
    }
   
}

//点击删除
- (void)selectClick:(UIButton *)btn {
    int I = btn.tag;
    [DLAlert alertShowLoad];
    if (I<100) {
        [self.topPhotos removeObjectAtIndex:btn.tag - 10];
      
        if (self.topPhotos.count > 0) {
             [self httpImageNameData:0];
        }else{
             [_topImageView removeFromSuperview];
            
            _topPhotosStr = nil;
        
            [self upPhotos:nil row:0];
            [DLAlert alertHideLoad];
      
        }
    }else if (I >= 1000){
        [self.downPhotos removeObjectAtIndex:btn.tag - 1000];
     
        if (self.downPhotos.count > 0) {
            [self httpImageNameData:2];
        }else{
              [_downImageView removeFromSuperview];
            _downPhotosStr = nil;
            [self upPhotos:nil row:2];
             [DLAlert alertHideLoad];
        }
    }else{
        [self.midPhotos removeObjectAtIndex:btn.tag - 100];
      
        if (self.midPhotos.count > 0) {
            [self httpImageNameData:1];
        }else{
            [_midImageView removeFromSuperview];
            _midPhotosStr = nil;
            [self upPhotos:nil row:1];
             [DLAlert alertHideLoad];
        }
   }
   
}
//点击了下一步按钮
-(void)upNextButton{
    if (_islink) {
        if ([_titleField.text isEqualToString:@""] || [_topTextView.text isEqualToString:@""]  ) {
             [DLAlert alertWithText:@"请填写完整"];
        }else{
            DLCostViewController *sdView = [DLCostViewController new];
            NSString *postText = [NSString stringWithFormat:@"%@%@%@%@%@%@",_topTextView.text,_topPhotosStr,_midTextView.text,_midPhotosStr,_downTextView.text,_downPhotosStr];
            ;
            postText  = [postText stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            sdView.AdTitle = postText;
            sdView.linkTitle = _titleField.text;
            sdView.covorImage = _lastTkStr;
            sdView.cityCodeStr = _cityCodeStr;
            sdView.isLink = YES;
            [self.navigationController pushViewController:sdView animated:YES];
        }
    }else{
        if ([_topTextView.text isEqualToString:@""] || _topPhotos.count == 0        ) {
            [DLAlert alertWithText:@"请填写完整"];
        }else{
             NSLog(@"%@",_cityCodeStr);
            DLCostViewController *sdView = [DLCostViewController new];
    
            NSString *postText = [NSString stringWithFormat:@"%@%@",_topTextView.text,_topPhotosStr];
            sdView.AdTitle = postText;
            sdView.covorImage = _lastTkStr;
            sdView.cityCodeStr = _cityCodeStr;
            [self.navigationController pushViewController:sdView animated:YES];
            
        }
        
    }
   
}
- (void)loadFirstData
{
    // 注意JSON后缀的东西和Plist不同，Plist可以直接通过contentOfFile抓取，Json要先打成字符串，然后用工具转换
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    self.addressArr = [jsonStr mj_JSONObject];
  
    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
      
        NSString *name = dict[@"name"];
        [firstName addObject:name];
    }
    // 第一层是省份 分解出整个省份数组
    self.provinceArr = firstName;
}
// 根据传进来的下标数组计算对应的三个数组
- (void)calculateFirstData
{
    // 拿出省的数组
    [self loadFirstData];
    
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    // 根据省的index1，默认是0，拿出对应省下面的市
    NSLog(@"%@",[self.addressArr[self.index1] allValues].firstObject);

    
   
    for (NSDictionary *cityName in [self.addressArr[self.index1] valueForKey:@"c"]) {
        NSLog(@"%@",cityName);
        NSString *name1 = cityName [@"name"];
        [cityNameArr addObject:name1];
    }
    // 组装对应省下面的市
    self.countryArr = cityNameArr;
  
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        default:break;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    switch (component)
    {
        case 0: title =   self.provinceArr[row];break;
        case 1: title =   self.countryArr[row];break;
        default:break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.index1 = row;
            self.index2 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self calculateFirstData];
            [pickerView reloadComponent:1];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
           
        }
            break;
            
        case 1:
        {
            self.index2 = row;

        }
            break;
        default:break;
    }
}
- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}
// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
    NSMutableString *detailAddress = [[NSMutableString alloc] init];
    if (self.index1 < self.provinceArr.count) {
        NSString *firstAddress = self.provinceArr[self.index1];
        [detailAddress appendString:firstAddress];
    }
    if (self.index2 < self.countryArr.count) {
        NSString *secondAddress = self.countryArr[self.index2];
        [detailAddress appendString:secondAddress];
    }
    self.cityCodeStr =  [self.addressArr[self.index1] valueForKey:@"c"][self.index2][@"adcode"];
  
    [_cityCodeBtn setTitle:detailAddress forState:0];
}

@end
