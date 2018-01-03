//
//  DLThirdShare.m
//  DLParks
//
//  Created by Liuquan on 16/7/4.
//  Copyright © 2016年 珠海园圈科技有限公司. All rights reserved.
//

#import "DLThirdShare.h"
#import <WXApi.h>


@interface DLThirdShare ()

@end

@implementation DLThirdShare

+ (instancetype)thirdShareInstance {
    static DLThirdShare *thirdShare = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thirdShare = [[DLThirdShare alloc] init];
    });
    return thirdShare;
}

// 分享到微信
- (void)shareToWechat:(DLShareWechatType)shareType {
    if (![WXApi isWXAppInstalled]) {
        [DLAlert alertWithText:@"请先安装“微信”客户端"];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareTitle;
    message.description = self.shareText;
    [message setThumbImage:self.shareImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.shareUrl;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    switch (shareType) {
        case ShareWechatType_Session: {
            req.scene = WXSceneSession;     // 分享到微信聊天
        }
            break;
        default: {
            req.scene = WXSceneTimeline;    // 分享到微信朋友圈
        }
            break;
    }
    [WXApi sendReq:req];
}

#pragma mark - 回调
- (void)onResp:(BaseResp *)resp {
    
}
@end
