//
//  MaYiRedPacketDetailCell.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiRedPacketDetailCell.h"

@interface MaYiRedPacketDetailCell()

@property (nonatomic , strong) UILabel         * kindLabel;   //红包类型
@property (nonatomic , strong) UILabel         * timeLabel;   //红包时间
@property (nonatomic , strong) UILabel         * numLabel;    //红包金额
@property (nonatomic , strong) UIView          * lineView;    //线

@end

@implementation MaYiRedPacketDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self addSubview:self.kindLabel];
        [self.kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.left.equalTo(@(10));
            make.height.equalTo(@(20));
            make.width.equalTo(@(200));
        }];
        
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kindLabel.mas_bottom);
            make.left.equalTo(self.kindLabel.mas_left);
            make.height.equalTo(@(20));
            make.width.equalTo(@(200));
        }];
        
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(@(-10));
            make.height.equalTo(@(60));
            make.width.equalTo(@(150));
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-1));
            make.right.equalTo(@(0));
            make.left.equalTo(@(0));
            make.height.equalTo(@(1));
        }];
    }
    return self;
}
- (void)setRedListModel:(MYRedListModel *)redListModel{
    _redListModel = redListModel;
    self.timeLabel.text = [self backTimeStringWithTime:redListModel.ctimeStr];
    CGFloat num = [redListModel.amount integerValue]/100;
    NSString *money = [NSString stringWithFormat:@"+%.2f",num];
    self.numLabel.text = money;
}
- (NSString *)backTimeStringWithTime:(NSString *)time{
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    time = [time stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    time = [time stringByReplacingCharactersInRange:NSMakeRange(10,1) withString:@"日 "];
    return time;
}
-(UILabel *)kindLabel{
    if(!_kindLabel){
        _kindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _kindLabel.textColor = SDColor(44, 44, 44, 1);
        _kindLabel.font = [UIFont systemFontOfSize:17];
        _kindLabel.text = @"红包";
    }
    return _kindLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = SDColor(153, 153, 153, 1);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"2017年5月13日 18:30";
    }
    return _timeLabel;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLabel.textColor = SDColor(44, 44, 44, 1);
        _numLabel.font = [UIFont systemFontOfSize:17];
        _numLabel.text = @"+5.00";
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = SDColor(232, 232, 232, 1);
    }
    return _lineView;
}

@end
