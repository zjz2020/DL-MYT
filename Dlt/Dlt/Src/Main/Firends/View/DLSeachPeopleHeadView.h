//
//  DLSeachPeopleHeadView.h
//  Dlt
//
//  Created by Liuquan on 17/5/27.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLSeachPeopleHeadView;

@protocol DLSeachPeopleHeadViewDelegate <NSObject>
@optional
- (void)seachPeopleHeadView:(DLSeachPeopleHeadView *)headView seachWithPhoneNumber:(NSString *)phoneNumber;
- (void)seachPeopleHeadViewToShowMyQRCode;
@end


@interface DLSeachPeopleHeadView : UIView

/// 区分是找人还是找群 找人YES 找群NO
@property (nonatomic, assign) BOOL isSeachPeople;

@property (nonatomic, weak) id<DLSeachPeopleHeadViewDelegate>delegate;

@end
