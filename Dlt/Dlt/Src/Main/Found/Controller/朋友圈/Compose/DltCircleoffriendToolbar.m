//
//  DltCircleoffriendToolbar.m
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DltCircleoffriendToolbar.h"
#import "DltUICommon.h"

@interface DltCircleoffriendToolbar ()

@property (nonatomic ,weak) UIButton *emotionButton;

@end

@implementation DltCircleoffriendToolbar

// 懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard
{
  // 创建表情键盘
  if (_emotionKeyboard == nil) {
    
    YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
    
    emotionKeyboard.sendContent = ^(NSString *content){
      // 点击发送会调用，自动把文本框内容返回给你
    };
    
    _emotionKeyboard = emotionKeyboard;
  }
  return _emotionKeyboard;
}



- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"dlt_compose_toolbar_background"]];

    UIButton *emotionBtn = [self addButtonWithIcon:@"dlt_compose_emoticonbutton_background" highIcon:@"dlt_compose_emoticonbutton_background"];
    emotionBtn.tag = 1;
    self.emotionButton = emotionBtn;
    
    // 监听键盘弹出
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *note) {
      @strongify(self);
      if (self.delegate && [self.delegate respondsToSelector:@selector(circleoffriendToolbar:keyboardWillChange:isWillShow:)]) {
        [self.delegate circleoffriendToolbar:self keyboardWillChange:note isWillShow:YES];
      }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *note) {
      @strongify(self);
      if (self.delegate && [self.delegate respondsToSelector:@selector(circleoffriendToolbar:keyboardWillChange:isWillShow:)]) {
        [self.delegate circleoffriendToolbar:self keyboardWillChange:note isWillShow:NO];
      }
    }];
    
    
    DLTInputView *inputView = [[DLTInputView alloc] initWithFrame:CGRectZero];
    // 设置文本框占位文字
    inputView.placeholder = @"评论点什么吧";
    inputView.placeholderColor = rgb(156, 156, 156);
    
    // 监听文本框文字高度改变
    inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
      // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
      // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
      // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
//      _bottomHCons.constant = textHeight + 10;
      @strongify(self);
      if (self.delegate && [self.delegate respondsToSelector:@selector(circleoffriendToolbar:textHeightDidChange:)]) {
        [self.delegate circleoffriendToolbar:self textHeightDidChange:textHeight + 10];
      }
    };
    
    // 设置文本框最大行数
    inputView.maxNumberOfLines = 4;
    [self addSubview:inputView];
    self.textView = inputView;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.tag = 2;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    
    [emotionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(self.height);
      make.width.mas_equalTo(60);
      make.left.equalTo(self);
      make.centerY.equalTo(self);
    }];
    
    sendButton.backgroundColor = [UIColor redColor];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(self.height);
      make.width.mas_equalTo(80);
      make.right.equalTo(self.mas_right);
      make.centerY.equalTo(self);
    }];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(35);
      make.right.equalTo(sendButton.mas_left);
      make.left.equalTo(emotionBtn.mas_right);
      make.centerY.equalTo(self);
    }];
    
  }
  
  return self;
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


/**
 *  添加一个按钮
 *
 *  @param icon     默认图标
 *  @param highIcon 高亮图标
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon {
  UIButton *button = [[UIButton alloc] init];
  [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
  [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
  [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
  [self addSubview:button];
  return button;
}

- (void)buttonClick:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(circleoffriendToolbar:didClickedEmotion:)]) {
    [self.delegate circleoffriendToolbar:self didClickedEmotion:button.tag];
  }
}


@end
