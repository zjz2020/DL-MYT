//
//  SingelCell.h
//  Dlt
//
//  Created by USER on 2017/6/16.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface SingelCell : BABaseCell
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
@property(nonatomic,copy)void(^issinger)();
#pragma clang diagnostic pop
@property(nonatomic,strong)UILabel * singer;

-(void)file:(id)data;
@end
