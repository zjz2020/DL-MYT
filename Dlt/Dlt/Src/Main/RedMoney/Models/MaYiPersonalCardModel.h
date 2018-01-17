//
//  MaYiPersonalCardModel.h
//  Dlt
//
//  Created by 陈杭 on 2018/1/16.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaYiPersonalCardModel : NSObject

@property (nonatomic, strong) NSString           * area;
@property (nonatomic, strong) NSString           * bgImgUrl;
@property (nonatomic, strong) NSString           * birthDay;
@property (nonatomic, strong) NSString           * emotion;
@property (nonatomic, strong) NSString           * isFriend;
@property (nonatomic, strong) NSString           * note;
@property (nonatomic, strong) NSString           * phone;
@property (nonatomic, strong) NSMutableArray     * photosArr;
@property (nonatomic, strong) NSString           * profession;
@property (nonatomic, strong) NSString           * sex;
@property (nonatomic, strong) NSString           * userHeadImage;
@property (nonatomic, strong) NSString           * userName;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
