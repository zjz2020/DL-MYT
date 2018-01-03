//
//  DLTAntColonyAndNoviceGuideViewController.h
//  Dlt
//
//  Created by Gavin on 2017/6/9.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DltBaseViewController.h"

typedef NS_ENUM(NSInteger, DLTAntColonyAndNoviceGuideType){
  DLTAntColonyAndNoviceGuideTypeAntColony   = 0,  // 蚂蚁群
  DLTAntColonyAndNoviceGuideTypeNoviceGuide = 1   // 新手引导
};

@interface DLTAntColonyAndNoviceGuideViewController : DltBaseViewController {
  @private
    DLTAntColonyAndNoviceGuideType _type;
}

- (instancetype)initAntColonyAndNoviceGuideViewControllerWithType:(DLTAntColonyAndNoviceGuideType)type NS_DESIGNATED_INITIALIZER;

@end
