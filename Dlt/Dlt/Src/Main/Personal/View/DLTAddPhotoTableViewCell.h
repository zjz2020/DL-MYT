//
//  DLTAddPhotoTableViewCell.h
//  Dlt
//
//  Created by Gavin on 17/6/19.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLTAddPhotoTableViewCell;
@protocol AddPhotosCellDelegate <NSObject>
@optional
- (void)addPhotoTableViewCell:(DLTAddPhotoTableViewCell *)cell
                cellForPhotos:(NSArray <NSString *>*)photos
            cellForImageViews:(NSArray <UIImageView *>*)imageViews
                didClickIndex:(NSInteger )index;
@end


@interface DLTAddPhotoTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton * addImage;
@property(nonatomic, copy)  dispatch_block_t  DLTEnterPhotoAlbum_Block;

@property (nonatomic, weak) id<AddPhotosCellDelegate>photosDelegate;

@property (nonatomic, strong) DLTUserProfile *userProfile;

@end
