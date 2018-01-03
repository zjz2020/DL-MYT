//
//  DLTTextView.h
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTTextView : UITextView

@property (nonatomic , copy) NSString *placeholder;
@property (nonatomic , strong) UIColor *placeholderColor;

- (void)resetTextView;

@end
