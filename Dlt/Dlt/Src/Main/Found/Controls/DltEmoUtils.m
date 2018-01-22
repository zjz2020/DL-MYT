//
//  DltEmoUtils.m
//  Dlt
//
//  Created by Gavin on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DltEmoUtils.h"
#import "YZEmotionManager.h"

#define isEmoSourceNULL(str) (str == nil || (NSObject *)str == [NSNull null] || str.length == 0 )

static M80AttributedLabel *staticM80Label = nil;

static M80AttributedLabel *DLTtemplateAttributedLabel(){
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    staticM80Label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    staticM80Label.lineSpacing = 3.0f;
    staticM80Label.font = [UIFont systemFontOfSize:14];
  });
  [staticM80Label setText:nil];
  return staticM80Label;
};

@implementation DltEmoUtils

+ (M80AttributedLabel *)match:(NSString *)source{
 return [DltEmoUtils matchM80Label:DLTtemplateAttributedLabel() withSource:source];
}

+ (M80AttributedLabel *)matchM80Label:(M80AttributedLabel *)label withSource:(NSString *)source{
  if (!isEmoSourceNULL(source)) {
    NSRegularExpression *regular=[[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]"
                                                                      options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * array = [regular matchesInString:source
                                     options:0
                                       range:NSMakeRange(0, [source length])];
    
    __block NSInteger location = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTextCheckingResult * result = (NSTextCheckingResult *)obj;
        NSString *string = [source substringWithRange:result.range];
      
        NSString *icon = [self emotionKeyForValue:string];
       [label appendText:[source substringWithRange:NSMakeRange(location, result.range.location-location)]];
      
      if (icon != nil) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",[YZEmotionManager emotionBundleName],icon]];
        [label appendImage:image maxSize:CGSizeMake(20, 20)
                       margin:UIEdgeInsetsZero
                    alignment:M80ImageAlignmentCenter];
      }else{
        [label appendText:string];
      }
      location=result.range.location+result.range.length;
    }];
    
    regular = nil; array = nil;
    [label appendText:[source substringWithRange:NSMakeRange(location, [source length]-location)]];
    source = nil;
  }
  
  return label;
}


/**
 根据表情Value,匹配key

 */
+ (NSString *)emotionKeyForValue:(NSString *)value{
  NSArray *keys = [[YZEmotionManager emotionToTextDict] allKeysForObject:value];  
  if (keys.count) {
    return keys.firstObject;
  }
  return nil;
}

+ (CGSize)getM80LabelHeight:(CGFloat)width
           withSourceString:(NSString *)source{
  M80AttributedLabel *label = [self match:source];
  CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
  [label setText:nil];
  return size;
}

+ (CGSize)getCommoneHeight:(CGFloat)width
   withTimeLineCellCommentItemModel:(DLTCircleofFriendDynamicCommentModel *)model{
  
    M80AttributedLabel *label = DLTtemplateAttributedLabel();
  
  if (model.combineUserName.length > 0) {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:model.combineUserName];
    [attributedText m80_setFont:[UIFont systemFontOfSize:14.f]];
    [attributedText m80_setTextColor:[UIColor colorWithRed:0/255.0f green:136/255.0f blue:241/255.0f alpha:1.0]];
    
//    if (model.toUserName.length > 0) {
//      NSAttributedString *replyString = [[NSAttributedString alloc] initWithString:@"回复"
//                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                                                                                      NSForegroundColorAttributeName:[UIColor grayColor]}];
//      [attributedText appendAttributedString:replyString];
//      
//      
//      NSAttributedString *toUserNameString = [[NSAttributedString alloc] initWithString:model.toUserName
//                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                                                                     NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0f green:136/255.0f blue:241/255.0f alpha:1.0]}];
//      [attributedText appendAttributedString:toUserNameString];
//    }
    
    [label appendAttributedText:attributedText];
  }

  label = [self matchM80Label:label withSource:model.text];
  CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
  [label setText:nil];
  return size;
}



+ (void)drawM80Label:(M80AttributedLabel *)label withSourceString:(NSString *)source{
  if (!label || !source)return;
  
  [label setText:nil];
  [DltEmoUtils matchM80Label:label withSource:source];
}

+ (void)drawCommoneM80Label:(M80AttributedLabel *)label withTimeLineCellCommentItemModel:(DLTCircleofFriendDynamicCommentModel *)source{
  if (!label || !source)return;
  
   [label setText:nil];
  if (source.combineUserName.length > 0) {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:source.combineUserName];
    [attributedText m80_setFont:[UIFont systemFontOfSize:14.f]];
    [attributedText m80_setTextColor:[UIColor colorWithRed:0/255.0f green:136/255.0f blue:241/255.0f alpha:1.0]];
    
    
//    if (source.toUserName.length > 0) {
//      NSAttributedString *replyString = [[NSAttributedString alloc] initWithString:@"回复"
//                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                                                                     NSForegroundColorAttributeName:[UIColor grayColor]}];
//      [attributedText appendAttributedString:replyString];
//      
//      
//      NSAttributedString *toUserNameString = [[NSAttributedString alloc] initWithString:source.toUserName
//                                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                                                                          NSForegroundColorAttributeName:[UIColor colorWithRed:0/255.0f green:136/255.0f blue:241/255.0f alpha:1.0]}];
//      [attributedText appendAttributedString:toUserNameString];
//    }
//    
    [label appendAttributedText:attributedText];
  }

  [DltEmoUtils matchM80Label:label withSource:source.text];;
  
}

#pragma mark -
#pragma mark -  private

+ (NSArray *)getEmotionMap{
  return [YZEmotionManager emotions];
}

@end
