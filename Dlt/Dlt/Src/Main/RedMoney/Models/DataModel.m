//
//  DataModel.m
//  GDDT
//
//  Created by Fang on 2018/1/11.
//  Copyright © 2018年 Fang. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
+ (DataModel *)shareDataModelWithLatitude:(CLLocationDegrees)latitude longtude:(CLLocationDegrees)longtude{
    DataModel *model = [[DataModel alloc] init];
    model.latitude = latitude;
    model.longtude = longtude;
    return model;
};

@end
