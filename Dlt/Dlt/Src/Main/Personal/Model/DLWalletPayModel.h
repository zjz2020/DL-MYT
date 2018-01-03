//
//  DLWalletPayModel.h
//  Dlt
//
//  Created by Liuquan on 17/6/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLWalletPayModel : DLTModel

@property(nonatomic, strong) NSString * icon;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * content;
@property(nonatomic, assign) BOOL isSelectedPay;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, strong) NSString * payType;

+ (NSArray *)paymodelInstance;

@end
