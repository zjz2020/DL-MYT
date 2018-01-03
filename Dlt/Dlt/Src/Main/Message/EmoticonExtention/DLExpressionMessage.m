//
//  DLExpressionMessage.m
//  Dlt
//
//  Created by USER on 2017/9/11.
//  Copyright © 2017年 mr_chen. All rights reserved.


#import "DLExpressionMessage.h"

@implementation DLExpressionMessage
///初始化
+ (instancetype)messageWithContent:(NSString *)content {
    DLExpressionMessage *text = [[DLExpressionMessage alloc] init];
    if (text) {
        text.content = content;
        text.imgUri = content;
    }
    return text;
}

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return ( MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.imgUri = [aDecoder decodeObjectForKey:@"imgUri"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.imgUri forKey:@"imgUri"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.imgUri) {
        [dataDict setObject:self.imgUri forKey:@"imgUri"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.content = dictionary[@"content"];
            self.imgUri = dictionary[@"imgUri"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return @"[表情]";
}

///消息的类型名
+ (NSString *)getObjectName {
    return RCDTestMessageTypeIdentifier;
}

@end
