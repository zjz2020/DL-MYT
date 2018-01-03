//
//  YZEmotionKeyboard.h
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZEmotionKeyboard;

@protocol DLTEmotionKeyboardDelegate <NSObject>

@required
/**
 必须实现

 @param keyboard self
 @param content  键盘的内容.带表情字符
 */
- (void)emotionKeyboard:(YZEmotionKeyboard *)keyboard didClickedSendEmotionDescribeMessages:(NSString *)content;

@end

@interface YZEmotionKeyboard : UIView

/**
 *  作为谁的textView的输入键盘
 */
@property (nonatomic, weak) UIView *textView;

/**
 *  点击发送，会自动把文本框的内容传递过来
 */
@property (nonatomic, strong) void(^sendContent)(NSString *content);

@property (nonatomic ,weak) id<DLTEmotionKeyboardDelegate>delegate;

/**
 *  快速加载键盘控件
 *
 */
+ (instancetype)emotionKeyboard;

/**
 请求获取键盘内容, 包括表情字符.
 调用次方法的同时, 会调用代理方法- (void)emotionKeyboard:
 */
- (void)requestSendMessageContent;

@end
