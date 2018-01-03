//
//  SDWeiXinPhotoContainerView.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 16/12/23.
//  Copyright © 2016年 gsd. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "DltUICommon.h"

typedef NS_ENUM(NSInteger, SDWeiXinPhotoContainerViewType){
  SDWeiXinPhotoContainerViewTypeDefault,    // 默认
  SDWeiXinPhotoContainerViewTypeDetails    // 详情
};

@interface SDWeiXinPhotoContainerView : UIView

- (instancetype)initWithPhotoContainerView:(SDWeiXinPhotoContainerViewType)type DLT_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray *picPathStringsArray;

- (void)prepareForReuse;

@end
