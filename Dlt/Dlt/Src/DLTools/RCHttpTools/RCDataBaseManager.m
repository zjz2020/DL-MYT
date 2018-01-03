//
//  RCDataBaseManager.m
//  Dlt
//
//  Created by Liuquan on 17/5/28.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "RCDataBaseManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "DLFriendsModel.h"


static NSString *const userTableName = @"USERTABLE";
static NSString *const groupTableName = @"GROUPTABLEV2";
static NSString *const friendTableName = @"FRIENDSTABLE";
static NSString *const blackTableName = @"BLACKTABLE";
static NSString *const groupMemberTableName = @"GROUPMEMBERTABLE";


@interface RCDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation RCDataBaseManager

+ (RCDataBaseManager *)shareInstance {
    static RCDataBaseManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance dbQueue];
    });
    return instance;
}

- (void)closeDBForDisconnect {
    self.dbQueue = nil;
}
- (FMDatabaseQueue *)dbQueue {
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId == nil) {
        return nil;
    }
    if (!_dbQueue) {
        NSString *docsdir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"rongCould"];
        NSFileManager *filemanage = [NSFileManager defaultManager];
        BOOL isDir;
        BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
        if (!exit || !isDir) {
            [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *dbpath = [docsdir stringByAppendingPathComponent:@"data.sqlite"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        if (_dbQueue) {
            [self createUserTableIfNeed];
        }
    }
    return _dbQueue;
}
//创建用户存储表
- (void)createUserTableIfNeed {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (![self isTableOK:userTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY "
            @"KEY autoincrement, userid text,name text, "
            @"portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL =
            @"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![self isTableOK:groupTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE GROUPTABLEV2 (id integer PRIMARY "
            @"KEY autoincrement, groupId text,groupName text, "
            @"portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL =
            @"CREATE unique INDEX idx_groupid ON GROUPTABLEV2(groupId);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![self isTableOK:friendTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE FRIENDSTABLE (id integer "
            @"PRIMARY KEY autoincrement, userid "
            @"text,name text, portraitUri text, status "
            @"text, updatedAt text, displayName text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL =
            @"CREATE unique INDEX idx_friendsId ON FRIENDSTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        } else if (![self isColumnExist:@"displayName" inTable:friendTableName withDB:db]) {
            [db executeUpdate:@"ALTER TABLE FRIENDSTABLE ADD COLUMN displayName text"];
        }
        
        if (![self isTableOK:blackTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE BLACKTABLE (id integer PRIMARY "
            @"KEY autoincrement, userid text,name text, "
            @"portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL =
            @"CREATE unique INDEX idx_blackId ON BLACKTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![self isTableOK:groupMemberTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE GROUPMEMBERTABLE (id integer "
            @"PRIMARY KEY autoincrement, groupid text, "
            @"userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_groupmemberId ON "
            @"GROUPMEMBERTABLE(groupid,userid);";
            [db executeUpdate:createIndexSQL];
        }
    }];
}

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user {
    NSString *insertSql =
    @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql, user.userId, user.name, user.portraitUri];
    }];
}

//存储用户好友列表信息
- (void)insertUserListToDB:(NSMutableArray *)userList {
    if (userList == nil || [userList count] < 1) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (RCUserInfo *user in userList) {
                NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
                [db executeUpdate:insertSql, user.userId, user.name, user.portraitUri];
            }
        }];
    });
}
//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId {
    __block RCUserInfo *model = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs =
        [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?", userId];
        while ([rs next]) {
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userId"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return model;
}

// 获取好友列表
- (NSArray *)getFriendsList {
    NSMutableArray *allUsers = [NSMutableArray new];
    [self.dbQueue inDatabase:^(FMDatabase *db) { 
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE"];
        while ([rs next]) {
            RCUserInfo *model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

/// 插入群列表
- (void)insertGroupListToDB:(NSMutableArray *)groupList {
    if (groupList == nil || [groupList count] < 1) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (RCGroup *group in groupList) {
                NSString *insertSql = @"REPLACE INTO GROUPTABLEV2 (groupId, groupName, portraitUri) VALUES (?, ?, ?)";
                [db executeUpdate:insertSql, group.groupId, group.groupName, group.portraitUri];
            }
        }];
    });
}
- (RCGroup *)getGroupInfoByGroupId:(NSString *)groupId {
    __block RCGroup *model = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLEV2 where groupId = ?", groupId];
        while ([rs next]) {
            model = [[RCGroup alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"groupName"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return model;
}

- (NSArray *)getGroupList {
    NSMutableArray *groups = [NSMutableArray new];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLEV2"];
        while ([rs next]) {
            RCGroup *model = [[RCGroup alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"groupName"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [groups addObject:model];
        }
        [rs close];
    }];
    return groups;
}

//清空好友缓存数据
- (void)clearFriendsData {
    NSString *deleteSql = @"DELETE FROM FRIENDSTABLE";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}
- (BOOL)isTableOK:(NSString *)tableName withDB:(FMDatabase *)db {
    BOOL isOK = NO;
    
    FMResultSet *rs =
    [db executeQuery:@"select count(*) as 'count' from sqlite_master where "
     @"type ='table' and name = ?",
     tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count) {
            isOK = NO;
        } else {
            isOK = YES;
        }
    }
    [rs close];
    
    return isOK;
}
- (BOOL)isColumnExist:(NSString *)columnName inTable:(NSString *)tableName withDB:(FMDatabase *)db {
    BOOL isExist = NO;
    
    NSString *columnQurerySql = [NSString stringWithFormat:@"SELECT %@ from %@", columnName, tableName];
    FMResultSet *rs = [db executeQuery:columnQurerySql];
    if ([rs next]) {
        isExist = YES;
    } else {
        isExist = NO;
    }
    [rs close];
    
    return isExist;
}

@end
