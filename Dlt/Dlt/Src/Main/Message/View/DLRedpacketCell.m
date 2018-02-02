//
//  DLRedpacketCell.m
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLRedpacketCell.h"
#import "DLRedpacketMessage.h"

#define kRedpacketH   87


@interface DLRedpacketCell ()

@property (nonatomic, strong) UIImageView *redpacketImage;

/// 红包备注label
@property (nonatomic, strong) UILabel *remarksLabel;

/// 领取/查看红包
@property (nonatomic, strong) UILabel *redpacketState;

@property (nonatomic, strong) RCMessageModel *msgModel;

@end


@implementation DLRedpacketCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize {
    self.redpacketImage = [[UIImageView alloc] init];
    [self.messageContentView addSubview:self.redpacketImage];
    
    self.remarksLabel = [[UILabel alloc] init];
    self.remarksLabel.textColor = [UIColor whiteColor];
    self.remarksLabel.font = [UIFont systemFontOfSize:14];
    self.remarksLabel.text = @"恭喜发财，大吉大利";
    [self.messageContentView addSubview:self.remarksLabel];
    
    self.redpacketState = [[UILabel alloc] init];
    self.redpacketState.font = [UIFont systemFontOfSize:12];
    self.redpacketState.textColor = [UIColor whiteColor];
    self.redpacketState.text = @"领取红包";
    [self.messageContentView addSubview:self.redpacketState];
    
    /// 添加点击tap
    self.redpacketImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(robRedpacketAction:)];
    [self.redpacketImage addGestureRecognizer:tapges];
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    self.msgModel = model;
    if ([model.content isMemberOfClass:[DLRedpacketMessage class]]) {
        DLRedpacketMessage *msgModel = (DLRedpacketMessage *)model.content;
        NSString *url = [NSString stringWithFormat:@"%@Wallet/redpacketInfo",BASE_URL];
        NSDictionary *params = @{
                                 @"token" : [DLTUserCenter userCenter].token,
                                 @"uid" : [DLTUserCenter userCenter].curUser.uid,
                                 @"rpId" : msgModel.packetId
                                 };
        [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
            NSLog(@"%@",[response valueForKey:@"msg"]);
            if ([response[@"code"] integerValue] == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(response[@"data"]){
                        NSDictionary  * dic = response[@"data"];
                        if(dic){
                            if ([dic[@"isGet"] integerValue] == 1) {
                                self.redpacketState.text = @"红包已被领取";
                            }
                            if ([dic[@"expired"] integerValue] == 1) {
                                self.redpacketState.text = @"红包已过期";
                            }
                        }
                    }
                });
            } else {
               
            }
        }failureBlock:^(NSError *error) {
        } progress:nil];
        NSString *friendRedurl = [NSString stringWithFormat:@"%@Wallet/friendRedpacketInfo",BASE_URL];
        [BANetManager ba_request_POSTWithUrlString:friendRedurl parameters:params successBlock:^(id response) {
            NSLog(@"%@",[response valueForKey:@"msg"]);
            if ([response[@"code"] integerValue] == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(response[@"data"]){
                        NSDictionary  * dic = response[@"data"];
                        if(dic){
                            if ([dic[@"isGet"] integerValue] == 1) {
                                self.redpacketState.text = @"红包已被领取";
                            }
                            if ([dic[@"expired"] integerValue] == 1) {
                                self.redpacketState.text = @"红包已过期";
                            }
                        }
                    }
                });
            } else {
                
            }
        }failureBlock:^(NSError *error) {
        } progress:nil];
        self.remarksLabel.text = msgModel.content;
    }
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    if (MessageDirection_SEND == self.messageDirection) {
        self.redpacketImage.image = [UIImage imageNamed:@"ic_bigred_02"];
        self.redpacketImage.frame =  CGRectMake(0, 0, self.messageContentView.frame.size.width, kRedpacketH);
        self.remarksLabel.frame = CGRectMake(50, 15, self.messageContentView.frame.size.width - 50, 20);
        self.redpacketState.frame = CGRectMake(self.remarksLabel.frame.origin.x, CGRectGetMaxY(self.remarksLabel.frame) + 3, self.messageContentView.frame.size.width - 50, 15);
    } else {
        self.redpacketImage.image = [UIImage imageNamed:@"ic_bigred_00"];
        self.redpacketImage.frame =  CGRectMake(0, 0, self.messageContentView.frame.size.width, kRedpacketH);
        self.remarksLabel.frame = CGRectMake(55, 15, self.messageContentView.frame.size.width - 55, 20);
        self.redpacketState.frame = CGRectMake(self.remarksLabel.frame.origin.x, CGRectGetMaxY(self.remarksLabel.frame) + 3, self.messageContentView.frame.size.width - 55, 15);
    }
}
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, kRedpacketH + extraHeight);
}

- (void)robRedpacketAction:(UITapGestureRecognizer *)tapGes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.msgModel];
    }
}



@end
