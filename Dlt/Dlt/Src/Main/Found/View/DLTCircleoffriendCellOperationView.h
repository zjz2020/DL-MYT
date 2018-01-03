//
//  DLTCircleoffriendCellOperationView.h
//  Dlt
//
//  Created by Gavin on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLTCircleoffriendCellOperationView : UIView

@property (nonatomic,strong) UIButton *thumbButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UILabel  *thumbLabel;
@property (nonatomic,strong) UILabel  *commentLabel;
@property (nonatomic,strong) UILabel  *lineLabel;
@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic, assign) CGFloat likeds;
@property (nonatomic, assign) CGFloat comments;

@property (nonatomic, assign, getter = isLiked) BOOL liked;
@property (nonatomic, assign,getter=isHiddenLine) BOOL hiddenLine;       // Default: YES;
@property (nonatomic, assign,getter=isHiddenMoreBtn) BOOL hiddenMoreBtn; // Default: YES

@property (nonatomic, copy) void (^OperationViewButtonClickedBlock)(NSInteger index); // thumb: 10086  comment:10087

@end
