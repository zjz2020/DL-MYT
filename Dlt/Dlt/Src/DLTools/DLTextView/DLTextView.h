//
//  DLTextView.h
//  Created by Liuquan on 16/9/17.


#import <UIKit/UIKit.h>

@interface DLTextView : UITextView
/**
 *  提示文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  是否显现提示文字
 */
@property (nonatomic, assign, getter=isHiddenPlaceholder) BOOL hiddenPlaceholder;

/**
 *  提示文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
