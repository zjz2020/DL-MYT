//
//  DLCInputPasswordView.h
//
//  Created by Liuquan on 16/8/24.
//  Copyright © 2016年 com.grsf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLCInputPasswordView;
@protocol DLCInputPasswordViewDelegate <NSObject>

-(void)inputPasswordViewDelegate:(DLCInputPasswordView *)inputPasswordView inputEndWithPassword:(NSString *)inputEndWithPassword;

@end


@interface DLCInputPasswordView : UIView

@property (nonatomic,weak)  id<DLCInputPasswordViewDelegate> delegate ;

@property (nonatomic, strong) UITextField *textField;


@end
