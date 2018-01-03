//
//  DLTPublishDynamicVisibleAlertView.m
//  Dlt
//
//  Created by Gavin on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTPublishDynamicVisibleAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "DltUICommon.h"

@interface  DLTPublishDynamicVisibleAlertContainerView :UIView

@property (nonatomic ,weak) UIButton *publicButton;
@property (nonatomic ,weak) UIButton *privateButton;
@property (nonatomic , assign,getter=isVisible) DLTPublishDynamicVisibleType visible;

@property (nonatomic , copy) dispatch_block_t  visibleChange_block;

@end

@implementation DLTPublishDynamicVisibleAlertContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.backgroundColor = [UIColor whiteColor];
    UIView *topView = [UIView new];
    topView.tag = DLTPublishDynamicVisibleTypePublic;
    
    UIView *bottomView = [UIView new];
    bottomView.tag = DLTPublishDynamicVisibleTypePrivate;
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = rgb(156, 156, 156);
    [self sd_addSubviews:@[topView,bottomView,lineLabel]];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(self.height/2);
      make.left.equalTo(self.mas_left);
      make.right.equalTo(self.mas_right);
      make.top.equalTo(self.mas_top);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(self.height/2);
      make.left.equalTo(self.mas_left);
      make.right.equalTo(self.mas_right);
      make.bottom.equalTo(self.mas_bottom);
    }];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(.6f);
      make.left.equalTo(self.mas_left);
      make.right.equalTo(self.mas_right);
      make.centerY.equalTo(self);
    }];
    
    
    //
    UIButton *publicButton = [self addButtonWithIcon:@"dlt_PublishDynamic_normal" selectedIcon:@"dlt_PublishDynamic_highlighted"];
    UIButton *privateButton = [self addButtonWithIcon:@"dlt_PublishDynamic_normal" selectedIcon:@"dlt_PublishDynamic_highlighted"];
    
    UILabel *publicLabel = [UILabel new];
    publicLabel.text = @"公开";
    publicLabel.font = [UIFont boldSystemFontOfSize:17];
    
    UILabel *publicDesLabel = [UILabel new];
    publicDesLabel.text = @"所有好友都可见";
    publicDesLabel.font = [UIFont systemFontOfSize:14];
    publicDesLabel.textColor = rgb(156, 156, 156);
    
    UILabel *privateLabel = [UILabel new];
    privateLabel.text = @"秘密";
    privateLabel.font = [UIFont boldSystemFontOfSize:17];
    
    UILabel *privateDesLabel = [UILabel new];
    privateDesLabel.text = @"仅自己可见";
    privateDesLabel.font = [UIFont systemFontOfSize:14];
    privateDesLabel.textColor = rgb(156, 156, 156);
    
    
     [topView sd_addSubviews:@[publicButton,publicLabel,publicDesLabel]];
     [bottomView sd_addSubviews:@[privateButton,privateLabel,privateDesLabel]];
    self.publicButton = publicButton;
    self.privateButton = privateButton;
    
    [publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.and.height.mas_equalTo(60);
      make.left.equalTo(topView.mas_left);
      make.centerY.equalTo(topView);
    }];
    
    [privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.and.height.mas_equalTo(60);
      make.left.equalTo(bottomView.mas_left);
      make.centerY.equalTo(bottomView);
    }];
    
    
    [publicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(20);
      make.width.mas_equalTo(120);
      make.left.equalTo(publicButton.mas_right);
      make.centerY.equalTo(publicButton.mas_centerY).mas_offset(-10);
    }];
    
    [publicDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(20);
      make.width.mas_equalTo(120);
      make.left.equalTo(publicLabel);
      make.top.equalTo(publicLabel.mas_bottom).mas_offset(4);
    }];
    
    [privateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(20);
      make.width.mas_equalTo(120);
      make.left.equalTo(publicButton.mas_right);
      make.centerY.equalTo(privateButton.mas_centerY).mas_offset(-10);
    }];
    
    [privateDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(20);
      make.width.mas_equalTo(120);
      make.left.equalTo(privateLabel);
      make.top.equalTo(privateLabel.mas_bottom).mas_offset(4);
    }];
    

    @weakify(self);
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer *sender) {
      @strongify(self);
        [self tapGestureRecognizer:sender];
    }];
    [topView addGestureRecognizer:topTap];
    
    UITapGestureRecognizer *bottomTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer *sender) {
       @strongify(self);
      [self tapGestureRecognizer:sender];
    }];
    [bottomView addGestureRecognizer:bottomTap];
    
    
  }
  return self;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender{
  self.visible = sender.view.tag;
  
  if (self.visibleChange_block) {self.visibleChange_block();}
}

- (void)setVisible:(DLTPublishDynamicVisibleType)visible{
  _visible = visible;
  
  if (visible == DLTPublishDynamicVisibleTypePublic) {
    self.publicButton.selected = YES;
    self.privateButton.selected = NO;
  }
  
  if (visible == DLTPublishDynamicVisibleTypePrivate) {
    self.publicButton.selected = NO;
    self.privateButton.selected = YES;
  }
}

/**
 *  添加一个按钮
 *
 *  @param icon     默认图标
 *  @param highIcon 高亮图标
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon selectedIcon:(NSString *)selected {
  UIButton *button = [[UIButton alloc] init];
  [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
  [button setImage:[UIImage imageWithName:selected] forState:UIControlStateSelected];
  return button;
}


@end


@interface DLTPublishDynamicVisibleAlertView ()

@property (nonatomic, strong) UIView     *containers;

@end

@implementation DLTPublishDynamicVisibleAlertView

- (UIView *)containers{
  if (!_containers) {
    _containers = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:_containers];
  }
  return _containers;
}


- (instancetype)init
{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if (self) {
        self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)pop:(DLTPublishDynamicVisibleType)visible visibleChange:(void (^)(DLTPublishDynamicVisibleType type))visibleBlock {
  [[self statusBarWindow] addSubview:self];
  
    DLTPublishDynamicVisibleAlertContainerView *customView = [[DLTPublishDynamicVisibleAlertContainerView alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
    customView.center = self.center;
  customView.visible = visible;
  [self addSubview:customView];

  customView.layer.cornerRadius = 5;
  customView.layer.borderColor = [UIColor grayColor].CGColor;
  customView.layer.borderWidth = .5;
  
  @weakify(self,customView);
  customView.visibleChange_block = ^(){
    @strongify(self,customView);
    [self dismissViewAnimation];
    @autoreleasepool {
      if (visibleBlock) {
        visibleBlock(customView.isVisible);
      }
    }
  };
  
  [self showViewAnimation];
}


#pragma mark -

- (void)showViewAnimation{
  [UIView animateWithDuration:.4 animations:^{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
  }];
}

- (void)dismissViewAnimation {
  [UIView animateWithDuration:.4 animations:^{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    [self removeFromSuperview];
  }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  UITouch *touch = (UITouch *)touches.anyObject;
  if (touch.view == self) {
    [self dismissViewAnimation];
  }
}



- (UIWindow *)statusBarWindow {
  return [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
}


@end
