//
//  DltCircleoffriendToolbar.h
//  Dlt
//
//  Created by Gavin on 17/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTInputView.h"
#import "YZEmotionKeyboard.h"
#import "UITextView+YZEmotion.h"

@class DltCircleoffriendToolbar;

@protocol DltCircleoffriendToolbarDelegate <NSObject>

@optional
- (void)circleoffriendToolbar:(DltCircleoffriendToolbar *)toolbar textHeightDidChange:(CGFloat)changeHeigth;
- (void)circleoffriendToolbar:(DltCircleoffriendToolbar *)toolbar keyboardWillChange:(NSNotification *)notification isWillShow:(BOOL)isShow;

- (void)circleoffriendToolbar:(DltCircleoffriendToolbar *)toolbar didClickedEmotion:(CGFloat)buttonType;

@end

@interface DltCircleoffriendToolbar : UIView

@property (nonatomic ,weak) id<DltCircleoffriendToolbarDelegate>delegate;

@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;
@property (nonatomic ,weak) DLTInputView *textView;


@property (nonatomic ,assign ,getter=isShowEmotionButton) BOOL showEmotionButton;

@end
