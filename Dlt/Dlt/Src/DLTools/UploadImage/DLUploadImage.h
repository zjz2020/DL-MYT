//
//  DLUploadImage.h
//  Dlt
//
//  Created by Liuquan on 17/6/10.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTModel.h"

@interface DLUploadImage : DLTModel

@property (nonatomic,strong) NSData *data;          /**< 上传文件的二进制数据 */
@property (nonatomic,copy) NSString *name;          /**< 上传的参数名称 */
@property (nonatomic,copy) NSString *fileName;      /**< 上传到服务器的文件名称 */
@property (nonatomic,copy) NSString *mimeType;      /**< 上传文件的类型 */

- (void)UPLOAD:(NSString *)URLString parameters:(id)parameters
                                    uploadParam:(DLUploadImage *)uploadParam
                                        success:(void (^)(id response))success
                                        failure:(void (^)(NSError *error))failure;
@end
