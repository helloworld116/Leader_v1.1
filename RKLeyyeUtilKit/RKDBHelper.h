#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class RKLeyyeUser;
@class RKLeyyeDomain;
@class RKLeyyeArticle;
@class RKLeyyeComment;
@class RKLeyyeActivity;
@class RKLeyyeClub;

@interface RKDBHelper : NSObject{
    NSUserDefaults * defaults;
    sqlite3 * database;//数据库句柄
}

- (NSString *) getDBFilePath;//获取数据库路径

- (BOOL) isExistDatabase;

- (BOOL) createAndOpenDatabase;//创建数据库

- (BOOL) createDBTable:(const char *) tableSql;//创建表

- (void) createLeyyeTable;// 创建领域各种数据表

- (BOOL) insertLeyyeAppUser:(RKLeyyeUser *)user;
- (NSMutableArray *) queryLeyyeAppUser;
- (BOOL) insertLeyyeUser:(RKLeyyeUser *) user;
- (NSMutableArray *) queryLeyyeUser;
- (NSString *) queryLeyyeUserWith:(NSString *)uid;
- (NSMutableArray *) queryLeyyeUserAndPwd;

- (BOOL) insertLeyyeDomain:(RKLeyyeDomain *) domain;
- (NSMutableArray *) queryLeyyeDomain;

- (BOOL) insertLeyyeArticle:(RKLeyyeArticle *) article;
- (NSMutableArray *) queryLeyyeArticle;
- (int) updateLeyyeArticle:(RKLeyyeArticle *) article;

- (BOOL) insertArticleComment:(RKLeyyeComment *)comment;
- (NSMutableArray *) queryArticleComment:(int) articleId;

- (BOOL) insertLeyyeActivity:(RKLeyyeActivity *)activity;

- (BOOL) insertLeyyeClub:(RKLeyyeClub *) club;
- (NSMutableArray *) queryLeyyeClubs;
- (void) updateLeyyeClubs;

@end