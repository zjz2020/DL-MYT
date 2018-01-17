//
//  DLTTextView.m
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTTextView.h"
#import "DltUICommon.h"

@interface DLTTextView() < UITextViewDelegate >

@property (nonatomic , weak) UILabel *placeholderLabel;

@end

@implementation DLTTextView

- (instancetype)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  if (self) {
    
    self.backgroundColor = [UIColor clearColor];
    
    //添加一个现实提醒文字的label
    UILabel *placehoderLabel = [[UILabel alloc] init];
    placehoderLabel.numberOfLines = 0;
    placehoderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:placehoderLabel];
    
    self.placeholderLabel = placehoderLabel;
    
    //设置默认文字颜色
    self.placeholderColor = [UIColor lightGrayColor];
    
    //设置默认字体
    self.font = [UIFont systemFontOfSize:14];
    
    //监听内部文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    //为textview添加一个手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewOnClick)];
    [self addGestureRecognizer:gesture];
  }
  
  return self;
}

- (void)textViewOnClick {
  
  [self becomeFirstResponder];
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 监听文字改变
- (void)textDidChange{
  
  self.placeholderLabel.hidden = self.hasText;
}

#pragma mark - 公共方法

- (void)resetTextView{
  [self setText:nil];
  [self resignFirstResponder];
}

- (void)setText:(NSString *)text {
        [self setAttributedText:self.attributedText];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
    _mainView.navigationItem.rightBarButtonItem.enabled = YES;
  [super setAttributedText:attributedText];
  [self textDidChange];
}

- (void)setPlaceholder:(NSString *)placeholder {
  
  _placeholder = placeholder;
  //设置文字
  self.placeholderLabel.text = placeholder;
  //重新计算子控件frame
  [self setNeedsLayout];
  
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor {
  
  _placeholderColor = placeholderColor;
  self.placeholderLabel.textColor = placeholderColor;
  
}


- (void)setFont:(UIFont *)font {
  [super setFont:font];
  self.placeholderLabel.font = font;
  
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  
  [super layoutSubviews];

    self.placeholderLabel.frame = CGRectMake(5, 8, self.width , 20);
}


@end
