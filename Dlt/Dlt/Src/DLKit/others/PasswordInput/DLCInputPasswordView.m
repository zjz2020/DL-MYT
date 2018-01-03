//
//  DLCInputPasswordView.m
//
//  Created by Liuquan on 16/8/24.
//  Copyright © 2016年 com.grsf. All rights reserved.
//
/// 我根据需求改了这个
#import "DLCInputPasswordView.h"

#define ViewTag 1000

@interface DLCInputPasswordView()
@property (nonatomic,weak)  UIImageView *secretImageView;
@end
@implementation DLCInputPasswordView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
         UITextField *secretTextfield = [[UITextField alloc]initWithFrame:self.bounds];
        self.textField = secretTextfield;
        secretTextfield.keyboardType = UIKeyboardTypeNumberPad;
        secretTextfield.tintColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:secretTextfield];
        [self addSubview:secretTextfield];
        
        UIImageView *secretImageView = [[UIImageView alloc]initWithFrame:secretTextfield.frame];
        secretImageView.image = [UIImage imageNamed:@"SettingSecret_mimakuang"];
        self.secretImageView = secretImageView;
        [self addSubview:secretImageView];
        
        CGFloat ImageW = frame.size.width / 6;
        
        for (int i = 0; i < 6; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,20,20)];
            img.center = CGPointMake(i * ImageW + ImageW / 2, 25);
            img.image = [UIImage imageNamed:@"SettingSecret_mima"];
            img.hidden = YES;
            img.tag = ViewTag + i;
            [secretImageView addSubview:img];
        }
    }
    return self;
}

- (void)textFieldDidChange:(NSNotification *)obj {
    UITextField * textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    for (int i = 0; i< self.secretImageView.subviews.count; i++) {
        UIImageView *img = (UIImageView *)self.secretImageView.subviews[i];
        if (img.tag <= textField.text.length + 999) {
            img.hidden = NO;
        }
        else {
            img.hidden = YES;
        }
    }
    if (toBeString.length >= 6) {
        textField.text = [toBeString substringToIndex:6];
    }
    if (textField.text.length == 6) {
        if ([self.delegate respondsToSelector:@selector(inputPasswordViewDelegate:inputEndWithPassword:)]) {
            [self.delegate inputPasswordViewDelegate:self inputEndWithPassword:textField.text];
        }
        [textField resignFirstResponder];
    }
}

@end
