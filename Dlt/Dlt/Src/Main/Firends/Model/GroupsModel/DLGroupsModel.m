//
//  DLGroupsModel.m
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupsModel.h"

@implementation DLGroupsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : DLGroupsInfo.class
             };
}
@end


@implementation DLGroupsInfo

@end
