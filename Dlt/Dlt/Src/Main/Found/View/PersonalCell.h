//
//  PersonalCell.h
//  Dlt
//
//  Created by USER on 2017/5/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"

@interface PersonalCell : BABaseCell
@property (nonatomic, strong) DLTUserProfile *userinfo;
@property(nonatomic,strong)UIImageView * myIcon;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * mytNumbel;
@end
