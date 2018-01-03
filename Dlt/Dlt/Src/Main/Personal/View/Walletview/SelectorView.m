//
//  SelectorView.m
//  Dlt
//
//  Created by USER on 2017/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "SelectorView.h"
#import "DltUICommon.h"
#import "MBProgressHUD.h"
@interface SelectorView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end
@implementation SelectorView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    CGFloat viewW = self.frame.size.width;
    
    UIView *seachView = [[UIView alloc] initWithFrame:CGRectMake(30,12.5, viewW - 60, 30)];
    seachView.layer.cornerRadius = 5;
    seachView.layer.masksToBounds = YES;
    seachView.backgroundColor = [UIColor whiteColor];
    [self addSubview:seachView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"friend_seach"];
    [seachView addSubview:imageView];
    
    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, seachView.frame.size.width - 50, 30);
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.placeholder = @"输入手机号或对方蚂蚁通号";
    textField.textColor = [UIColor colorWithHexString:@"9C9C9C"];
    textField.returnKeyType = UIReturnKeySearch;
    [seachView addSubview:textField];
    

    
    
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (ISNULLSTR(textField.text)) {
        return YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(seachPeopleHeadView:seachWithPhoneNumber:)]) {
        [self.delegate seachPeopleHeadView:self seachWithPhoneNumber:textField.text];
    }
    [self.textField resignFirstResponder];
    return YES;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
