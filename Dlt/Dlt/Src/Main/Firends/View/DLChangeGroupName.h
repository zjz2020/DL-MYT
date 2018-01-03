//
//  DLChangeGroupName.h
//  Dlt
//
//  Created by Liuquan on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ChangeGroupNameBlock)(NSString *note);

@interface DLChangeGroupName : UIView

@property (nonatomic, copy) ChangeGroupNameBlock groupNameBlock;

@end
