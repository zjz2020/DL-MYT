//
//  MaYiPersonalCardModel.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/16.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiPersonalCardModel.h"

#define __validString(x)   ((x && [x isKindOfClass:[NSString class]] && ((NSString *)x).length > 0) ? x : @"")
#define validString(x)     ([x isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%zi", [(NSNumber *)x integerValue]] : __validString(x))

@implementation MaYiPersonalCardModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        self.area = validString(dic[@"area"]);
        self.bgImgUrl  =  validString(dic[@"bgImg"]);
        self.birthDay  =  validString(dic[@"birthday"]);
        self.emotion   =  validString(dic[@"emotion"]);
        self.isFriend  =  validString(dic[@"isFriend"]);
        self.note      =  validString(dic[@"note"]);
        self.phone     =  validString(dic[@"phone"]);
        NSString *  photoStr = validString(dic[@"photos"]);
        if(photoStr && photoStr.length > 0){
            self.photosArr =  [NSMutableArray array];
            NSMutableArray * photoArr = [photoStr componentsSeparatedByString:@";"].copy;
            for(NSString * str in photoArr){
                NSString * str1 = [str substringFromIndex:1];
                NSString  * photoStr = [NSString stringWithFormat:@"%@/%@",BASE_IMGURL,str1];
                [self.photosArr addObject:photoStr];
            }
        }
        
        self.profession = validString(dic[@"profession"]);
        self.sex        = validString(dic[@"sex"]);
        NSString * headStr = [validString(dic[@"userHeadImg"]) substringFromIndex:1];
        
        self.userHeadImage = [NSString stringWithFormat:@"%@/%@",BASE_IMGURL,headStr];
        self.userName   = validString(dic[@"userName"]);
    }
    return self;
}

@end
