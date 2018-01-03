//
//  ChangephoneCell.h
//  Dlt
//
//  Created by USER on 2017/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface ChangephoneCell : BABaseCell<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * userName;
@property(nonatomic,strong)UILabel * sexStr;
@property(nonatomic,strong)UILabel * dateStr;

-(void)filedata:(id)data;
@property(nonatomic,copy)void(^isUsername)(UITextField * name);
@property(nonatomic,copy)void(^isdate)();

@end
