//
//  TransferCell.h
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface TransferCell : BABaseCell
@property(nonatomic,strong)UILabel * myName;
@property(nonatomic,strong)UIImageView * myIcon;

@property(nonatomic,strong)void(^moneyClick)(UITextField * text);
@property(nonatomic,strong)void(^psClick)(UITextField * text);

@end
