//
//  DLMessageListCell.m
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLMessageListCell.h"

static NSString * const kMessageListCellId = @"MessageListCellId";

@interface DLMessageListCell ()


@end

@implementation DLMessageListCell

+ (instancetype)creatMessageListCellWithTableView:(UITableView *)tableView {
    DLMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageListCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DLMessageListCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 45, 45) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 45, 45);
    maskLayer.path = path.CGPath;
    self.headImg.layer.mask = maskLayer;
    
}

- (void)setDataModel:(RCConversationModel *)model {
    if (self.isFriendsRequest) {
        self.time.text = [RCKitUtility ConvertMessageTime:model.sentTime/ 1000];
        
        // 根据最后一条信息来显示
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            NSString *str = [model.lastestMessage valueForKey:@"content"];
            
            self.detail.text = str;
        } else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]) {
            self.detail.text = @"[图片]";
        } else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
            self.detail.text = @"[位置]";
        } else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
            self.detail.text = @"[语音]";
        }
        if (model.unreadMessageCount < 10) {
            self.unreadMsgCount.image = [UIImage imageNamed:[NSString stringWithFormat:@"message_%ld",(long)model.unreadMessageCount]];
        } else {
            self.unreadMsgCount.image = [UIImage imageNamed:@"message_10"];
        }
    }
}


- (void)setConversationModel:(RCConversationModel *)conversationModel {
//    _conversationModel = conversationModel;
//    
//    self.time.text = [RCKitUtility ConvertMessageTime:conversationModel.sentTime / 1000];
//   
//    // 根据最后一条信息来显示
//    if ([conversationModel.lastestMessage isKindOfClass:[RCTextMessage class]]) {
//        self.detail.text = [conversationModel.lastestMessage valueForKey:@"content"];
//    } else if ([conversationModel.lastestMessage isKindOfClass:[RCImageMessage class]]) {
//        self.detail.text = @"[图片]";
//    } else if ([conversationModel.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
//        self.detail.text = @"[位置]";
//    } else if ([conversationModel.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
//        self.detail.text = @"[语音]";
//    }
//    if (conversationModel.unreadMessageCount < 10) {
//        self.unreadMsgCount.image = [UIImage imageNamed:[NSString stringWithFormat:@"message_%ld",(long)conversationModel.unreadMessageCount]];
//    } else {
//        self.unreadMsgCount.image = [UIImage imageNamed:@"message_10"];
//    }
}

#pragma mark - 时间处理
- (NSString *)messageReceiveTime:(NSInteger)reciveTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:reciveTime/1000];
    NSString *timeString = [[self stringFromDate:date] substringToIndex:10];
    NSString *temp = [self getyyyymmdd];
    NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
    if ([timeString isEqualToString:nowDateString]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
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
