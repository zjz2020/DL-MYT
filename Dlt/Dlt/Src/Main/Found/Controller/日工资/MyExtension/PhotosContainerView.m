//
//  PhotosContainerView.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/13.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "PhotosContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface PhotosContainerView ()<SDPhotoBrowserDelegate>
@property (nonatomic , assign)BOOL isTap;
@property (nonatomic , strong)NSArray *SDPhotoarray;
@end
@implementation PhotosContainerView
{
    NSMutableArray *_imageViewsArray;
}

- (instancetype)initWithMaxItemsCount:(NSInteger)count
{
    if (self = [super init]) {
        self.maxItemsCount = count;
    }
    return self;
}
-(instancetype)initWithIsTap:(BOOL)isTap{
    if (self = [super init]) {
        self.isTap = isTap;
    }
    return self;
}
- (void)setPhotoNamesArray:(NSArray *)photoNamesArray
{
    _photoNamesArray = photoNamesArray;
    
    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_photoNamesArray.count - _imageViewsArray.count);
   
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [_imageViewsArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        if (idx < _photoNamesArray.count) {
            imageView.hidden = NO;
            imageView.sd_layout.autoHeightRatio(1);
            [imageView sd_setImageWithURL:[NSURL URLWithString:_photoNamesArray[idx]] placeholderImage:[UIImage imageNamed:@"花.png"]];
            imageView.clipsToBounds = YES;
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [temp addObject:imageView];
            if (_isTap) {
                _SDPhotoarray = [NSArray arrayWithArray:_photoNamesArray];
                imageView.userInteractionEnabled = YES;
                imageView.tag = idx;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
                [imageView addGestureRecognizer:tap];
                
            }
        } else {
            [imageView sd_clearAutoLayoutSettings];
            imageView.hidden = YES;
        }
    }];
    
    [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:3 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
}


-(instancetype)initWithUrl{
    if (self = [super init]) {
       
    }
    return self;
}
-(void)setUrlPhotoArray:(NSArray *)urlPhotoArray{
    _urlPhotoArray = urlPhotoArray;

    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_urlPhotoArray.count - _imageViewsArray.count);
    
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [_imageViewsArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        if (idx < _urlPhotoArray.count ) {
            imageView.hidden = NO;
            imageView.image = [UIImage imageNamed:@"花.png"];
            imageView.sd_layout.autoHeightRatio(1);
            [imageView sd_setImageWithURL:_urlPhotoArray[idx] placeholderImage:[UIImage imageNamed:@"花.png"] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                
                imageView.sd_layout.autoHeightRatio(image.size.height/image.size.width);
                imageView.image  =  image;
                           }];

            _SDPhotoarray = [NSArray arrayWithArray:_urlPhotoArray];
            imageView.userInteractionEnabled = YES;
            imageView.tag = idx;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            [temp addObject:imageView];
        } else {
            [imageView sd_clearAutoLayoutSettings];
            imageView.hidden = YES;
        }
    }];
    
    [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:1 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
   
    
}
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    
    browser.imageCount = self.SDPhotoarray.count;
    browser.delegate = self;
    [browser show];
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.SDPhotoarray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}
@end
