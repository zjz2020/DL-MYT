//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 16/12/23.
//  Copyright © 2016年 gsd. All rights reserved.
//


#import "SDWeiXinPhotoContainerView.h"
#import "MSSBrowseNetworkViewController.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"

@interface SDWeiXinPhotoContainerView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
@implementation SDWeiXinPhotoContainerView {
  SDWeiXinPhotoContainerViewType _type;
}

- (instancetype)initWithPhotoContainerView:(SDWeiXinPhotoContainerViewType)type
{
    if (self = [super init]) {
      _type = type;
        [self setup];
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds  = YES;
      
        imageView.backgroundColor = rgb(215, 215, 215);
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
      itemH = itemW*3/4;
      
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
      
      NSString *iconStr = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,obj];
      [imageView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
      imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *curImageView = tap.view;
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.currentImageIndex = curImageView.tag;
//    browser.sourceImagesContainerView = self;
//    browser.imageCount = self.picPathStringsArray.count;
//    browser.delegate = self;
//    [browser show];
  
  
  NSMutableArray *browseItemArray = @[].mutableCopy;
  for(int i = 0; i < self.picPathStringsArray.count; i++) {
    UIImageView *imageView = self.imageViewsArray[i];
    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc] init];
    browseItem.bigImageUrl = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,self.picPathStringsArray[i]]; // 大图url地址
    browseItem.smallImageView = imageView;// 小图
    [browseItemArray addObject:browseItem];
  }
  
  MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:curImageView.tag];
  // bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
  [bvc showBrowseViewController];
  
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 240;
    } else {
      if (_type == SDWeiXinPhotoContainerViewTypeDefault) {
        return [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
      }
      else{
        return ([UIScreen mainScreen].bounds.size.width - 2*15 - (3-1)*5)/3;
      }
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

- (void)prepareForReuse{
  for (int i = 0;  i < self->_picPathStringsArray.count ; i++) {
    @autoreleasepool{
      UIImageView *imageView = [self->_imageViewsArray objectAtIndex:i];
      [imageView sd_cancelCurrentImageLoad];
    }
  }
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
