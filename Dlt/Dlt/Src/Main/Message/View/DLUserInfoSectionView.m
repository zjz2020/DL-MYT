//
//  DLUserInfoSectionView.m
//  Dlt
//
//  Created by Liuquan on 17/6/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLUserInfoSectionView.h"

#define kStartTag 100

@interface DLUserInfoSectionView ()

@end


@implementation DLUserInfoSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    UIButton *filesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filesBtn = filesBtn;
    filesBtn.tag = kStartTag;
    filesBtn.frame = CGRectMake(0, 0, self.frame.size.width / 2, 45);
    filesBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [filesBtn setTitle:@"资料" forState:UIControlStateNormal];
    [filesBtn setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
    [filesBtn setTitleColor:[UIColor colorWithHexString:@"0089F1"] forState:UIControlStateSelected];
    [filesBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    filesBtn.selected = YES;
    [self addSubview:filesBtn];
    filesBtn.selected = YES;
    
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamicBtn.tag = kStartTag + 1;
    self.dynamicBtn = dynamicBtn;
    dynamicBtn.frame = CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, 45);
    dynamicBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [dynamicBtn setTitle:@"动态" forState:UIControlStateNormal];
    [dynamicBtn setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
    [dynamicBtn setTitleColor:[UIColor colorWithHexString:@"0089F1"] forState:UIControlStateSelected];
    [dynamicBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dynamicBtn];
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(filesBtn.frame), self.frame.size.width / 2, 3)];
    self.underLine = underLine;
    underLine.backgroundColor = [UIColor colorWithHexString:@"0089F1"];
    [self addSubview:underLine];
    
}

#pragma mark - 点击事件
- (void)buttonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoSectionView:clickButtonWithIndex:)]) {
        [self.delegate userInfoSectionView:self clickButtonWithIndex:sender.tag - kStartTag];
    }
}

@end
