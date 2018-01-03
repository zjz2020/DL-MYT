//
//  TableViewCell.m
//  ImagePicker
//
//  Created by 吕超 on 16/10/11.
//  Copyright © 2016年 吕超. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "Masonry.h"

@implementation ImageTableViewCell

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
    
    self.iconImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImage];
//    self.lineLabel = [[UILabel alloc] init];
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
//    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ScreenWidthLFL, 5));
//        
//    }];
//    self.lineLabel.backgroundColor = COLOR_UNDER_LINE;
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
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
    }];
//    self.iconImage.backgroundColor = [UIColor purpleColor];
//    self.iconImage.layer.masksToBounds = YES;
//    self.iconImage.layer.cornerRadius = 6.0f;
    self.iconImage.image = [UIImage imageNamed:@"personal_00"];
    
    
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidthLFL, 10));
        [make.top.mas_equalTo(self.iconImage.mas_bottom)setOffset:5];
        make.left.mas_equalTo(10);
        
    }];
    self.lineLabel1.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    
    
    
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
