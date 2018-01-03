//
//  DLTCircleofFriendDynamicModel.m
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTCircleofFriendDynamicModel.h"
#import "objc/runtime.h"

#import "DltEmoUtils.h"

CGFloat contentLabelFontSize,maxContentLabelHeight;

@implementation DLTCircleofFriendDynamicModel

@synthesize text = _text;

- (instancetype)init
{
  self = [super init];
  if (self) {
    _hiddenOperationMoreButton = YES;
  }
  return self;
}

- (void)setImgs:(NSString *)imgs{
  _imgs = imgs;
  
  if (imgs.length > 0) {
    NSArray *components = [imgs componentsSeparatedByString:@";"];
    if (components.count > 9) {
      NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 9)];
      self.picNames = [components objectsAtIndexes:set];
    }
    else{
      self.picNames = components;
    }
  }
}

- (void)setText:(NSString *)text{
  _text = text;
  
  CGFloat contentWidth = kScreenWidth - 2*15;
  self.contentSize = [NSValue valueWithCGSize:[DltEmoUtils getM80LabelHeight:contentWidth withSourceString:text]];
  
}

- (BOOL)shouldShowMoreButton{
  return self.comments.count > 3;
}

- (void)setTimeStamp:(NSString *)timeStamp{
  _timeStamp = timeStamp;
  
  if (timeStamp.length > 0) {
    self.timeStampDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
  }
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{@"comments":@"comment",
           @"likes":@"Zan"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"likes":[DLTCircleofFriendDynamicLikeModel class],
           @"comments":[DLTCircleofFriendDynamicCommentModel class]};
}


@end

@implementation DLTCircleofFriendDynamicLikeModel


@end

@implementation DLTCircleofFriendDynamicCommentModel

- (NSString *)combineUserName{
  if (self.userName.length == 0) return @"";
  return [NSString stringWithFormat:@"%@: ",self.userName];
}

- (NSString *)age{
  return [self.birthday userBirthdayWithTimeIntervalSince1970];
}

- (void)setSex:(NSString *)sex{
 _sex = ([sex intValue] == 1)? @"男" : @"女";
}

- (BOOL)isBoy{
  return [self.sex isEqualToString:@"男"];
}

@end



static char contentSizeKey;

@implementation  DLTCircleofFriendDynamicModel (Calculate)

- (NSValue *)contentSize{
  return objc_getAssociatedObject(self, &contentSizeKey);
}

- (void)setContentSize:(NSValue *)contentSize{
  if (!contentSize) return;
   objc_setAssociatedObject(self, &contentSizeKey, contentSize, OBJC_ASSOCIATION_RETAIN);
}

@end

static char commentSizeKey;
static char commentDetailsSizeKey;

@implementation  DLTCircleofFriendDynamicCommentModel (Calculate)

- (NSValue *)commentSize{
  NSValue *value = objc_getAssociatedObject(self, &commentSizeKey);
  if (!value && self) {
    CGFloat contentWidth = kScreenWidth - 2*15;
   value = [NSValue valueWithCGSize:[DltEmoUtils getCommoneHeight:contentWidth withTimeLineCellCommentItemModel:self]];
  }
  
  return value;
}

- (void)setCommentSize:(NSValue *)commentSize {
  if (!commentSize) return;
  objc_setAssociatedObject(self, &commentSizeKey, commentSize, OBJC_ASSOCIATION_RETAIN);
}


// --
- (NSValue *)commentDetailsSize{
  NSValue *value = objc_getAssociatedObject(self, &commentDetailsSizeKey);
  if (!value && self.text.length > 0) {
    CGFloat contentWidth = kScreenWidth - 3*15;
    value = [NSValue valueWithCGSize:[DltEmoUtils getM80LabelHeight:contentWidth withSourceString:self.text]];
  }
  
  return value;
}

- (void)setCommentDetailsSize:(NSValue *)commentDetailsSize {
  if (!commentDetailsSize) return;
  objc_setAssociatedObject(self, &commentDetailsSizeKey, commentDetailsSize, OBJC_ASSOCIATION_RETAIN);
}


@end


