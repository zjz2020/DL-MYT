//
//  DltEmoUtils.h
//  Dlt
//
//  Created by Gavin on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <M80AttributedLabel/M80AttributedLabel.h>
#import "DLTCircleofFriendDynamicModel.h"

@interface DltEmoUtils : NSObject

+ (M80AttributedLabel *)match:(NSString *)source;

+ (CGSize)getM80LabelHeight:(CGFloat)width
          withSourceString:(NSString *)source;
+ (CGSize)getCommoneHeight:(CGFloat)width
          withTimeLineCellCommentItemModel:(DLTCircleofFriendDynamicCommentModel *)model;

+ (void)drawM80Label:(M80AttributedLabel *)label withSourceString:(NSString *)source;
+ (void)drawCommoneM80Label:(M80AttributedLabel *)label withTimeLineCellCommentItemModel:(DLTCircleofFriendDynamicCommentModel *)source;

@end
