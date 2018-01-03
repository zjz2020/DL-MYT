//
//  NXBShowImageViewController.m
//  PhotoDemo
//
//  Created by 聂小波MacPro on 15/11/23.
//  Copyright © 2015年 xiaowei project. All rights reserved.
//

#import "NXBShowImageViewController.h"
#import "PhotoCollection.h"
#define XBScreenWidth [UIScreen mainScreen].bounds.size.width
#define XBScreenHieght [UIScreen mainScreen].bounds.size.height
@interface NXBShowImageViewController ()
@property(nonatomic, strong) PhotoCollection *collectionView;

@end

@implementation NXBShowImageViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor blackColor];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(touchSelfView)];
  [tap setNumberOfTapsRequired:1];
  [self.view addGestureRecognizer:tap];

  //数据加载
  [self loadData];
}
- (void)touchSelfView {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
  //创建collectionView
  [self createCollectionView];

  [_collectionView reloadData];
  if (!_currentIndex) {
    _currentIndex = 0;
  }

  [_collectionView
      scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex
                                                 inSection:0]
             atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                     animated:NO];
}

- (void)createCollectionView {

  UICollectionViewFlowLayout *layout =
      [[UICollectionViewFlowLayout alloc] init];

  layout.itemSize = CGSizeMake(XBScreenWidth, XBScreenHieght);
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

  //创建图片显示视图
  _collectionView = [[PhotoCollection alloc]
             initWithFrame:CGRectMake(0, 0, XBScreenWidth + 10, XBScreenHieght)
      collectionViewLayout:layout];
  _collectionView.pagingEnabled = YES;
  _collectionView.backgroundColor = [UIColor blackColor];
  _collectionView.imgArray = _imageList;
  [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
