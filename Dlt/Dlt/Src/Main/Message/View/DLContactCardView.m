//
//  DLContactCardView.m
//  Dlt
//
//  Created by Liuquan on 17/6/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLContactCardView.h"
#import "DltUICommon.h"
#import "DLFriendsModel.h"


@interface DLContactCardView () {
    UIView *_backView;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *acceptName;
@property (weak, nonatomic) IBOutlet UILabel *sendName;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;


@end

@implementation DLContactCardView

+ (instancetype)shareInstance {
    DLContactCardView *cardView = [[[NSBundle mainBundle] loadNibNamed:@"DLContactCardView" owner:nil options:nil] lastObject];
    return cardView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImg ui_setCornerRadius:4];
    
    [self ui_setCornerRadius:6];
    
}

- (void)popAnimationView:(UIView *)supView {
    self.backgroundColor = [UIColor whiteColor];
    [self addBackView:supView];
    self.frame = CGRectMake(0, 0, 290, 256);
    self.center = CGPointMake(kScreenSize.width / 2, kScreenSize.height / 2 - 50);
    [supView addSubview:self];
}

- (void)addBackView:(UIView *)supView {
    _backView = [[UIView alloc] init];
    _backView.frame = supView.bounds;
    _backView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewAction)];
    [_backView addGestureRecognizer:tapGesture];
    [supView addSubview:_backView];
}

- (void)tapBackViewAction {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [_backView removeFromSuperview];
    _backView = nil;
}

#pragma mark - setter
- (void)setUserInfo:(DLFriendsInfo *)userInfo {
    _userInfo = userInfo;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,userInfo.headImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    self.acceptName.text = userInfo.name;
}

- (void)setSenderName:(NSString *)senderName {
    _senderName = senderName;
    
    self.sendName.text = [NSString stringWithFormat:@"[个人名片]%@",senderName];
}

#pragma mark - 点击事件
// 取消
- (IBAction)cancleButtonAction:(UIButton *)sender {
    [self tapBackViewAction];
}

// 确定
- (IBAction)sureButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactCardView:sendFriendCardToOtherWithUserInfo:andTheNote:)]) {
        [self.delegate contactCardView:self sendFriendCardToOtherWithUserInfo:self.userInfo andTheNote:self.noteTextField.text];
    }
    [self tapBackViewAction];
}

@end
