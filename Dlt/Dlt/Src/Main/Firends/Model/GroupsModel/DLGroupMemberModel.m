//
//  DLGroupMemberModel.m
//  Dlt
//
//  Created by Liuquan on 17/6/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupMemberModel.h"

@implementation DLGroupMemberModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : DLGroupMemberInfo.class
             };
}
@end

@implementation DLGroupMemberInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSetManager = NO;
    }
    return self;
}

@end
