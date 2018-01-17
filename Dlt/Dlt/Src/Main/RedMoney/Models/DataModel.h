//
//  DataModel.h
//  GDDT
//
//  Created by Fang on 2018/1/11.
//  Copyright © 2018年 Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef  NS_ENUM(NSInteger,AntType){
    AntTypeSelf = 0,//自己
    AntTypeOther,//别人
    AntTypeMoney//红包
};

@interface DataModel : NSObject
@property(nonatomic,assign) CLLocationDegrees latitude;
@property(nonatomic,assign) CLLocationDegrees longtude;
@property(nonatomic,assign) AntType   modelType;
+ (DataModel *)shareDataModelWithLatitude:(CLLocationDegrees)latitude longtude:(CLLocationDegrees)longtude;
@end
