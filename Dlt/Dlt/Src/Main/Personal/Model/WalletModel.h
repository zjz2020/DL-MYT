//
//  WalletModel.h
//  Dlt
//
//  Created by USER on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"
@class WalletIinfoModel;
@interface WalletModel : DLTModel
@property(nonatomic,assign)BOOL IsSetPaypwd;
@property(nonatomic,assign)NSNumber * balance;

//@property(nonatomic,assign)WalletIinfoModel * data;

@end

@interface WalletIinfoModel : DLTModel
@property(nonatomic,assign)BOOL sex;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * headImg;
@property(nonatomic,strong)NSString * birthday;

@end
