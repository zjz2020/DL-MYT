//
//  DLTAddPhotoTableViewCell.m
//  Dlt
//
//  Created by Gavin on 17/6/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTAddPhotoTableViewCell.h"

#define kStartTag  100

@interface DLTAddPhotoTableViewCell ()

@property (nonatomic, strong) NSMutableArray<UIImageView *>*imageArr;

@property (nonatomic, strong) NSMutableArray *photoNames;

@end

@implementation DLTAddPhotoTableViewCell {
  BOOL _isAddButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    for (int i = 0; i < 3; i ++) {
      UIImageView *imgView = [[UIImageView alloc] init];
      imgView.userInteractionEnabled = YES;
      imgView.contentMode = UIViewContentModeScaleAspectFill;
      imgView.clipsToBounds = YES;
      [self.imageArr addObject:imgView];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
      [imgView addGestureRecognizer:tap];
    }
  }
  
  return self;
}

- (void)setUserProfile:(DLTUserProfile *)userProfile{
  _userProfile = userProfile;
  
    _isAddButton = NO;
  [self.photoNames removeAllObjects];
  NSArray *imageUrls = userProfile.photoNames;
  
  NSMutableArray *temp = [NSMutableArray arrayWithArray:imageUrls];
  if (imageUrls.count < 3) {
    if ([userProfile.uid isEqualToString:DLT_USER_CENTER.curUser.uid]) { // 是自己
      [temp insertObject:[UIImage imageNamed:@"personal_32"]
                 atIndex:imageUrls.count];
      _isAddButton = YES;
    }
  }
  else {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, temp.count - 3)];
    [temp removeObjectsAtIndexes:indexSet];
  }
  
  
  for (int i = 0; i < temp.count; i ++) {
    UIImageView *imgView = self.imageArr[i];
    imgView.tag = i + kStartTag;
    
    CGFloat imgViewW = (kScreenSize.width - 60) / 3;
    imgView.frame = CGRectMake(15 + (imgViewW + 15) * i, 10, imgViewW, 105);
    
    if ([temp[i] isKindOfClass:[NSString class]]) {
      [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,temp[i]]]
                 placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
        
    }
    else if ([temp[i] isKindOfClass:[UIImage class]]) {
      imgView.image = temp[i];
    }
    [self.contentView addSubview:imgView];
  }
  [self.photoNames addObjectsFromArray:temp];
  
}

- (void)tapImageView:(UITapGestureRecognizer *)tap {
  NSUInteger index = tap.view.tag - kStartTag;
  id content = self.photoNames[index];
  if ([content isKindOfClass:[NSString class]]) {
    if (self.photosDelegate && [self.photosDelegate respondsToSelector:@selector(addPhotoTableViewCell:cellForPhotos:cellForImageViews:didClickIndex:)]) {
      NSMutableArray *URL = [NSMutableArray arrayWithArray:self.photoNames ];
      if (_isAddButton) {[URL removeLastObject];}     
      [self.photosDelegate addPhotoTableViewCell:self cellForPhotos:URL cellForImageViews:self.imageArr didClickIndex:index];
    }
  }
  
  if ([content isKindOfClass:[UIImage class]]){
    if (self.DLTEnterPhotoAlbum_Block) {
      self.DLTEnterPhotoAlbum_Block();
    }
  }
  
}


- (UIImageView *)creatImageView {
  UIImageView *imgView = [[UIImageView alloc] init];
  imgView.contentMode = UIViewContentModeScaleAspectFill;
  imgView.clipsToBounds = YES;
  return imgView;
}

#pragma mark -懒加载
- (NSMutableArray<UIImageView *> *)imageArr {
  if (!_imageArr) {
    _imageArr = [NSMutableArray array];
  }
  return _imageArr;
}

- (NSMutableArray *)photoNames {
  if (!_photoNames) {
    _photoNames = [NSMutableArray array];
  }
  return _photoNames;
}


@end
