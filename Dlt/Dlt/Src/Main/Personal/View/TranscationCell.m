//
//  TranscationCell.m
//  Dlt
//
//  Created by USER on 2017/6/12.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "TranscationCell.h"
#import "DltUICommon.h"
#import "TransactionrecordsModel.h"


static NSString * const kTranscationCellId = @"TranscationCellId";


@interface TranscationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *count;

@end

@implementation TranscationCell

+ (instancetype)creatRecordCellWithTableView:(UITableView *)tableView {
    TranscationCell *cell = [tableView dequeueReusableCellWithIdentifier:kTranscationCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TranscationCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImg ui_setCornerRadius:22.5];
}


- (void)setModel:(TransactionrecordsinfoModel *)model {
    _model = model;
    
    self.titleLabel.text = model.tranName;
    self.time.text = model.tranTime;
    self.count.text = [model.tranType integerValue] == 1 ? [NSString stringWithFormat:@"+%.2f",[model.tranBalance floatValue] / 100] : [NSString stringWithFormat:@"-%.2f",[model.tranBalance floatValue] / 100];
    
    NSString *headImageUrl = [DLTUserCenter userCenter].curUser.userHeadImg;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,headImageUrl]] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
}

@end
