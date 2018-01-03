//
//  SetupPasswordViewController.h
//  Dlt
//
//  Created by USER on 2017/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "BaseVC.h"
typedef NS_ENUM(NSInteger, CHANGESELETYPE)
{
    CHANGESELETYPESETUP=0,
    CHANGESELETYPECHANGE=1

};
@interface SetupPasswordViewController : BaseVC
@property(nonatomic,assign)CHANGESELETYPE changeType;
@end
