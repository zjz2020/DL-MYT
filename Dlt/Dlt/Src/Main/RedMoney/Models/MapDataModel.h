//
//  MapDataModel.h
//  Dlt
//
//  Created by Fang on 2018/1/17.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapDataModel : NSObject
///1.查询是否是蚂蚁
+ (NSDictionary *)MapDataQueryIsAntWithController:(UIViewController *)controller;
///2.开启蚂蚁
+ (NSDictionary *)MapDataToOpenAntWithController:(UIViewController *)controller;
///3.获取周边的蚂蚁
+ (NSDictionary *)MapDataGetNearAntWithController:(UIViewController *)controller;
///4.蚂蚁用户开放状态
+ (NSDictionary *)MapDataGetAntInfoStateWithController:(UIViewController *)controller;
///5.设置蚂蚁用户信息是否公开
+ (NSDictionary *)MapDataSetAntInfoWithController:(UIViewController *)controller;
///6.领取蚂蚁红包
+ (NSDictionary *)MapDataReceiveAntMoneyWithController:(UIViewController *)controller redID:(NSString *)redid;
///7.获取用户的展示数据
+ (NSDictionary *)MapDataUserShowInfoWithController:(UIViewController *)controller;
///8.获取百度定位信息
+ (NSDictionary *)MapDataGetBaiduADCodeWithController:(UIViewController *)controller lat:(NSString *)lat lon:(NSString *)lon;
@end
