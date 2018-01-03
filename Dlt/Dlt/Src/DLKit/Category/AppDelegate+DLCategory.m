//
//  AppDelegate+DLCategory.m
//  Dlt
//
//  Created by USER on 2017/5/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "AppDelegate+DLCategory.h"

#import "ShareManger.h"


@implementation AppDelegate (DLCategory)

-(void)cofonfig
{
    [SHAREMANAGER setupryAppkey];
    
     [[RCIM sharedRCIM] setScheme:@"DLT_RongCloudRedPacket" forExtensionModule:@"dlt_JrmfPacketManager"];
}

- (void)initRongCouldWithApplication:(UIApplication *)application
                          andOptions:(NSDictionary *)luchOptions {
    
    
    
    
}

@end
