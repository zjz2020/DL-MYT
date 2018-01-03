//
//  PhotoCell.m
//  PhotoDemo
//
//  Created by mac on 15/8/31.
//  Copyright (c) 2015年 xiaowei project. All rights reserved.
//

#import "PhotoCell.h"
//#define Screen_width [UIScreen mainScreen].bounds.size.width
//#define Screen_height [UIScreen mainScreen].bounds.size.height
@interface PhotoCell ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIScrollView *scroll;

@end

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scroll.minimumZoomScale = .5;
    _scroll.maximumZoomScale = 5;
    _scroll.delegate = self;
    _scroll.directionalLockEnabled = YES;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *doubleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(doubleAction)];
    doubleTap.numberOfTapsRequired = 2;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scroll addGestureRecognizer:doubleTap];
    [_scroll addSubview:_imageView];
    [self.contentView addSubview:_scroll];
  }
  return self;
}

- (void)setImgName:(id)imgName {
  _imgName = imgName;
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _scroll.zoomScale = 1;

  UIImage *img;
  if ([_imgName isKindOfClass:[UIImageView class]]) {
    UIImageView *tempimgv = _imgName;
    img = tempimgv.image;
  } else if ([_imgName isKindOfClass:[UIImage class]]) {
    img = _imgName;
  } else if ([_imgName isKindOfClass:[NSString class]]) {
    img = [UIImage imageNamed:_imgName];
  }

  CGFloat w = img.size.width;
  CGFloat h = img.size.height;

  NSLog(@"图片的大小:w = %f  h = %f", w, h);
  _scroll.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
  _scroll.contentSize = CGSizeMake(WIDTH, h);

  _imageView.frame = CGRectMake(0, (HEIGHT - h) / 2, WIDTH, h);
  [_imageView setImage:img];
}

- (void)doubleAction {
  if (_scroll.zoomScale != 1) {
    _scroll.zoomScale = 1;
  } else {
    _scroll.zoomScale = 5;
  }
  [self contentScroller];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(CGFloat)scale {

  [self contentScroller];
}

- (void)contentScroller {
  CGRect f = _imageView.frame;
  CGSize size = _scroll.frame.size;

  if (f.size.width < size.width) {
    f.origin.x = (WIDTH - f.size.width) / 2;
  } else {
    f.origin.x = 0.0f;
  }
  if (f.size.height < size.height) {
    f.origin.y = (HEIGHT - f.size.height) / 2;
  } else {
    f.origin.y = 0.0f;
  }
  _imageView.frame = f;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

  return _imageView;
}

@end
