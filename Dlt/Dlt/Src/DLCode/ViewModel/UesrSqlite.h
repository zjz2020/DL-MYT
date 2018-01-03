//
//  UesrSqlite.h
//  Dlt
//
//  Created by USER on 2017/5/18.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "JKDBModel.h"

@interface UesrSqlite : JKDBModel
/*！电话号码 */
@property (nonatomic, copy  ) NSString  *phone;

/*！昵称 */
@property (nonatomic, copy  ) NSString  *nickName;

/*！密码 */
@property (nonatomic, copy  ) NSString  *pwd;

/*！用户识别码：唯一【登录后才有】 */
@property (nonatomic, copy  ) NSString  *userCode;

@end
