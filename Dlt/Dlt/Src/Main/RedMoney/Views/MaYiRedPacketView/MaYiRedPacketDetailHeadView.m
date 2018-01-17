//
//  MaYiRedPacketHeadView.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiRedPacketDetailHeadView.h"

@interface MaYiRedPacketDetailHeadView()

@property (nonatomic , strong) UIImageView   * headImageView;
@property (nonatomic , strong) UILabel       * numLabel;
@property (nonatomic , strong) UILabel       * yuanLabel;
@property (nonatomic , strong) UILabel       * contentLabel;

@end

@implementation MaYiRedPacketDetailHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.headImageView];
        [self.headImageView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-50));
            make.left.equalTo(@(10));
            make.height.equalTo(@(40));
            make.width.equalTo(@(100));
        }];
        
        [self.headImageView addSubview:self.yuanLabel];
        [self.yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.numLabel.mas_bottom);
            make.left.equalTo(self.numLabel.mas_right);
            make.height.equalTo(@(40));
            make.width.equalTo(@(40));
        }];
        
        [self.headImageView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-22));
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.height.equalTo(@(20));
            make.width.equalTo(@(150));
        }];
    }
    return self;
}

-(void)setNum:(NSString *)num{
    _num = num;
    _numLabel.text = num;
    
    CGRect numSize =[num boundingRectWithSize:CGSizeMake(250,45)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45]} context:nil];
    
    CGRect yuanSize =[@"元" boundingRectWithSize:CGSizeMake(40,40)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
    
    [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((kScreenWidth - numSize.size.width - yuanSize.size.width)/2));
        make.width.equalTo(@(numSize.size.width));
        make.height.equalTo(@(numSize.size.height-15));
    }];
    
    [self.yuanLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(yuanSize.size.height));
        make.width.equalTo(@(yuanSize.size.width));
    }];
}

-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.97)];
        _headImageView.image = [UIImage imageNamed:@"mayi_redPacketDetail_head"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLabel.textColor = SDColor(255, 255, 255, 1);
        _numLabel.font = [UIFont systemFontOfSize:45];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

-(UILabel *)yuanLabel{
    if(!_yuanLabel){
        _yuanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _yuanLabel.textColor = SDColor(255, 255, 255, 1);
        _yuanLabel.font = [UIFont systemFontOfSize:20];
        _yuanLabel.text = @"元";
        _yuanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _yuanLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = SDColor(255, 241, 0, 1);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"你已累计抢到红包";
    }
    return _contentLabel;
}

@end
