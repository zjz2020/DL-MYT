//
//  MYSearchView.m
//  Dlt
//
//  Created by Fang on 2018/1/17.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MYSearchView.h"

@interface MYSearchView()
@property(nonatomic,strong)UIButton *searchBtn;

@end

@implementation MYSearchView

+ (MYSearchView *)searchViewWithFram:(CGRect)fram{
    MYSearchView *search = [[MYSearchView alloc] initWithFrame:fram];
    return search;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self creatSeachUI];
    }
    return self;
}
- (void)creatSeachUI{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    CGFloat spce = 15;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xyzW(spce),0,self.width - (xyzW(spce) + xyzW(114)), self.height)];
    label.text = @"www.mayiton.com";
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentLeft;
    self.searchLabel = label;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.maxX, 4, 1, label.height - 8)];
    lineView.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    UIButton *searchB = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchB setTitle:@"蚂蚁搜一下" forState:UIControlStateNormal];
    searchB.titleLabel.font = [UIFont systemFontOfSize:17];
    [searchB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchB.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [searchB addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    searchB.frame = CGRectMake(lineView.maxX, label.top, xyzW(114), label.height);
    [self addSubview:label];
    [self addSubview:lineView];
    [self addSubview:searchB];
}
- (void)searchClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mySearchClicke)]) {
        [self.delegate mySearchClicke];
    }
}
@end
