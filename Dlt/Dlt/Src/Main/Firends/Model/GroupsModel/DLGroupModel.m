//
//  DLGroupModel.m
//  Dlt
//
//  Created by Liuquan on 17/6/5.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupModel.h"

@implementation DLGroupModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : DLGroupInfo.class
             };
}
@end



@implementation DLGroupInfo

@end
