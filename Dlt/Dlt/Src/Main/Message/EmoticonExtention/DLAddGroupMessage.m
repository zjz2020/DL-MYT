//
//  DLAddGroupMessage.m
//  Dlt
//
//  Created by USER on 2017/11/1.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLAddGroupMessage.h"

@implementation DLAddGroupMessage

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return ( MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.gqId = [aDecoder decodeObjectForKey:@"gqId"];
         self.time = [aDecoder decodeObjectForKey:@"time"];
        self.groupName = [aDecoder decodeObjectForKey:@"groupName"];
        self.fromName = [aDecoder decodeObjectForKey:@"fromName"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
     [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.gqId forKey:@"gqId"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.groupName forKey:@"groupName"];
    [aCoder encodeObject:self.fromName forKey:@"fromName"];
  
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.gqId forKey:@"gqId"];
    [dataDict setObject:self.time forKey:@"time"];
    [dataDict setObject:self.groupName forKey:@"groupName"];
    [dataDict setObject:self.fromName forKey:@"fromName"];
    [dataDict setObject:self.content forKey:@"content"];
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
            self.gqId = dictionary[@"gqId"];
            self.time = dictionary[@"time"];
            self.groupName = dictionary[@"groupName"];
            self.fromName = dictionary[@"fromName"];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    NSString *str = [NSString stringWithFormat:@"请求加入群[%@]",self.groupName];
    return str;
}

///消息的类型名
+ (NSString *)getObjectName {
    return RCDaddGroupMessageTypeIdentifier;
}

@end
