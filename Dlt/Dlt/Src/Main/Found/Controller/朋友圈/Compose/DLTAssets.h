//
//  DLTAssets.h
//  Dlt
//
//  Created by Gavin on 17/5/31.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

typedef NS_ENUM(NSInteger, DLTAssetModelMediaType) {
    DLTAssetModelMediaTypePhoto = 0,
    DLTAssetModelMediaTypeLivePhoto,
    DLTAssetModelMediaTypePhotoGif,
    DLTAssetModelMediaTypeVideo,
    DLTAssetModelMediaTypeAudio
};


@interface DLTAssets : DLTModel

- (instancetype)initAssetWithMediaType:(DLTAssetModelMediaType)type NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) DLTAssetModelMediaType   mediaType;;

@property (nonatomic, strong) UIImage   *thumbnail;

// Photo
@property (nonatomic, strong) UIImage   *originalPhoto;

// video
@property (nonatomic, strong) NSURL     *videoURL;

@end
