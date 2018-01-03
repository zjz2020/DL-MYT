//
//  NXBShowImageView.m
//  PhotoDemo
//
//  Created by 聂小波MacPro on 15/11/23.
//  Copyright © 2015年 xiaowei project. All rights reserved.
//

#import "NXBShowImageView.h"
#import "PhotoCollection.h"
#define NXBScreenWidth [UIScreen mainScreen].bounds.size.width
#define NXBScreenHieght [UIScreen mainScreen].bounds.size.height
@interface NXBShowImageView ()

@property(nonatomic, strong) PhotoCollection *collectionView;
@property(nonatomic, strong) NSMutableArray *imageList;

@end
@implementation NXBShowImageView

- (void)drawRect:(CGRect)rect {
  // Drawing code
}
- (void)initWithSuperVC:(UIViewController *)superVC
               imageList:(NSMutableArray *)imageList
           currentIndex:(long)currentIndex {
  if (!self) {
    return;
  }
  self.frame = CGRectMake(0, 0, NXBScreenWidth, NXBScreenHieght);
  [superVC.view addSubview:self];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(touchSelfView)];
  [tap setNumberOfTapsRequired:1];
  [self addGestureRecognizer:tap];

  _imageList = [NSMutableArray array];
  _imageList = [imageList mutableCopy];

  //创建collectionView
  [self createCollectionView];

  [_collectionView reloadData];
  [_collectionView
      scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex
                                                 inSection:0]
             atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                     animated:NO];
}

- (void)touchSelfView {
  [self removeFromSuperview];
}
- (void)createCollectionView {

  UICollectionViewFlowLayout *layout =
      [[UICollectionViewFlowLayout alloc] init];

  layout.itemSize = CGSizeMake(NXBScreenWidth, NXBScreenHieght);
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

  //创建图片显示视图
  _collectionView = [[PhotoCollection alloc]
             initWithFrame:CGRectMake(0, 0, NXBScreenWidth + 10,
                                      NXBScreenHieght)
      collectionViewLayout:layout];
  _collectionView.pagingEnabled = YES;
  _collectionView.backgroundColor = [UIColor blackColor];
  _collectionView.imgArray = _imageList;
  [self addSubview:_collectionView];
}

@end
