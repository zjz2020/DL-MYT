//
//  PayCell.m
//  Dlt
//
//  Created by USER on 2017/5/29.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "PayCell.h"
#import "DLWalletPayModel.h"


@implementation PayCell {
    UIImageView * payImage;
    UILabel * payLabel;
    UILabel * bottem;
    UIImageView *_selectedImg;

}
- (void)file:(id)data {
    DLWalletPayModel *model = (DLWalletPayModel *)data;
    payImage.image = [UIImage imageNamed:model.icon];
    payLabel.text = model.title;
    _contentLabel.text = model.content;
    _selectedImg.image = model.isSelectedPay ? [UIImage imageNamed:@"friends_26"] : [UIImage imageNamed:@"friends_27"];
}

-(void)setLineWidth:(NSInteger)lineWidth{
    _lineWidth = lineWidth;
    [bottem setFrame:CGRectMake(10, xyzW(70) - 0.5, lineWidth, 0.5)];
}

-(void)ba_setupCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)ba_buildSubview {
    payImage = [[UIImageView alloc]initWithFrame:RectMake_LFL(15, 25/2, 40, 40)];
    [self addSubview:payImage];
    payLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 28/2, 34*4, 17)];
    payLabel.left_sd = payImage.right_sd +15;
    payLabel.font = AdaptedFontSize(17);
    [self.contentView addSubview:payLabel];
    
    _contentLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 28*8, 14)];
    _contentLabel.left_sd = payLabel.left_sd;
    _contentLabel.top_sd = payLabel.bottom_sd + 10;
    _contentLabel.font = AdaptedFontSize(14);
    _contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:_contentLabel];
    
    bottem = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 0.5)];
    bottem.top_sd = payImage.bottom_sd + 15;
    bottem.width_sd = WIDTH;
    bottem.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.contentView addSubview:bottem];
    _selectedImg = [[UIImageView alloc] init];
    _selectedImg.image = [UIImage imageNamed:@"friends_27"];
    [self.contentView addSubview:_selectedImg];
    
    [_selectedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(20);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(25);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
    }];
    
}
+(CGFloat)CellH {
    return 70;
}
@end
