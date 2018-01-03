//
//  DLTGreatgodPhotoContainerView.m
//  Dlt
//
//  Created by Gavin on 17/6/4.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTGreatgodPhotoContainerView.h"
#import "DltUICommon.h"

#define kConcernPhotoMaxCoun 3
#define kItemSpacing 10


@interface DLTGreatgodPhotoContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation DLTGreatgodPhotoContainerView

- (void)prepareForReuse{
  for (int i = 0;  i < self->_picPathStringsArray.count ; i++) {
    @autoreleasepool{
      UIImageView *imageView = [self->_imageViewsArray objectAtIndex:i];
      [imageView cancelCurrentImageRequest];
    }
  }
}


- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self _initialize];
  }
  return self;
}


- (void)_initialize{
  NSMutableArray *temp = [NSMutableArray new];
  
  for (int i = 0; i < kConcernPhotoMaxCoun; i++) {
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = rgb(215, 215, 215);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [imageView ui_imageViewAddGestureRecognizerTarget:self
                                               action:@selector(tapImageView:)];
    imageView.tag = i;
    [temp addObject:imageView];
  }
  
  self.imageViewsArray = [temp copy];
}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
  UIView *imageView = tap.view;
  if (self.DLTGreatgodPhotoContainerBlock) {
    self.DLTGreatgodPhotoContainerBlock(self.picPathStringsArray,self.imageViewsArray,imageView.tag);
  }
}

- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray{
  _picPathStringsArray = picPathStringsArray;
    
  for (long i = picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
    UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
    imageView.hidden = YES;
  }
  
  @weakify(self);
  [picPathStringsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       @strongify(self);
    UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
    imageView.hidden = NO;
    
    if (obj.length > 0) {
      NSString *iconStr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,obj];
      [imageView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    }

    switch (picPathStringsArray.count) {
      case 1:
        [self layoutImageViewStyle01:imageView ];
        break;
     case 2:
        [self layoutImageViewStyle02:imageView ];
        break;
     case 3:
        [self layoutImageViewStyle03:imageView ];
        break;
      default:
        break;
    }
  }];
  
}


- (void)layoutImageViewStyle01:(UIImageView *)imageView {
  imageView.frame = (CGRect){CGPointZero,self.height,self.height};
}

- (void)layoutImageViewStyle02:(UIImageView *)imageView{
   NSInteger index = imageView.tag;
  
  CGFloat itemW = (self.width - kItemSpacing)/2;
  if (index == 0) {
    imageView.frame = (CGRect){CGPointZero,itemW,self.height};
  }
  
  if (index == 1) {
    imageView.frame = (CGRect){itemW + kItemSpacing,0,itemW,self.height};
  }
}

- (void)layoutImageViewStyle03:(UIImageView *)imageView{
   NSInteger index = imageView.tag;
  
  CGFloat minItemW = self.width - self.height - kItemSpacing;
  CGFloat minItemH = (self.height - kItemSpacing)/2;
  
  if (index == 0) {
     imageView.frame = (CGRect){CGPointZero,self.height,self.height};
  }
  
  if (index == 1) {
    imageView.frame = (CGRect){self.height + kItemSpacing,0,minItemW,minItemH};
  }
  
  if (index == 2) {
    imageView.frame = (CGRect){self.height + kItemSpacing, minItemH + kItemSpacing,minItemW,minItemH};
  }
  
}


@end
