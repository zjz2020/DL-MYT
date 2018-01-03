//
//  DLPasswordInputView.h
//  Dlt
//
//  Created by Liuquan on 17/6/8.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLPasswordInputView;

@protocol DLPasswordInputViewDelegate <NSObject>
@optional
- (void)passwordInputView:(DLPasswordInputView *)passwordInputView inputPasswordText:(NSString *)password;
@end


@interface DLPasswordInputView : UIView

@property (nonatomic, weak) id<DLPasswordInputViewDelegate>delegate;

@property (nonatomic, strong) NSString *money;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (DLPasswordInputView *)initInputView;

- (void)popAnimationView:(UIView *)supView;

@end
