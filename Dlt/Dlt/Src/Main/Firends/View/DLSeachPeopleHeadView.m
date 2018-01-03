//
//  DLSeachPeopleHeadView.m
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLSeachPeopleHeadView.h"
#import "DltUICommon.h"
#import "MBProgressHUD.h"

@interface DLSeachPeopleHeadView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *code;
@property (nonatomic, strong) UIImageView *headImg;
@end

@implementation DLSeachPeopleHeadView

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
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(seachView.frame) + 12.5, viewW, 54)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 38, 38)];
    self.headImg = header;
    header.image = [UIImage imageNamed:@"friend_qrcode"];
    [bottomView addSubview:header];
    
    UILabel *newFriend = [[UILabel alloc] init];
    self.code = newFriend;
    newFriend.frame = CGRectMake(CGRectGetMaxX(header.frame) + 15, 0, 100, 54);
    newFriend.font = [UIFont systemFontOfSize:17];
    newFriend.text = @"我的二维码";
    newFriend.textColor = [UIColor colorWithHexString:@"2C2C2C"];
    [bottomView addSubview:newFriend];
    
    UIImageView *more = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    more.center = CGPointMake(viewW - 30, bottomView.frame.size.height / 2);
    more.image = [UIImage imageNamed:@"friend_right"];
    [bottomView addSubview:more];
    
    // 给view添加手势
    bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMySelfQRCodeTap)];
    [bottomView addGestureRecognizer:friendTap];
    
    /// 监听键盘收起
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardDidHideNotification object:nil];
    
}

#pragma mark - 点击事件
- (void)showMySelfQRCodeTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(seachPeopleHeadViewToShowMyQRCode)]) {
        [self.delegate seachPeopleHeadViewToShowMyQRCode];
    }
}
- (void)setIsSeachPeople:(BOOL)isSeachPeople {
    _isSeachPeople = isSeachPeople;
    if (isSeachPeople) {
        self.code.text = @"我的二维码";
        self.headImg.image = [UIImage imageNamed:@"friend_qrcode"];
        self.textField.placeholder = @"输入手机号或对方蚂蚁通号";
    } else {
        self.code.text = @"创建群";
        self.headImg.image = [UIImage imageNamed:@"friend_groups"];
        self.textField.placeholder = @"输入群号或群名字";
    }
}
//- (void)keyboardHidden {
//    if (ISNULLSTR(self.textField.text)) {
//        return;
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(seachPeopleHeadView:seachWithPhoneNumber:)]) {
//        [self.delegate seachPeopleHeadView:self seachWithPhoneNumber:self.textField.text];
//    }
//}
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
