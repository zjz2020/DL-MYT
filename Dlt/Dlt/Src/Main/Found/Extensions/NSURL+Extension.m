//
//  NSURL+Extension.m
//  Dlt
//
//  Created by Gavin on 2017/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "NSURL+Extension.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>

@implementation NSURL (Extension)

- (void)ui_removeImageCache {
  NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:self];
  if (cacheKey) {
    [[SDImageCache sharedImageCache] removeImageForKey:cacheKey];
  }
}

@end
