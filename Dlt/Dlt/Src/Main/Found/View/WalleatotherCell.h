//
//  WalleatotherCell.h
//  Dlt
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface WalleatotherCell : BABaseCell
@property(nonatomic,copy)void(^transferClick)(UIButton * btn);
@property(nonatomic,copy)void(^topupClick)(UIButton * btn);
@property(nonatomic,copy)void(^wageClick)(UIButton * btn);

@end
