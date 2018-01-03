//
//  DLThirdShare.h
//  DLParks
//
//  Created by Liuquan on 16/7/4.
//  Copyright © 2016年 珠海园圈科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>


typedef NS_ENUM(NSInteger, DLShareWechatType){
    
    ShareWechatType_Session,     // 分享到微信会话
    
    ShareWechatType_Circle       // 分享到微信朋友圈
};

typedef void(^DLShareSuccessBlock)();
@interface DLThirdShare : NSObject<WXApiDelegate>

/**< 分享标题 */
@property (nonatomic, strong) NSString *shareTitle;

/**< 分享内容 */
@property (nonatomic, strong) NSString *shareText;

/**< 分享链接地址 */
@property (nonatomic, strong) NSString *shareUrl;

/**< 分享图片*/
@property (nonatomic, strong) UIImage *shareImage;


@property (nonatomic, copy) DLShareSuccessBlock shareBlock;
/**< 初始化 */
+ (instancetype)thirdShareInstance;

- (void)shareToWechat:(DLShareWechatType)shareType;

@end
