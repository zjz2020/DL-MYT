//
//  DLUploadImage.m
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLUploadImage.h"

@implementation DLUploadImage

/** UPLOAD方法请求 */
- (void)UPLOAD:(NSString *)URLString parameters:(id)parameters uploadParam:(DLUploadImage *)uploadParam success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 30;
    // 发送UPLOAD请求
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传的文件全部拼接到formData
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(json);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
