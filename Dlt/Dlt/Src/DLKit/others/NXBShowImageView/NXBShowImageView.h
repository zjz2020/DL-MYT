//
//  NXBShowImageView.h
//  PhotoDemo
//
//  Created by 聂小波MacPro on 15/11/23.
//  Copyright © 2015年 xiaowei project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXBShowImageView : UIView

/*使用方法

 NXBShowImageView *tesnt=[[NXBShowImageView alloc]init];

 [tesnt initWithSuperVC:self imageList:_imageList currentIndex:2];



imageList:本地图片名称字符串（xxx.png） 或者 image 或者imageview
*/
- (void)initWithSuperVC:(UIViewController *)superVC
               imageList:(NSMutableArray *)imageList
           currentIndex:(long)currentIndex;
@end
