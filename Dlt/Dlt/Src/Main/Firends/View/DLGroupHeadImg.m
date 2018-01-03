//
//  DLGroupHeadImg.m
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroupHeadImg.h"

#define kImageStartTag    100

static NSString * const kGroupImageCellId = @"GroupImageCellId";

@interface DLGroupImageCell ()

@end


@implementation DLGroupImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.image = [UIImage imageNamed:@"wallet_11"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        [self.imageView addGestureRecognizer:longPressGr];
    }
    return self;
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSInteger tag = longPress.view.tag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(groupImageCell:longPressImageView:)]) {
            [self.delegate groupImageCell:self longPressImageView:tag];
        }
    }
}

@end


@interface DLGroupHeadImg ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DLGroupImageCellDelegate> {
    int _totalloc;
    CGFloat _imageW_H;
    CGFloat _margin;
}
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *signLabel;
@end

@implementation DLGroupHeadImg

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake((kScreenSize.width - 50) / 4, (kScreenSize.width - 50) / 4);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[DLGroupImageCell class] forCellWithReuseIdentifier:kGroupImageCellId];
    
    UILabel *signLabel = [[UILabel alloc] init];
    self.signLabel = signLabel;
    signLabel.text = @"长按图片，可以设置为头像或删除";
    signLabel.textColor = [UIColor colorWithHexString:@"999999"];
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:signLabel];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {return 1;}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DLGroupImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGroupImageCellId forIndexPath:indexPath];
    cell.imageView.tag = indexPath.item + kImageStartTag;
    id content = self.imageArray[indexPath.row];
    if ([content isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)content;
    } else if ([content isKindOfClass:[NSString class]]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:content] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    }
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenSize.width - 50) / 4, (kScreenSize.width - 50) / 4);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 10, 0, 10);
}


- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    [self.imageArray addObjectsFromArray:imageArr];
    CGFloat height;
    if (imageArr.count >= 4) {
        height = ((kScreenSize.width - 50) / 4) * 2 + 15 + 10 + 50;
    } else {
        height = ((kScreenSize.width - 50) / 4) + 15 + 50;
    }
    if (imageArr.count <= 7) {
        UIImage *image = [UIImage imageNamed:@"group_add"];
        if (image) {
            [self.imageArray addObject:image];
        }
    }
    self.collectionView.frame = CGRectMake(0, 0, kScreenSize.width, height - 40);
    self.signLabel.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 5, kScreenSize.width, 20);
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
}
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
#pragma mark - delegate
- (void)groupImageCell:(DLGroupImageCell *)cell longPressImageView:(NSInteger)index {
    // 先判断下是不是添加头像
    id content = self.imageArray[index - kImageStartTag];
    if ([content isKindOfClass:[NSString class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(groupHeadImg:deleteOrSetImage:)]) {
            [self.delegate groupHeadImg:self deleteOrSetImage:index - kImageStartTag];
        }
    } else if ([content isKindOfClass:[UIImage class]]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(addMoreHeadImage)]) {
            [self.delegate addMoreHeadImage];
        }
    }
}


@end
