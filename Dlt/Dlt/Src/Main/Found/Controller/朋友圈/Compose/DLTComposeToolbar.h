//
//  DLTComposeToolbar.h
//  Dlt
//
//  Created by Gavin on 17/5/26.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DLTComposeToolbarButtonType){
  DLTComposeToolbarButtonTypeCamera,    //照相机
  DLTComposeToolbarButtonTypePicture,   //相册
  DLTComposeToolbarButtonTypeVisible,   //是否可见
  DLTComposeToolbarButtonTypeEmotion    //表情
};

typedef NS_ENUM(NSInteger, DLTPublishDynamicVisibleType){
  DLTPublishDynamicVisibleTypePublic,    // 公开
  DLTPublishDynamicVisibleTypePrivate    // 私有的
};

@class DLTComposeToolbar;

@protocol DLTComposeToolbarDelegate <NSObject>

@optional

- (void)composeTool:(DLTComposeToolbar *)toolbar didClickedButton:(DLTComposeToolbarButtonType)buttonType;

@end

@interface DLTComposeToolbar : UIView

@property (nonatomic ,weak) id<DLTComposeToolbarDelegate>delegate;

@property (nonatomic ,assign ,getter=isShowEmotionButton) BOOL showEmotionButton;
@property (nonatomic ,assign ,getter=isVisibleType) DLTPublishDynamicVisibleType visibleType;

@end
