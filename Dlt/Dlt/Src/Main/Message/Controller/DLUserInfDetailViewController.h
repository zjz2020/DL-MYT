//
//  DLUserInfDetailViewController.h
//  Dlt
//
//  Created by Liuquan on 17/6/14.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLUserInfDetailViewController : UIViewController

/// 查看的用户的id
@property (nonatomic, copy) NSString *otherUserId;
@property (nonatomic , assign)BOOL isBalckFriend;

@end
