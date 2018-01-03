//
//  TopUpCell.h
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface TopUpCell : BABaseCell<UITextFieldDelegate>
@property(nonatomic,strong)void(^ismoneyClick)(UITextField * text);

@end
