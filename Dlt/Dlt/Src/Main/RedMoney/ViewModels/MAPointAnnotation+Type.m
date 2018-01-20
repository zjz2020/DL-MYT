//
//  MAPointAnnotation+Type.m
//  GDDT
//
//  Created by Fang on 2018/1/11.
//  Copyright © 2018年 Fang. All rights reserved.
//

#import "MAPointAnnotation+Type.h"
#import <objc/runtime.h>
static  NSString *keyString = @"keyString";
static  NSString *keyString2 = @"keyString2";
static  NSString *keyString3 = @"keyString3";
static  NSString *keyString4 = @"keyString4";
static  NSString *keyString5 = @"keyString5";
static  NSString *keyString6 = @"keyString6";

@implementation MAPointAnnotation (Type)
- (void)setTypeString:(NSString *)typeString{
    objc_setAssociatedObject(self, &keyString, typeString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)typeString{
    return objc_getAssociatedObject(self, &keyString);
}
- (void)setAnnotType:(AnnotationType)annotType{
    objc_setAssociatedObject(self, &keyString2, @(annotType), OBJC_ASSOCIATION_ASSIGN);
}
- (AnnotationType)annotType{
    return [objc_getAssociatedObject(self, &keyString2) integerValue];
}
- (void)setPid:(NSString *)pid{
    objc_setAssociatedObject(self, &keyString3, pid, OBJC_ASSOCIATION_COPY);
}
- (NSString *)pid{
    return objc_getAssociatedObject(self, &keyString3);
}
- (void)setRid:(NSString *)rid{
    objc_setAssociatedObject(self, &keyString4, rid, OBJC_ASSOCIATION_COPY);
}
- (NSString *)rid{
    return objc_getAssociatedObject(self, &keyString4);
}
- (void)setRpUserIcon:(NSString *)rpUserIcon{
    objc_setAssociatedObject(self, &keyString5, rpUserIcon, OBJC_ASSOCIATION_COPY);
}
- (NSString *)rpUserIcon{
    return objc_getAssociatedObject(self, &keyString5);
}

- (void)setRpUserName:(NSString *)rpUserName{
    objc_setAssociatedObject(self, &keyString6, rpUserName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)rpUserName{
    return objc_getAssociatedObject(self, &keyString6);
}
@end
