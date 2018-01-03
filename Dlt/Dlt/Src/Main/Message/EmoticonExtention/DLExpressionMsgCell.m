//
//  DLExpressionMsgCell.m
//  Dlt
//
//  Created by USER on 2017/9/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLExpressionMsgCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIImage+CompressImage.h"
#import "UIImage+GIF.h"
#import <YYKit/YYKit.h>
#import "DLExpressionMessage.h"
#define ImageH 100
@implementation DLExpressionMsgCell
{
    YYAnimatedImageView *_expressionView;
    RCMessageModel *_msgModel;
}
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    
    
    CGFloat __messagecontentview_height = ImageH;__messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
 
     _expressionView=[YYAnimatedImageView new];
    /// 添加长按tap
    _expressionView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPressed:)];
    [_expressionView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upGifImageView)];
    [_expressionView addGestureRecognizer:tap];
     //original
    //T80X80
    
    [self.messageContentView addSubview:_expressionView];
    
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    _msgModel = model;
    if ([model.content isMemberOfClass:[DLExpressionMessage class]]) {
        DLExpressionMessage *msgModel = (DLExpressionMessage *)model.content;
        _expressionView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/imgs/customImg/original/%@",BASE_IMGURL,msgModel.imgUri]];;
    }
    [self setupFrome];
}
-(void)setupFrome{
    if (MessageDirection_SEND == self.messageDirection) {
        _expressionView.frame = CGRectMake(ImageH-10, 0, ImageH, ImageH);
    }else{
        _expressionView.frame = CGRectMake(0, 0, ImageH, ImageH);
    }
}
//长按
-(void)longPressed:(id)sender{
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:_expressionView];
    }
}
//点击图片
-(void)upGifImageView{
   
}
@end
