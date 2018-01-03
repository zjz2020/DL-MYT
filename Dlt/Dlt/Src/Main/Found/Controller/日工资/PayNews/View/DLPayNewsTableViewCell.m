//
//  DLPayNewsTableViewCell.m
//  Dlt
//
//  Created by USER on 2017/9/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLPayNewsTableViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
@implementation DLPayNewsTableViewCell
{
    UILabel *_topLabel;
    UILabel *_downLabel;
    UILabel *_timeLabel;
    UIImageView *_imageView;
    UILabel *_typeLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }return self;
}
-(void)setUp{
    self.contentView.backgroundColor = UICOLORRGB(232, 232, 232, 1.0);
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor whiteColor];
    _topLabel = [UILabel new];
    _topLabel.font = [UIFont systemFontOfSize:17];
    _downLabel = [UILabel new];
    _downLabel.font = [UIFont systemFontOfSize:14];
    _downLabel.textColor = [UIColor grayColor];
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor grayColor];
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"bc_05.png"];
    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.font = [UIFont systemFontOfSize:14];
    [mainView sd_addSubviews:@[_imageView,_typeLabel,_timeLabel,_topLabel,_downLabel]];
   _imageView.sd_layout
    .topSpaceToView(mainView, 10)
    .leftSpaceToView(mainView, 10)
    .heightIs(30)
    .widthIs(30);
    _typeLabel.sd_layout
    .topEqualToView(_imageView)
    .leftSpaceToView(_imageView, 10)
    .heightIs(15);
    [_typeLabel setSingleLineAutoResizeWithMaxWidth:200];
    _timeLabel.sd_layout
    .topSpaceToView(_typeLabel, 0)
    .leftEqualToView(_typeLabel)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
   
    _topLabel.sd_layout
    .topSpaceToView(_timeLabel, 25)
    .leftEqualToView(_timeLabel)
    .rightSpaceToView(mainView, 0)
    .autoHeightRatio(0);
    _downLabel.sd_layout
    .topSpaceToView(_topLabel, 10)
    .leftEqualToView(_timeLabel)
    .heightIs(20)
    .rightSpaceToView(mainView, 0);
    
    [self.contentView addSubview:mainView];
    mainView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
}
-(void)setStatus:(RCMessage *)status{
    _status = status;
    RCTextMessage *model = (RCTextMessage *) status.content;
    NSArray *array = [model.content componentsSeparatedByString:@";"];
  
    if (array.count >2) {
        _typeLabel.text = array[0];
        _topLabel.text = array[1];
        _downLabel.text = array[2];
    }else if(array.count == 2){
        _typeLabel.text = array[0];
        _topLabel.text = array[1];
    }else{
        _topLabel.text = model.content;
    }
    
    if (_topLabel.text.length > 20) {
        _topLabel.sd_layout
        .topSpaceToView(_timeLabel, 15);
        _topLabel.font = [UIFont systemFontOfSize:15];
    }else{
        _topLabel.sd_layout
        .topSpaceToView(_timeLabel, 25);
        _topLabel.font = [UIFont systemFontOfSize:17];
    }
    _timeLabel.text = [self messageReceiveTime:status.sentTime];
  
}
- (NSString *)messageReceiveTime:(NSInteger)reciveTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:reciveTime/1000];
    NSString *timeString = [[self stringFromDate:date] substringToIndex:10];
    NSString *temp = [self getyyyymmdd];
    NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
    if ([timeString isEqualToString:nowDateString]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"今天 HH:mm"];
        NSString *showtimeNew = [formatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@",showtimeNew];
    }
    return [NSString stringWithFormat:@"%@",timeString];
}
-(NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}

@end
