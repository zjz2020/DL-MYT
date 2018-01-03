//
//  DLTComposeToolbar.m
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTComposeToolbar.h"
#import "DltUICommon.h"

@interface DLTComposeToolbar()

@property (nonatomic ,weak) UIButton *emotionButton;
@property (nonatomic ,weak) UIButton *visibleButton;

@end

@implementation DLTComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  if(self) {

    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"dlt_compose_toolbar_background"]];
    
    //添加所有子控件
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"dlt_compose_toolbar_background"]];
    
    // 添加所有的子控件
    [self addButtonWithIcon:@"dlt_compose_toolbar_picture" highIcon:@"dlt_compose_toolbar_picture_highlighted" tag:DLTComposeToolbarButtonTypePicture];
    [self addButtonWithIcon:@"dlt_compose_camerabutton_background" highIcon:@"dlt_compose_camerabutton_background_highlighted" tag:DLTComposeToolbarButtonTypeCamera];
    UIButton *emotionBtn = [self addButtonWithIcon:@"dlt_compose_emoticonbutton_background" highIcon:@"dlt_compose_emoticonbutton_background" tag:DLTComposeToolbarButtonTypeEmotion];
    
   UIButton *visibleButton = [self addButtonWithIcon:@"dlt_compose_visible_public_background" highIcon:@"dlt_compose_visible_private_background" tag:DLTComposeToolbarButtonTypeVisible];
    
    self.emotionButton = emotionBtn;
    self.visibleButton = visibleButton;
    self.visibleType = DLTPublishDynamicVisibleTypePublic;
  }
  
  return self;
}

/**
 *  添加一个按钮
 *
 *  @param icon     默认图标
 *  @param highIcon 高亮图标
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(DLTComposeToolbarButtonType)tag{
  
  UIButton *button = [[UIButton alloc] init];
  button.tag = tag;
  [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
  [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
  [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
  [self addSubview:button];
  return button;
}

- (void)setShowEmotionButton:(BOOL)showEmotionButton {
  _showEmotionButton = showEmotionButton;
  if (showEmotionButton) { // 显示表情按钮
    [self.emotionButton setImage:[UIImage imageWithName:@"dlt_compose_emoticonbutton_background"] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageWithName:@"dlt_compose_emoticonbutton_background"] forState:UIControlStateHighlighted];
  } else { // 切换为键盘按钮
    [self.emotionButton setImage:[UIImage imageWithName:@"dlt_compose_keyboardbutton_background"] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageWithName:@"dlt_compose_keyboardbutton_background"] forState:UIControlStateHighlighted];
  }
}

- (void)setVisibleType:(DLTPublishDynamicVisibleType)visibleType{
  _visibleType = visibleType;

    self.visibleButton.highlighted = (visibleType == DLTPublishDynamicVisibleTypePublic)? NO : YES;
}



- (void)buttonClick:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]){
    [self.delegate composeTool:self didClickedButton:(int)button.tag];
  }
}

- (void)layoutSubviews{
  [super layoutSubviews];
  
  int count = (int)self.subviews.count;
  CGFloat buttonW = self.width / count;
  CGFloat buttonH = self.height;
    NSLog(@"%D______%F_______%F",count,buttonW,buttonH);
  for (int i = 0; i<count; i++) {
    UIButton *button = self.subviews[i];
      button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
  }
}




@end
