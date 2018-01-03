//
//  SelectorView.h
//  Dlt
//
//  Created by USER on 2017/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectorView;

@protocol DLSeachPeopleHeadViewDelegate <NSObject>
@optional
- (void)seachPeopleHeadView:(SelectorView *)headView seachWithPhoneNumber:(NSString *)phoneNumber;
@end
@interface SelectorView : UIView
@property (nonatomic, weak) id<DLSeachPeopleHeadViewDelegate>delegate;

@end
