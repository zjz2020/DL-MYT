//
//  DLTPersonalProfileHeaderView.h
//  Dlt
//
//  Created by Gavin on 2017/6/21.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTPersonalProfileHeaderView : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *editorBtn;
@property (nonatomic, strong) UIImageView *userBackgroundImageview;
@property (nonatomic, strong) UIImageView *userAvatarImageView;

- (void)updatePersonalProfile:(DLTUserProfile *)userProfile;

@end


@interface DLTPersonalProfileHeaderSectionView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIButton *enterAlbumBtn;

@end
