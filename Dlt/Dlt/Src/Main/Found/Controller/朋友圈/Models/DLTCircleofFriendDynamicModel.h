//
//  DLTCircleofFriendDynamicModel.h
//  Dlt
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLTModel.h"

@class DLTCircleofFriendDynamicLikeModel, DLTCircleofFriendDynamicCommentModel;

@interface DLTCircleofFriendDynamicModel : DLTModel

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *imgs;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, strong) NSDate *timeStampDate;

@property (nonatomic, strong) NSArray<NSString *> *picNames;
@property (nonatomic, strong) NSMutableArray<DLTCircleofFriendDynamicLikeModel *> *likes;
@property (nonatomic, strong ) NSArray<DLTCircleofFriendDynamicCommentModel *> *comments;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, assign, readonly ) BOOL shouldShowMoreButton;
@property (nonatomic, assign ) BOOL hiddenOperationMoreButton; // Default YES.

@end

@interface DLTCircleofFriendDynamicLikeModel : DLTModel

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *uid;

@end


@interface DLTCircleofFriendDynamicCommentModel : DLTModel

@property (nonatomic, copy) NSString *acId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *userImg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *toId;
@property (nonatomic, copy) NSString *toUserName;
@property (nonatomic, copy) NSString *birthdayStamp;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createTimeStamp;

@property (nonatomic, copy) NSString *age;
@property (nonatomic, assign,getter=isBoy,readonly) BOOL boy;

@property (nonatomic, copy) NSString *combineUserName; // 在userName 加上 Gavin:

@end

/**
 类目
 */
@interface DLTCircleofFriendDynamicModel (Calculate)

@property (nonatomic, strong) NSValue *contentSize;

@end

@interface DLTCircleofFriendDynamicCommentModel (Calculate)

@property (nonatomic, strong) NSValue *commentSize; // 在朋友圈里面
@property (nonatomic, strong) NSValue *commentDetailsSize;

@end
