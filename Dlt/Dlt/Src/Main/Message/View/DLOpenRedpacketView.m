//
//  DLOpenRedpacketView.m
//  Dlt
//
//  Created by Liuquan on 17/6/8.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLOpenRedpacketView.h"
#import "DLRedpackerInfoModel.h"
#import "DLFriendPacketModel.h"


@interface DLOpenRedpacketView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *redpacketImgView;
@property (nonatomic, strong) UIImageView *senderImg;
@property (nonatomic, strong) UILabel *senderName;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic , assign)BOOL isBeOverdue;


@property (nonatomic, assign) BOOL isFriendRedPacket;

@end

@implementation DLOpenRedpacketView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.isFriendRedPacket = NO;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315, 385)];
    self.backView = backView;
    backView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    backView.layer.cornerRadius = 22;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [self scaleAnimationWithView:backView viewFromValue:0.5 viewToValue:1];
    
    UIImageView *redpacktetImgView = [[UIImageView alloc] initWithFrame:backView.bounds];
    redpacktetImgView.image = [UIImage imageNamed:@"redpacker_10"];
    [backView addSubview:redpacktetImgView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(15, 15, 25, 25);
    [closeBtn setImage:[UIImage imageNamed:@"redpacker_11"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeReapacketView) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    self.senderImg = headImg;
    headImg.frame = CGRectMake(0, 0, 45, 45);
    headImg.center = CGPointMake(backView.frame.size.width / 2, 52.5);
    headImg.image = [UIImage imageNamed:@"banner"];
    headImg.layer.cornerRadius = 4;
    headImg.layer.masksToBounds = YES;
    [backView addSubview:headImg];
    
    UILabel *nickName = [[UILabel alloc] init];
    self.senderName = nickName;
    nickName.frame = CGRectMake(0,CGRectGetMaxY(headImg.frame) + 10,backView.frame.size.width ,20);
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.text = @"速冻皮";
    nickName.textColor = [UIColor colorWithHexString:@"2c2c2c"];
    nickName.font = [UIFont systemFontOfSize:17];
    [backView addSubview:nickName];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.frame = CGRectMake(0,CGRectGetMaxY(nickName.frame) + 10,backView.frame.size.width ,20);
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    remarkLabel.text = @"给你发了一个红包";
    remarkLabel.textColor = [UIColor colorWithHexString:@"FFD998"];
    remarkLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:remarkLabel];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    self.typeLabel = typeLabel;
    typeLabel.frame = CGRectMake(0,CGRectGetMaxY(remarkLabel.frame) + 50,backView.frame.size.width ,50);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = @"完";
    typeLabel.textColor = [UIColor colorWithHexString:@"2c2c2c"];
    typeLabel.font = [UIFont systemFontOfSize:50];
    [backView addSubview:typeLabel];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.frame = CGRectMake(0,backView.frame.size.height - 90,backView.frame.size.width ,20);
    msgLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel = msgLabel;
    msgLabel.text = @"恭喜发财，大吉大利";
    msgLabel.textColor = [UIColor colorWithHexString:@"FFD998"];
    msgLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:msgLabel];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(15, CGRectGetMaxY(msgLabel.frame) + 20, backView.frame.size.width - 30, 25);
    [detailBtn setTitle:@"查看领取详情>" forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.detailBtn = detailBtn;
    [detailBtn addTarget:self action:@selector(checkRedpackerDetail) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:detailBtn];
    
    
    typeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRedpacket)];
    [typeLabel addGestureRecognizer:tapGes];
    
    
}


- (void)scaleAnimationWithView:(UIView *)view
                 viewFromValue:(CGFloat)fromValue
                   viewToValue:(CGFloat)tovalue {
    CABasicAnimation *animationZoomIn=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationZoomIn.duration = 0.25;
    animationZoomIn.autoreverses= NO;
    animationZoomIn.repeatCount = 1;
    animationZoomIn.fromValue = [NSNumber numberWithFloat:fromValue];;
    animationZoomIn.toValue = [NSNumber numberWithFloat:tovalue];
    animationZoomIn.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [view.layer addAnimation:animationZoomIn forKey:@"scale"];
}

- (void)setRedpackerInfo:(DLRedpackerInfo *)redpackerInfo {
    _redpackerInfo = redpackerInfo;
    
    [self.senderImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,redpackerInfo.userHeadImg]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    self.senderName.text = redpackerInfo.userName;
   
    if (redpackerInfo.expired == 1) {
        self.typeLabel.text = @"过";
        self.noteLabel.text = @"红包已过期";
        self.isBeOverdue = YES;
    }else{
        if (!redpackerInfo.isGet && redpackerInfo.remainCount != 0) {
            self.typeLabel.text = @"拆";
            self.detailBtn.hidden = YES;
        } else  {
            self.typeLabel.text = @"完";
            self.detailBtn.hidden = NO;
        }
    self.noteLabel.text = redpackerInfo.note;
    }
    
    
    self.isFriendRedPacket = NO;
    
}

- (void)setFriendPacketModel:(DLFriendPacketModel *)friendPacketModel {
    _friendPacketModel = friendPacketModel;
    if (friendPacketModel.expired == 1) {
        self.typeLabel.text = @"过";
        self.noteLabel.text = @"红包已过期";
        self.isBeOverdue = YES;
    }else{
        self.typeLabel.text = friendPacketModel.isGet ? @"完" : @"拆";
         self.noteLabel.text = friendPacketModel.note;
    }
    
    self.detailBtn.hidden = friendPacketModel.isGet ? NO : YES;
   
     [self.senderImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,friendPacketModel.userHead]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    self.senderName.text = friendPacketModel.userName;
    
    self.isFriendRedPacket = YES;
}



#pragma mark - 点击事件
- (void)closeReapacketView {
   [UIView animateWithDuration:0.25 animations:^{
       self.backView.alpha = 0;
       self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
   } completion:^(BOOL finished) {
       self.backView = nil;
       [self removeFromSuperview];
   }];
}

- (void)openRedpacket {
    if (!self.isBeOverdue) {
        
        if (self.isFriendRedPacket) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(openRedpacketView:recevieFriendRedpacket:)]) {
                [self.delegate openRedpacketView:self recevieFriendRedpacket:self.friendPacketModel];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(openRedpacketView:targetRedpacketInfo:)]) {
                [self.delegate openRedpacketView:self targetRedpacketInfo:self.redpackerInfo];
            }
        }
        
       
    }
     [self closeReapacketView];
}
- (void)checkRedpackerDetail {
    if (self.isFriendRedPacket) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(openRedpacketView:recevieFriendRedpacket:)]) {
            [self.delegate openRedpacketView:self recevieFriendRedpacket:self.friendPacketModel];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(openRedpacketView:targetRedpacketInfo:)]) {
            [self.delegate openRedpacketView:self targetRedpacketInfo:self.redpackerInfo];
        }
    }
    [self closeReapacketView];
}
@end
