//
//  DLUserInfoHeadView.m
//  Dlt
//
//  Created by Liuquan on 17/6/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLUserInfoHeadView.h"
#import "DltUICommon.h"


#define kStartTag  100

@interface DLUserInfoHeadView ()

@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UIButton *setupBtn;

@end

@implementation DLUserInfoHeadView

- (instancetype)initWithFrame:(CGRect)frame {
   self =  [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    CGFloat viewW = self.frame.size.width;
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, 155)];
    backImg.image = [UIImage imageNamed:@"user_back_default"];
    backImg.contentMode = UIViewContentModeScaleAspectFill;
    backImg.clipsToBounds = YES;
  
    self.backImg = backImg;
    [self addSubview:backImg];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.headImg = headImg;
    headImg.center = CGPointMake(viewW / 2, 155);
    [self addSubview:headImg];
    [headImg ui_setCornerRadius:50 withBorderColor:[UIColor whiteColor] borderWidth:4];
    
    UILabel *nickname = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImg.frame) + 10, viewW, 20)];
    nickname.textColor = [UIColor colorWithHexString:@"444444"];
    self.nickname = nickname;
    nickname.textAlignment = NSTextAlignmentCenter;
    nickname.font = [UIFont systemFontOfSize:17];
    [self addSubview:nickname];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nickname.frame) + 10, viewW, 20)];
    self.noteLabel = detailLabel;
    detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    detailLabel.text = @"什么都没写，懒懒懒";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:detailLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailLabel.frame) + 10, viewW, 10)];
    line.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    [self addSubview:line];
    
    UIButton *filesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filesBtn = filesBtn;
    filesBtn.tag = kStartTag;
    filesBtn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), viewW / 2, 45);
    filesBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [filesBtn setTitle:@"资料" forState:UIControlStateNormal];
    [filesBtn setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
    [filesBtn setTitleColor:[UIColor colorWithHexString:@"0089F1"] forState:UIControlStateSelected];
    [filesBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filesBtn];
    filesBtn.selected = YES;
    
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dynamicBtn = dynamicBtn;
    dynamicBtn.tag = kStartTag + 1;
    dynamicBtn.frame = CGRectMake(viewW / 2, CGRectGetMaxY(line.frame), viewW / 2, 45);
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
    
    UIButton *setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setupBtn.frame = CGRectMake(kScreenSize.width - 40, 175, 25, 25);
    [setupBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    [setupBtn addTarget:self action:@selector(setPermissionsForFriends:) forControlEvents:UIControlEventTouchUpInside];
    self.setupBtn = setupBtn;
    [self addSubview:setupBtn];
    setupBtn.hidden = YES;
    
    //举报
    UIButton *reporBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    reporBtn.frame = CGRectMake(0, 175, 60, 25);
    [reporBtn setTitle:@"举报" forState:0];
    [reporBtn setTintColor:[UIColor blackColor]];
    [reporBtn addTarget:self action:@selector(upReportUserButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reporBtn];
   

   
    
}
-(void)upReportUserButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ReportUser)]) {
        [self.delegate ReportUser];
    }
}
#pragma mark - 点击事件
- (void)buttonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoHeadView:clickButtonWithIndex:)]) {
        [self.delegate userInfoHeadView:self clickButtonWithIndex:sender.tag - kStartTag];
    }
}

- (void)setPermissionsForFriends:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setFriendsPermissions)]) {
        [self.delegate setFriendsPermissions];
    }
}


#pragma mark - set 
- (void)setModel:(DLTUserProfile *)model {
    _model = model;
    
    self.sexLabel.text = model.sex ? @"男" : @"女";
    self.sexLabel.backgroundColor = model.sex ? [UIColor colorWithHexString:@"0089F1"] : [UIColor colorWithHexString:@"FF7B7B"];
    self.nickname.text = model.userName;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.userHeadImg]];
    [self.headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_avatar_default"]];
    if (ISNULLSTR(model.note)) {
//        self.noteLabel.text = @"什么都没写，懒懒懒";
    } else {
        self.noteLabel.text = model.note;
    }
    self.setupBtn.hidden = !model.isFriend;
  
  NSURL *backgroundURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,model.bgImg]];
  
  [self.backImg sd_setImageWithURL:backgroundURL placeholderImage:[UIImage imageNamed:@"user_back_default"]];

  
}

@end
