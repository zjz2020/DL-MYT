//
//  JWShareView.m
//  ShareViewDemo
//
//  Created by GJW on 16/8/8.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "JWShareView.h"

#define kShareItemNum 3

#define kBtnW 60
#define kBtnH 100

#define kMarginX 15
#define kMarginY 15
#define kTopMargin 45

#define kTitlePrecent 0.4

#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface JWShareItemButton()
@end
@implementation JWShareItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = AdaptedFontSize(15);
        
        [self setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
//        self.imageView.layer.cornerRadius = kImageViewWH * 0.5;
      
    }
    return self;
}



#pragma mark 调整文字的位置和尺寸

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
  return CGRectMake(0, self.imageView.bottom + 15, self.width, 22);
}

#pragma mark 调整图片的位置和尺寸

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = (self.frame.size.width - kBtnW) * 0.5;
    return CGRectMake(imageX, 0, kBtnW, kBtnW);
}

@end


@interface JWShareView()
@property (nonatomic, strong) NSArray *sharItems;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, copy) void(^btnBlock)(NSInteger tag, NSString *title);

@end

@implementation JWShareView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:CGRectMake(0, HEIGHT, kScreenWidth, 225)];
  if (self) {
    
  }
  return self;
}

- (void)addShareItems:(UIView *)superView  shareItems:(NSArray *)shareItems selectShareItem:(selectItemBlock)selectShareItem{
    if (shareItems == nil || shareItems.count < 1) return;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addBackgroundView:superView];
    
    [shareItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj[@"name"];
        NSString *icon = obj[@"icon"];
        JWShareItemButton *btn = [JWShareItemButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
      
      
      CGFloat itemW = self.width/3;
      
      CGFloat btnX =  itemW*idx;
      btn.frame = CGRectMake(btnX, kTopMargin, itemW, kBtnH);
      [self addSubview:btn];
    }];

    [superView addSubview:self];
  
    //取消
    UIButton *canleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [canleBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [canleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    canleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [canleBtn setBackgroundColor:[UIColor whiteColor]];
    [canleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [canleBtn addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:canleBtn];
    
    [canleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mas_left);
      make.bottom.equalTo(self.mas_bottom);
      make.width.mas_equalTo (kScreenWidth);
      make.height.mas_equalTo (54);
    }];
    
    
    self.btnBlock = ^(NSInteger tag, NSString *title){
        if(selectShareItem) selectShareItem(tag, title);
    };

  [self showViewAnimation];
}

- (void)showViewAnimation{
  [UIView animateWithDuration:.4 animations:^{
    self.transform =  CGAffineTransformMakeTranslation(0, -(225 ));
  } completion:^(BOOL finished) {
    
  }];
}

- (void)dismissViewAnimation {
  [UIView animateWithDuration:.35 animations:^{
    self.transform = CGAffineTransformIdentity;
  } completion:^(BOOL finished) {
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
    
  }];
}

- (void)addBackgroundView:(UIView *)superView{
    _backgroundView = [[UIView alloc] initWithFrame:superView.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonAction)];
    [_backgroundView addGestureRecognizer:tap];
    [superView addSubview:_backgroundView];
}

- (void)cancleButtonAction{
   [self dismissViewAnimation];
    if (_cancle) {
        _cancle();
    }
   }

- (void)btnClick:(UIButton *)sender{
    if(_btnBlock) _btnBlock(sender.tag, sender.titleLabel.text);
}
@end
