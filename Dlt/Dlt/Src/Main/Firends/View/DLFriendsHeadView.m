//
//  DLFriendsHeadView.m
//  Dlt
//
//  Created by Liuquan on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLFriendsHeadView.h"
#import "DltUICommon.h"


@interface DLFriendsHeadView ()<UITextFieldDelegate>

@property(nonatomic, strong)UIButton *searchBtn;

@end



@implementation DLFriendsHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [self creatUI];
        
        /// 监听键盘收起
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardDidHideNotification object:nil];

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
    textField.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, seachView.frame.size.width - 80, 30);
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = @"搜索好友";
    textField.textColor = [UIColor colorWithHexString:@"9C9C9C"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [seachView addSubview:textField];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(CGRectGetMaxX(textField.frame), 0, 40, 30);
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"0089f1"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleSearchFriend:) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn = cancleBtn;
    cancleBtn.hidden = YES;
    [seachView addSubview:cancleBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(seachView.frame) + 12.5, viewW, 54)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 38, 38)];
    header.image = [UIImage imageNamed:@"friend_new"];
    [bottomView addSubview:header];
    
    UILabel *newFriend = [[UILabel alloc] init];
    newFriend.frame = CGRectMake(CGRectGetMaxX(header.frame) + 15, 0, 100, 54);
    newFriend.font = [UIFont systemFontOfSize:17];
    newFriend.text = @"新的好友";
    newFriend.textColor = [UIColor colorWithHexString:@"2C2C2C"];
    [bottomView addSubview:newFriend];
    
    UIImageView *more = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    more.center = CGPointMake(viewW - 30, bottomView.frame.size.height / 2);
    more.image = [UIImage imageNamed:@"friend_right"];
    [bottomView addSubview:more];
    
    // 给view添加手势
    bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeMoreNewFriends:)];
    [bottomView addGestureRecognizer:friendTap];
    
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(seachYourSelfFriendsWithNickName:)]) {
        [self.delegate seachYourSelfFriendsWithNickName:textField.text];
    }
    [self.textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.searchBtn.hidden = NO;
    } else {
        self.searchBtn.hidden = YES;
    }
}

//- (void)keyboardHidden {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(seachYourSelfFriendsWithNickName:)]) {
//        [self.delegate seachYourSelfFriendsWithNickName:self.textField.text];
//    }
//    [self.textField resignFirstResponder];
//}

#pragma mark - 点击事件

// 查新朋友
- (void)seeMoreNewFriends:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkYourSelfNewFriends)]) {
        [self.delegate checkYourSelfNewFriends];
    }
}

- (void)cancleSearchFriend:(UIButton *)sender {
//    self.textField.text = nil;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleSearchFriends)]) {
//        [self.delegate cancleSearchFriends];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(seachYourSelfFriendsWithNickName:)]) {
        [self.delegate seachYourSelfFriendsWithNickName:self.textField.text];
    }
    [self.textField resignFirstResponder];
}

@end
