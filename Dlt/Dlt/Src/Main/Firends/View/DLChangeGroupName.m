//
//  DLChangeGroupName.m
//  Dlt
//
//  Created by Liuquan on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLChangeGroupName.h"
#import "DltUICommon.h"
#import "DLTextView.h"

@interface DLChangeGroupName ()

@property (nonatomic, strong) DLTextView *textView;

@end

@implementation DLChangeGroupName

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, self.frame.size.width - 60, 330);
    backView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 30);
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 6;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(15, 20, backView.frame.size.width - 30, 14);
    title.text = @"10-300字";
    [backView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame) + 20, backView.frame.size.width - 30, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"CECECE"];
    [backView addSubview:line];
    
    DLTextView *text = [[DLTextView alloc] init];
    text.frame = CGRectMake(15, CGRectGetMaxY(line.frame), backView.frame.size.width - 30, 222);
    text.font = [UIFont systemFontOfSize:14];
    text.textColor = [UIColor colorWithHexString:@"2c2c2c"];
    text.placeholder = @"请输入群介绍";
    text.placeholderColor = [UIColor colorWithHexString:@"999999"];
    self.textView = text;
    [backView addSubview:text];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(text.frame), backView.frame.size.width - 30, .5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    [backView addSubview:line1];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(15, CGRectGetMaxY(line1.frame), (backView.frame.size.width - 30) / 2, 53);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.tag = 101;
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancleBtn addTarget:self action:@selector(sureOrCancleChangeGroupName:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(cancleBtn.frame), CGRectGetMaxY(line1.frame), cancleBtn.frame.size.width, 53);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"0089F1"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.tag = 102;
    [sureBtn addTarget:self action:@selector(sureOrCancleChangeGroupName:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureBtn];
    
}
- (void)sureOrCancleChangeGroupName:(UIButton *)sender {
    if (sender.tag == 102) {
        if (ISNULLSTR(self.textView.text)) {
            [DLAlert alertWithText:@"请填写群介绍"];
            return;
        }
        if (self.textView.text.length < 10) {
            [DLAlert alertWithText:@"请填写至少10个字"];
            return;
        }
        if (self.textView.text.length > 300) {
            [DLAlert alertWithText:@"至多填写300字"];
            return;
        }
        if (self.groupNameBlock) {
            self.groupNameBlock(self.textView.text);
        }
    }
    [self removeFromSuperview];
}

@end
