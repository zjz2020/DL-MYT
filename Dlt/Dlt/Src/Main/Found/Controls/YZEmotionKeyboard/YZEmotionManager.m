//
//  YZEmotionManager.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZEmotionManager.h"
#define EmotionPath [[NSBundle mainBundle] pathForResource:@"emotion.plist" ofType:nil]

static NSArray *_emotionsArray = nil;
static NSDictionary *_emotionToTextDict = nil;

@implementation YZEmotionManager

+ (NSArray *)emotions{
  if(!_emotionsArray){
     [self emotionToTextDict];
    _emotionsArray = [NSArray arrayWithContentsOfFile:EmotionPath];
  }
  return _emotionsArray;
}

+ (NSDictionary *)emotionToTextDict{
  if (!_emotionToTextDict) {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emotionToText.plist" ofType:nil]];
    _emotionToTextDict = dict;
  }
  
  return _emotionToTextDict;
}

// 总页数
+ (NSInteger)emotionPage
{
    
    NSInteger emojiCount = [self emotions].count;
    
    return (emojiCount - 1) / emojiCountOfPage + 1;
}

+ (NSArray *)emotionsOfPage:(NSInteger)page
{
    
    NSArray *values = [self emotions];
    
    // 角标
    NSInteger loc = page * emojiCountOfPage;
    
    // 长度
    NSInteger length = emojiCountOfPage;
    
    // 总页数
    NSInteger emojiPage = [self emotionPage];
    
    if (page < 0 || page == emojiPage) {
        NSLog(@"超出页码或者页码不对");
        return nil;
    }
    
    if (page == emojiPage - 1) {
        length = values.count % emojiCountOfPage;
    }
    
    NSIndexSet *indexSets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, length)];
    
    NSArray *emotions = [values objectsAtIndexes:indexSets];
    
    return emotions;
    
}

+ (NSString *)emotionBundleName{
  return @"Emotion.bundle";
}
@end
