//
//  MAPointAnnotation+Type.h
//  GDDT
//
//  Created by Fang on 2018/1/11.
//  Copyright © 2018年 Fang. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger,AnnotationType) {
    AnnotationTypeSelf = 0,
    AnnotationTypeOther ,
    AnnotationTypeMoney
};

@interface MAPointAnnotation (Type)
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic,assign)AnnotationType annotType;
//附近人ID
@property(nonatomic, copy)NSString *pid;
//红包ID
@property(nonatomic, copy)NSString *rid;
///红包人头像
@property(nonatomic, copy)NSString *rpUserIcon;
///红包名字
@property(nonatomic, copy)NSString *rpUserName;
@end
