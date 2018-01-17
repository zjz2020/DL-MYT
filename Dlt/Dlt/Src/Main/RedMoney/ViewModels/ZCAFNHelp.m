//
//  ZCAFNHelp.m
//  ZXCC
//  AFN二次封装
//  Created by 张君泽 on 17/5/24.
//  Copyright © 2017年 TheFutureGroup. All rights reserved.
//

#import "ZCAFNHelp.h"
#import <AFNetworking/AFNetworking.h>
//static NSString *kBaseUrl = @"www.baidu.com";

@interface AFHttpClient : AFHTTPSessionManager
+ (instancetype)shareClient;
@end

@implementation AFHttpClient

+ (instancetype)shareClient{
    static AFHttpClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[AFHttpClient alloc] initWithSessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 15;
        //安全策略
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
//        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
        client.securityPolicy = securityPolicy;
    });
    return client;
}
@end

@implementation ZCAFNHelp
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    [[AFHttpClient shareClient] GET:path parameters:path progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    [[AFHttpClient shareClient] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)downloadWithPath:(NSString *)path success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpDownloadProgressBlock)progress{
    //下载
    NSURL *URL = [NSURL URLWithString:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient shareClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];
}
+ (void)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params thumbName:(NSString *)imagekey image:(UIImage *)image success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress{
    //获取完整的url路径
    NSData * data = UIImagePNGRepresentation(image);
    
    [[AFHttpClient shareClient] POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:imagekey fileName:@"01.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
@end
