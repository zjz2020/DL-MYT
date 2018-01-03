//
//  DLTComposePhotoViewCell.h
//  Dlt
//
//  Created by Gavin on 17/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTAssets.h"

@interface DLTComposePhotoViewCell : UICollectionViewCell

@property (nonatomic , strong) DLTAssets *asset;
@property (nonatomic , weak) UIButton *deletePhotoButton;
@property (nonatomic , strong) NSIndexPath *indexpath;
@property (nonatomic , strong) UIImageView *imageView;

@end
