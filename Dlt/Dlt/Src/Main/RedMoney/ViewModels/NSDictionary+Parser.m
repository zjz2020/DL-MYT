//
//  NSDictionary+Parser.m
//  Weather
//
//  Created by suguiyang@91.com on 15-02-15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NSDictionary+Parser.h"

@implementation NSDictionary (Parser)

- (BOOL)hasValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    return (value != nil && ![value isKindOfClass:[NSNull class]]);
}

- (NSString *)stringValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value stringValue];
    }
    
    if (value != nil) {
        NSLog(@"String value for key: %@ is invalid: %@", key, [value class]);
    }
    return @"";
}

- (BOOL)booleanValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value boolValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value boolValue];
    }
    
    if (value != nil) {
        NSLog(@"Boolean value for key: %@ is invalid: %@", key, [value class]);
    }
    return NO;
}

- (NSNumber *)numberValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    
    if (value != nil) {
        NSLog(@"Number value for key: %@ is invalid: %@", key, [value class]);
    }
    return nil;
}

- (int)intValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value intValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value intValue];
    }
    
    if (value != nil) {
        NSLog(@"Int value for key: %@ is invalid: %@", key, [value class]);
    }
    return 0;
}

- (NSInteger)integerValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value integerValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value integerValue];
    }
    
    if (value != nil) {
        NSLog(@"Integer value for key: %@ is invalid: %@", key, [value class]);
    }
    return 0;
}

- (float)floatValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value floatValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value floatValue];
    }
    
    if (value != nil) {
        NSLog(@"Float value for key: %@ is invalid: %@", key, [value class]);
    }
    return 0.0;
}

- (double)doubleValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value doubleValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value doubleValue];
    }
    
    if (value != nil) {
        NSLog(@"Double value for key: %@ is invalid: %@", key, [value class]);
    }
    return 0.0;
}

- (NSDictionary *)dictValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    if (value != nil) {
        NSLog(@"Dictionary value for key: %@ is invalid: %@", key, [value class]);
    }
    return nil;
}

- (NSMutableDictionary *)mutableDictValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSMutableDictionary class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:value];
    }
    
    if (value != nil) {
        NSLog(@"Mutable dictionary value for key: %@ is invalid: %@", key, [value class]);
    }
    return nil;
}

- (NSArray *)arrayValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    if (value != nil) {
        NSLog(@"Array value for key: %@ is invalid: %@", key, [value class]);
    }
    return nil;
}

- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSMutableArray class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:value];
    }
    
    if (value != nil) {
        NSLog(@"Mutable array value for key: %@ is invalid: %@", key, [value class]);
    }
    return nil;
}
- (BOOL)judgeTokenAvaillabelWithDic:(NSDictionary *)dic{
    
    
    return YES;
}
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    NSLog(@"Exception mutating method: %@ sent to immutable object !!!", NSStringFromSelector(_cmd));
}

- (void)removeObjectForKey:(id)aKey
{
    NSLog(@"Exception mutating method: %@ sent to immutable object !!!", NSStringFromSelector(_cmd));
}

@end
