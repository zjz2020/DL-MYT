//
//  RegisterPersonDataViewController.h
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BaseVC.h"
typedef NS_ENUM(NSInteger,DLSEX)
{
    DLSEXNAN,
    DLSEXNV
};
@interface RegisterPersonDataViewController : BaseVC
@property(nonatomic,strong)NSString * token;
@property(nonatomic,strong)NSString * uid;
@property(nonatomic,strong)NSString * account;
@property(nonatomic,strong)NSString * pwd;

@property(nonatomic,assign)DLSEX sex;
@end
