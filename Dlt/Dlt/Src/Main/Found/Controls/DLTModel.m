//
//  DLTModel.m
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"
#import <YYKit/YYKit.h>

@implementation DLTModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
  [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init]; return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
  return [self modelCopy];
}

- (NSUInteger)hash {
  return [self modelHash];
}

- (BOOL)isEqual:(id)object {
  return [self modelIsEqual:object];
}

- (NSString *)description {
  return [self modelDescription];
}


@end
