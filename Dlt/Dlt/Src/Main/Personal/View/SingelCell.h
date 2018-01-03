//
//  SingelCell.h
//  Dlt
//
//  Created by USER on 2017/6/16.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface SingelCell : BABaseCell
@property(nonatomic,copy)void(^issinger)();
@property(nonatomic,strong)UILabel * singer;

-(void)file:(id)data;
@end
