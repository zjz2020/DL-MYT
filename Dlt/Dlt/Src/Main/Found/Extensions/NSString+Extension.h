//
//  NSString+Extension.h
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


- (NSString *)userBirthdayWithTimeIntervalSince1970;

@end
