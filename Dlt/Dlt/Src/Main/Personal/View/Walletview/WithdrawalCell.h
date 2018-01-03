//
//  WithdrawalCell.h
//  Dlt
//
//  Created by USER on 2017/5/30.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BABaseCell.h"
@class WithdrawalCell;

@protocol WithdrawalCellDelegate <NSObject>
@optional
- (void)withdrawalCell:(WithdrawalCell *)cell clickAllWithFrawalButtonAction:(NSString *)myblance;
- (void)withdrawalCell:(WithdrawalCell *)cell inputFinishAccomt:(NSString *)accomt;
@end


@interface WithdrawalCell : BABaseCell<UITextFieldDelegate>
@property (nonatomic, weak) id<WithdrawalCellDelegate>withdrawalDelegate;
@property(nonatomic,strong) UILabel *transmoney;
@property (nonatomic, copy) NSString *blances;
@property(nonatomic,strong) UITextField *moneyFiled;
@end
