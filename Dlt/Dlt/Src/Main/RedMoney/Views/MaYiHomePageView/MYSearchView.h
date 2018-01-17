//
//  MYSearchView.h
//  Dlt
//
//  Created by Fang on 2018/1/17.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSearchViewDelegate <NSObject>

-(void)mySearchClicke;

@end

@interface MYSearchView : UIView
+ (MYSearchView *)searchViewWithFram:(CGRect)fram;
@property(nonatomic,weak)id<MYSearchViewDelegate> delegate;
@end
