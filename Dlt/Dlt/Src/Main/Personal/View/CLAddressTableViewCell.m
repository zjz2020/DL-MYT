//
//  CLAddressTableViewCell.m
//  FireProduct
//
//  Created by USER on 2017/5/2.
//  Copyright © 2017年 huoban. All rights reserved.
//

#import "CLAddressTableViewCell.h"

@implementation CLAddressTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        if (self)
        {
            [self crecateMyCell];
        }
    }
    return self;
}

- (void)crecateMyCell
{
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLabel];
    
    self.phoneLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.phoneLabel];
    self.lineLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:self.lineLabel];
    self.lineLabel1 = [[UILabel alloc] init];
    [self.contentView addSubview:self.lineLabel1];
    
}

- (void)layoutSubviews
{
    
    /*
     *   @ 核心理念: 约束、参照
     *
     *   @ Masonry 中的语法问题:
     *
     *   @ mas_equalTo 和 equalTo 区别:
     *   @ mas_equalTo 后面往往是具体的"数值"
     *   @ equalTo     后面往往是"控件", "视图"
     *
     */
    
    [super layoutSubviews];
    
    //    self.nameLabel.frame = CGRectMake(16, 20, 45, 30);
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidthLFL, 10));
        
    }];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#C6C6C6"];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.size.mas_equalTo(CGSizeMake(45, 30));
         make.left.mas_equalTo(10);
         make.top.mas_equalTo(20);
     }];
    
    self.nameLabel.font = AdaptedFontSize(16);
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = 1;
    
    //    self.iconImage.frame = CGRectMake(280, 5, 55, 55);
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.size.mas_equalTo(CGSizeMake(100, 16));
         make.right.mas_equalTo(-10);
         make.top.mas_equalTo(20);
     }];
    
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    self.phoneLabel.font =AdaptedFontSize(16);
    self.phoneLabel.textColor = [UIColor blackColor];
    
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidthLFL, 0.5));
        [make.top.mas_equalTo(self.phoneLabel.mas_bottom)setOffset:21];
        make.left.mas_equalTo(10);
        
    }];
    self.lineLabel1.backgroundColor = COLOR_UNDER_LINE;
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
