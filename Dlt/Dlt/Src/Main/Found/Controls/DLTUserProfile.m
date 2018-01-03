//
//  DLTUserProfile.m
//  Dlt
//
//  Created by Gavin on 2017/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTUserProfile.h"

@implementation DLTUserProfile

- (void)setPhotos:(NSString *)photos{
  _photos = photos;
  
  if (photos.length > 0) {
    NSArray *components = [photos componentsSeparatedByString:@";"];
    self.photoNames = components;
  }
}

- (NSString *)uid{
  if (_uid.length == 0) {return @"";}
  return _uid;
}

@end
