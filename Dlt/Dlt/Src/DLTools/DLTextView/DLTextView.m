//
//  DLTextView.m

//  Created by Liuquan on 16/9/17.
//

/**----------------------------------------------------------------------------------------------
 
                            一个自定义的带提示文字的textview
                                 author  liuquan
                                 2016 / 09 ／ 17
 
-----------------------------------------------------------------------------------------------*/
#import "DLTextView.h"
#import "DltUICommon.h"


@interface DLTextView ()

@property (nonatomic,weak) UILabel *placeholderLabel;

@end

@implementation DLTextView
/**
 *  提示文字label
 *
 *  @return label
 */
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(5,8,100,20);
        [self addSubview:label];
        _placeholderLabel = label;
    }
    
    return _placeholderLabel;
}

/**
 *   代码初始化走这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.font = [UIFont systemFontOfSize:14];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}
/**
 *  故事版 or xib 走这个方法
 */
- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    self.font = [UIFont systemFontOfSize:14];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

- (void)setHiddenPlaceholder:(BOOL)hiddenPlaceholder
{
    _hiddenPlaceholder = hiddenPlaceholder;
    
    self.placeholderLabel.hidden = hiddenPlaceholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

//- (void)layoutSubviews {
//    self.placeholderLabel.frame.origin.x = 5;
//    self.placeholderLabel.frame.origin.x = 8;
//}

- (void)textDidChange {
    
    if (!ISNULLSTR(self.text)) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
}

@end
