//
//  DLTAssets.m
//  Dlt
//
//  Created by Gavin on 17/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTAssets.h"

@implementation DLTAssets

- (void)dealloc
{
  
}

- (instancetype)initAssetWithMediaType:(DLTAssetModelMediaType)type;
{
  self = [super init];
  if (self) {
    _mediaType = type;
  }
  return self;
}
@end
