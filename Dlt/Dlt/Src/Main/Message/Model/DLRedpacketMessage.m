//
//  DLRedpacketMessage.m
//  Dlt
//
//  Created by Liuquan on 17/6/7.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLRedpacketMessage.h"

@implementation DLRedpacketMessage

+ (instancetype)messageWithContent:(NSString *)content andRedpacketId:(NSString *)packetId {
    DLRedpacketMessage *msg = [DLRedpacketMessage new];
    if (msg) {
        msg.content = content;
        msg.packetId = packetId;
    }
    return msg;
}
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.packetId = [aDecoder decodeObjectForKey:@"packetId"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.packetId forKey:@"packetId"];
}


- (NSData *)encode {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:self.content forKey:@"content"];
    if (self.packetId) {
        [dataDic setObject:self.packetId forKey:@"packetId"];
    }
    if (self.senderUserInfo) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.senderUserInfo.name) {
            [dic setObject:self.senderUserInfo.name forKey:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [dic setObject:self.senderUserInfo.portraitUri forKey:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [dic setObject:self.senderUserInfo.userId forKey:@"id"];
        }
        [dataDic setObject:dic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:nil];
    return data;
}
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.content = dictionary[@"content"];
            self.packetId = dictionary[@"packetId"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

- (NSString *)conversationDigest {
    return [NSString stringWithFormat:@"[蚂蚁通红包]%@",self.content];
}

+ (NSString *)getObjectName {
    return DLRedpacketMessageTypeIdentify;
}

@end
