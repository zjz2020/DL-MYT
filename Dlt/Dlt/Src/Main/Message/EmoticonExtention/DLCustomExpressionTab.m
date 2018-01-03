//
//  DLCustomExpressionTab.m
//  Dlt
//
//  Created by USER on 2017/9/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLCustomExpressionTab.h"
#import "ConversationViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DLExpressionMessage.h"
#import <YYKit/YYKit.h>
@implementation DLCustomExpressionTab
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index {
    UIView *view11 = [[UIView alloc]
                      initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 186)];
    view11.backgroundColor = [UIColor colorWithDisplayP3Red:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    NSData *gifData = [[NSUserDefaults standardUserDefaults]dataForKey:@"ExpressGif"];
    NSArray *gifArray = [NSKeyedUnarchiver unarchiveObjectWithData:gifData];
 
    for (int i = 0; i < _pageCount; i ++) {
        
        if (index == i) {
            NSMutableArray *imgs = [NSMutableArray array];
            int G ;
            if (i == _pageCount - 1) {
                G=gifArray.count%8;
            }else{
                G = 8;
            }
            for (int n = 0; n < G; n++) {
                [imgs addObject:[gifArray objectAtIndex:n+(i*8)]];
            }
            [self setUp:view11 imageArray:imgs page:i];
        }
    }
    return view11;
}
-(void)setUp:(UIView  *)view imageArray:(NSArray *)imageArray page:(int)page{
    
    // 保存前一个button的宽以及前一个button距离屏幕边缘的距
    CGFloat edge =0;
    CGFloat w = 25;
    //设置button 距离父视图的高
    CGFloat h =15;
    CGFloat length = (view.frame.size.width - 5*w)*0.25;
    for (int i =0; i< imageArray.count; i++) {
        UIImageView *button = [UIImageView new];
        UITapGestureRecognizer *imgTag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upImageButton:)];
        [button addGestureRecognizer:imgTag];
        button.userInteractionEnabled = YES;
        button.tag = page*8 + i +100;

        NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,imageArray[i]]];

        [button sd_setImageWithURL:imgUrl];
        //设置button的frame
        button.frame =CGRectMake(w + edge, h, length, length);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if (edge+length  >view.frame.size.width) {
            //换行时将左边距设置为10
            edge =0;
            //距离父视图的高度变化
            h=h+button.frame.size.height +10;
            //标签换行后的frame
            button.frame =CGRectMake(edge+w, h, length, length);
            
        }
        //获取前一个button的尾部位置位置
        edge = button.frame.size.width +button.frame.origin.x;
        
        [view addSubview:button];
        
    }
    
}

-(void)upImageButton:(UITapGestureRecognizer *)recognizer{
    NSData *gifData = [[NSUserDefaults standardUserDefaults]dataForKey:@"ExpressGif"];
    NSArray *gifArray = [NSKeyedUnarchiver unarchiveObjectWithData:gifData];
    NSString *str = gifArray[recognizer.view.tag - 100];
    str = [str stringByReplacingOccurrencesOfString:@"/imgs/customImg/T80X80/"withString:@""];
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendExpressMessage:)]) {
        [self.delegate sendExpressMessage:str];
    }
  
    
    
}

@end
