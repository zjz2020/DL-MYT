//
//  VibrationandvoiceCell.h
//  Dlt
//
//  Created by USER on 2017/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface VibrationandvoiceCell : BABaseCell
-(void)file:(id)data;
@property(nonatomic,copy)void(^isonClick)(UISwitch * ison);
@end
