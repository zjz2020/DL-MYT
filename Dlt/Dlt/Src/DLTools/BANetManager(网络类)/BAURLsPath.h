//
//  BAURLsPath.h
//  BABaseProject
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 博爱之家. All rights reserved.
//

#ifndef BAURLsPath_h
#define BAURLsPath_h


/*! 示例1：DemoVC1中的网络获取示例 */
#define KVideoPath @"http://c.m.163.com/nc/video/home/%ld-10.html"

/*! 示例2：DemoVC11中的网络获取示例 */
#define DemoVC11URLPath @"http://chanyouji.com/api/users/likes/268717.json?per_page=18&page=2"

/*! 示例3：DemoVC11中的网络获取示例    117.34.109.146：3344      */
#define DemoVC11URLPath2 @"http://chanyouji.com/api/users/likes/268717.json"

#ifdef DEBUG
//#define BASE_URL @"http://117.34.109.146:63425/api/"
//#define BASE_IMGURL  @"http://117.34.109.146:63425"

//#define BASE_URL @"http://39.108.102.255/api/"
//#define BASE_IMGURL  @"http://39.108.102.255"

//#define BASE_URL @"http://192.168.31.39/api/"
//#define BASE_IMGURL  @"http://192.168.31.39"

#define BASE_URL @"http://www.mayiton.com/api/"
#define BASE_IMGURL  @"http://www.mayiton.com"

#else
////正式
#define BASE_URL @"http://www.mayiton.com/api/"
#define BASE_IMGURL  @"http://www.mayiton.com"
#endif
#ifdef DEBUG
#define RCKKEY @"bmdehs6pbik1s"
#else
#define RCKKEY @"pkfcgjstp9u28"
#endif
#import "NSDictionary+Parser.h"

//宏定义
#define userInfoMapKey    @"userInfoMapKey"
#define userInfoMapShow   @"userInfoMapShow"
#define userInfoMapHidden @"userInfoMapHidden"
//是否显示蚂蚁
#define showMYKey      @"showMYKey"
#define showMYKeyYes   @"showMYKeyYes"
#define showMYKeyNo    @"showMYKeyNo"

#define MYUserAccount  @"MYUserAccount"
#define showMYKeyChange @"showMYKeyChange"


#define   VersionNotificationC @"VersionNotificationC"
#define   RequsetVerion        @"RequsetVerion"

#define localizable(a)  NSLocalizedString(a, nil)

#endif /* BAURLsPath_h */
