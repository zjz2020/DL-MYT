//
//  DLCostTableViewCell.m
//  Dlt
//
//  Created by USER on 2017/9/22.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLCostTableViewCell.h"
#import "RCHttpTools.h"
@implementation DLCostTableViewCell
{
    UIImageView *_payImage ;
    UILabel *_payLabel;
    UILabel *_downLable;
    UIImageView *_stateImage;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }return self;
}
-(void)setUp{
    _payImage = [UIImageView new];
    _payLabel = [UILabel new];
    _downLable = [UILabel new];
    _downLable.textColor = [UIColor grayColor];
    _downLable.font = [UIFont systemFontOfSize:14];
    _stateImage = [UIImageView new];
    [self.contentView sd_addSubviews:@[_payImage,_payLabel,_downLable,_stateImage]];
    _payImage.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(40)
    .widthIs(40);
    _payLabel.sd_layout
    .topEqualToView(_payImage)
    .heightIs(20)
    .leftSpaceToView(_payImage, 10);
    [_payLabel setSingleLineAutoResizeWithMaxWidth:200];
    _downLable.sd_layout
    .bottomEqualToView(_payImage)
    .heightIs(15)
    .leftEqualToView(_payLabel);
    [_downLable setSingleLineAutoResizeWithMaxWidth:300];
    _stateImage.sd_layout
    .centerYEqualToView(_payImage)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20)
    .widthIs(20);
    _stateImage.image = [UIImage imageNamed:@"stateNo"];
}
-(void)setRow:(int)row{
    if (row == 0) {
        _payImage.image = [UIImage imageNamed:@"yue"];
        _payLabel.text = @"余额支付";
        [[RCHttpTools shareInstance] checkMyBalances:^(NSString *myBalances) {
            _downLable.text = [NSString stringWithFormat:@"可用余额：%.2f",[myBalances floatValue]  / 100.0];
        }];
        
    }else if (row == 1){
        _payImage.image = [UIImage imageNamed:@"zhifubao"];
        _payLabel.text = @"支付宝支付";
        _downLable.text = @"推荐使用支付宝支付";
        
    }else{
        _payImage.image = [UIImage imageNamed:@"weixin"];
        _payLabel.text = @"微信支付";
        _downLable.text = @"推荐安装微信5.0及以上版本使用";
        
    }
}
-(void)setIsSeleced:(BOOL)isSeleced{
    if (isSeleced) {
        _stateImage.image = [UIImage imageNamed:@"stateYes"];
    }else{
        _stateImage.image = [UIImage imageNamed:@"stateNo"];
    }
}
@end
