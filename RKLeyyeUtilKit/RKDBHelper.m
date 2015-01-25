#import "RKDBHelper.h"
#import "RKLeyyeUtilKit.h"
#import "RKLeyyeUser.h"
#import "RKLeyyeDomain.h"
#import "RKLeyyeArticle.h"
#import "RKLeyyeComment.h"
#import "RKLeyyeClub.h"


#define kDB_NAME_SQLITE         @"leyye.sqlite"
#define kDB_NAME_DB             @"leyye.db"

@implementation RKDBHelper{
    
}

- (id) init {
    if (self = [super init]) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) initialize{
    if(![self isExistDatabase]){
        [self createAndOpenDatabase];
    }else{
        [self deleteDBFile];
        [self createAndOpenDatabase];
    }
}

- (NSString *) getDBFilePath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * dbFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDB_NAME_SQLITE];
    [defaults setObject:dbFilePath forKey:@"dbfilepath"];
    debugLog(@"数据库文件路径：%@",dbFilePath);
    return dbFilePath;
}

- (BOOL) isExistDatabase{
    NSFileManager* fm = [[NSFileManager alloc] init];
    return [fm fileExistsAtPath:[self getDBFilePath]];
}

- (void) deleteDBFile/*:(NSString *) path*/{
    NSError * error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager changeCurrentDirectoryPath:[self getDBFilePath]];
    if([fileManager removeItemAtPath:[self getDBFilePath] error:&error]){
        NSLog(@"文件删除成功");
    }
}

#pragma mark db manage
- (BOOL) createAndOpenDatabase{
    int ret = sqlite3_open([[self getDBFilePath ] UTF8String], &database);
    if (ret == SQLITE_OK) {
//        sqlite3_close(database);
        debugLog(@"成功创建并打开数据库");
        return YES;
    }
    return NO;
}

- (BOOL) createDBTable:(const char *) tableSql{
    if ([self createAndOpenDatabase]) {
        char * error;
        if (sqlite3_exec(database, tableSql, NULL,NULL, &error) == SQLITE_OK) {
            sqlite3_close(database);
            return YES;
        }
    }
    return NO;
}

- (void) createLeyyeTable{
    const char * DB_TABLE_APPUSER = "create table if not exists appuser (_id integer primary key AUTOINCREMENT, uid integer UNIQUE,username text,nickname text, password char(32),expires integer,icon text)";
    if ([self createDBTable:DB_TABLE_APPUSER]) {
        debugLog(@"领域App用户表创建成功");
    }
    
    const char * DB_TABLE_USER = "create table if not exists user (_id integer primary key AUTOINCREMENT, uid integer UNIQUE,username text,realname char(16),nickname text, password text,icon text,age integer,sex char(8),address text,birthday char(16),email char(32),phone integer,qq char(16),introduction text,coins integer,contribution integer,rank integer)";
    if ([self createDBTable:DB_TABLE_USER]) {
        debugLog(@"领域用户表创建成功");
    }
    
    const char * DB_TABLE_DOMAIN = "create table if not exists domain (_id integer primary key AUTOINCREMENT,domain_id integer UNIQUE,domain_name text, domain_icon text,articleCount integer,userCount integer,total_coin integer,rank integer)";
    if ([self createDBTable:DB_TABLE_DOMAIN]) {
        debugLog(@"领域表创建成功");
    }
    
    const char * DB_TABLE_ARTICLE = "create table if not exists article (_id integer primary key AUTOINCREMENT,score  integer,title char(32),intro text,content text,domain_id integer,domain text,author char(16),author_nick char(16),author_icon char(32),author_icon_data text,author_lv integer,author_rank integer,date text,remark text,img text,awayFromFirst integer,aid integer UNIQUE)";
    if ([self createDBTable:DB_TABLE_ARTICLE]) {
        debugLog(@"文章表创建成功");
    }
    
    const char * DB_TABLE_COMMENT = "create table if not exists comment (_id integer primary key AUTOINCREMENT,cid  integer,aid integer,comment_nickname char(64),comment_icon char(64),comment_content text,comment_date date)";
    if ([self createDBTable:DB_TABLE_COMMENT]) {
        debugLog(@"评论表创建成功");
    }
    
    const char * DB_TABLE_ACTIVITY = "create table if not exists activity (_id integer primary key AUTOINCREMENT, acid  integer UNIQUE,activity_title char(32),activity_icon text,activity_sponsors text,activity_contribution integer,activity_coins integer)";
    if ([self createDBTable:DB_TABLE_ACTIVITY]) {
        debugLog(@"活动表创建成功");
    }
    
    const char * DB_TABLE_CLUB = "create table if not exists club (_id integer primary key AUTOINCREMENT, sid integer UNIQUE,title char(32),icon text,intro text,user_count integer)";
    if ([self createDBTable:DB_TABLE_CLUB]) {
        debugLog(@"俱乐部表创建成功");
    }
    
    const char * DB_TABLE_NOTICE = "create table if not exists notice (_id integer primary key AUTOINCREMENT, type_id text,user text,has_read integer)";
    if ([self createDBTable:DB_TABLE_NOTICE]) {
        debugLog(@"通知表创建成功");
    }
    
    const char * DB_TABLE_OFFLINE = "create table if not exists offline (_id integer primary key AUTOINCREMENT, offline text,param1 text,param2 text,param3 text)";
    if ([self createDBTable:DB_TABLE_OFFLINE]) {
        debugLog(@"离线数据表创建成功");
//        sqlite3_close(database);
    }
}

- (BOOL)dropTableWithTableName:(NSString *) tableName{
//    NSString* dropSql =[[NSString alloc] initWithFormat:@"delete table %@",tableName];
//    return [self execSql:[dropSql ]];
    return NO;
}

- (BOOL) insertLeyyeAppUser:(RKLeyyeUser *)user{
    if ([self createAndOpenDatabase]) {
        const char * insertSQL = "insert into appuser(_id,uid,username,nickname,password,expires,icon) values(null,?,?,?,null,?,?)";
        NSParameterAssert(user != nil);
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int result = sqlite3_prepare_v2(database,insertSQL, -1, &stmt, nil);
        debugLog(@"%sinsertLeyyeUser:result:%i",__func__,result);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_text(stmt, 3,[user.userNick UTF8String], -1, NULL);
//            sqlite3_bind_text(stmt, 4,[user.password UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 5,user.expires);
            if([RKLeyyeUtilKit isBlankString:user.userIcon]){
                sqlite3_bind_null(stmt, 6);
            }else{
                sqlite3_bind_text(stmt, 6,[user.userIcon UTF8String], -1, NULL);
            }
            // 执行SQL语句
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return YES;
        }
        return NO;
    }
    return NO;
}

- (NSMutableArray *) queryLeyyeAppUser{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from appuser";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        debugLog(@"%squeryLeyyeUser -> result:%i",__func__,result);
        if (result == SQLITE_OK) {
            NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:10];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                //                int uid = sqlite3_column_int(stmt , 1);
            }
            sqlite3_finalize(stmt);
            return array;
        }
        NSLog(@"查询领域用户出错");
        return nil;
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (BOOL) insertLeyyeUser:(RKLeyyeUser *) user{
    if ([self createAndOpenDatabase]) {
        const char * insertSQL = "insert into user(_id,uid,username,realname,nickname,password,icon,age,sex,address,birthday,email,phone,qq,introduction,coins,contribution,rank) values(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        NSParameterAssert(user != nil);
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int result = sqlite3_prepare_v2(database,insertSQL, -1, &stmt, nil);
        debugLog(@"%sinsertLeyyeUser:result:%i",__func__,result);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1, user.uid);
            sqlite3_bind_text(stmt, 2,[user.leyyeName UTF8String], -1, NULL);
            if ([RKLeyyeUtilKit isBlankString:user.realName]) {
                sqlite3_bind_null(stmt, 3);
            }else{
                sqlite3_bind_text(stmt, 3,[user.realName UTF8String], -1, NULL);
            }
            sqlite3_bind_text(stmt, 4,[user.userNick UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5,[user.password UTF8String], -1, NULL);
            
            if([RKLeyyeUtilKit isBlankString:user.userIcon]){
                sqlite3_bind_null(stmt, 6);
            }else{
                sqlite3_bind_text(stmt, 6,[user.userIcon UTF8String], -1, NULL);
            }
            
//            if ([RKLeyyeUtilKit isBlankString:user.age]) {
//                sqlite3_bind_null(stmt, 7);
//            }else{
//                sqlite3_bind_int(stmt, 7,user.expires);
//            }
            
            if ([RKLeyyeUtilKit isBlankString:user.sex]) {
                sqlite3_bind_null(stmt, 8);
            }else{
                sqlite3_bind_text(stmt, 8,[user.userIcon UTF8String], -1, NULL);
            }
            
            if ([RKLeyyeUtilKit isBlankString:user.address]) {
                sqlite3_bind_null(stmt, 9);
            }else{
                sqlite3_bind_text(stmt, 9,[user.address UTF8String], -1, NULL);
            }
            
            if ([RKLeyyeUtilKit isBlankString:user.birthday]) {
                sqlite3_bind_null(stmt, 10);
            }else{
                sqlite3_bind_text(stmt, 10,[user.birthday UTF8String], -1, NULL);
            }
            
            if ([RKLeyyeUtilKit isBlankString:user.email]) {
                sqlite3_bind_null(stmt, 11);
            }else{
                sqlite3_bind_text(stmt, 11,[user.email UTF8String], -1, NULL);
            }
            
            if ([RKLeyyeUtilKit isBlankString:user.telephone]) {
                sqlite3_bind_null(stmt, 12);
            }else{
                sqlite3_bind_text(stmt, 12,[user.telephone UTF8String], -1, NULL);
            }
            
            if ([RKLeyyeUtilKit isBlankString:user.qq]) {
                sqlite3_bind_null(stmt, 13);
            }else{
                sqlite3_bind_text(stmt, 13,[user.qq UTF8String], -1, NULL);
            }
            
            if ([RKLeyyeUtilKit isBlankString:user.introduction]) {
                sqlite3_bind_null(stmt, 14);
            }else{
                sqlite3_bind_text(stmt, 14,[user.introduction UTF8String], -1, NULL);
            }
            
            sqlite3_bind_int(stmt, 15,user.coins);
            sqlite3_bind_int(stmt, 16,user.contribution);
            sqlite3_bind_int(stmt, 17,user.rank);
            // 执行SQL语句
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return YES;
        }
        return NO;
    }
    return NO;
}

- (NSMutableArray *) queryLeyyeUser{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from user";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        debugLog(@"%squeryLeyyeUser -> result:%i",__func__,result);
        if (result == SQLITE_OK) {
            NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:10];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSString * realName = NULL;
                NSString * userIcon = NULL;
                NSString * sex = NULL;
                NSString * birthday = NULL;
                NSString * email = NULL;
                NSString * telephone = NULL;
                NSString * qq = NULL;
                NSString * introduction = NULL;
                
                /////////////////////////////////////////////////////////////
                const char * cRealName = (char *)sqlite3_column_text(stmt, 3);
                const char * cUserIcon = (char *)sqlite3_column_text(stmt, 6);
                const char * cSex = (char *)sqlite3_column_text(stmt, 8);
                const char * cBirthday = (char *)sqlite3_column_text(stmt, 10);
                const char * cEmail = (char *)sqlite3_column_text(stmt, 11);
                const char * cTelephone = (char *)sqlite3_column_text(stmt, 12);
                const char * cQQ = (char *)sqlite3_column_text(stmt, 13);
                const char * cIntroduction = (char *)sqlite3_column_text(stmt, 14);

                /////////////////////////////////////////////////////////////
                int uid = sqlite3_column_int(stmt , 1);
                NSString * userName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                if (cRealName != nil) {
                    realName = [NSString stringWithUTF8String:cRealName];
                }
                NSString * nickName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                NSString * password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                if (cUserIcon != nil) {
                    userIcon = [NSString stringWithUTF8String:cUserIcon];
                }
//                NSString * age = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                
                if (cSex != nil) {
                    sex = [NSString stringWithUTF8String:cSex];
                }
//                NSString * address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
                if (cBirthday != nil) {
                    birthday = [NSString stringWithUTF8String:cBirthday];
                }
                if(cEmail != nil){
                    email = [NSString stringWithUTF8String:cEmail];
                }
                if (cTelephone != nil) {
                    telephone = [NSString stringWithUTF8String:cTelephone];
                }
                if (cQQ != nil) {
                    qq = [NSString stringWithUTF8String:cQQ];
                }
                if (cIntroduction != nil) {
                    introduction = [NSString stringWithUTF8String:cIntroduction];
                }
                int coins = sqlite3_column_int(stmt , 15);
                int contribution = sqlite3_column_int(stmt , 16);
                int rank = sqlite3_column_int(stmt , 17);
                /////////////////////////////////////////////////////////////
                RKLeyyeUser * user = [[RKLeyyeUser alloc] initWithParameters:uid andUserName:userName andRealName:realName andPassword:password andUserNickName:nickName andUserIcon:userIcon andUserSex:sex andBirthday:birthday andEmainl:email andTelephone:telephone andQQ:qq andIntroduction:introduction andCoins:coins andContribution:contribution andRank:rank];
                [array addObject:user];
            }
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return array;
        }
        NSLog(@"查询领域用户出错");
        return nil;
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (NSString *) queryLeyyeUserWith:(NSString *)uid{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from user where username = ?"; //icon,username,password
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        if (result == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1,[uid UTF8String], -1, NULL);
            NSString * userIcon = NULL;
            while (sqlite3_step(stmt) == SQLITE_ROW){
                const char * cUserIcon = (char *)sqlite3_column_text(stmt, 6);
                if(cUserIcon != nil){
                    userIcon = [NSString stringWithUTF8String:cUserIcon];
                }
                return nil;
            }
            sqlite3_finalize(stmt); 
            sqlite3_close(database);
            return userIcon;
        }
        return nil;
    }
    return nil;
}

- (NSMutableArray *) queryLeyyeUserAndPwd{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select username,password from user";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        debugLog(@"%squeryLeyyeUser -> result:%i",__func__,result);
        if (result == SQLITE_OK) {
            NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:10];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
//                int uid = sqlite3_column_int(stmt , 1);
//                NSString * userName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
//                NSString * password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
//                RKLeyyeUser * user = [[RKLeyyeUser alloc] initWithParameters:uid andUserName:userName andRealName:realName andPassword:password andUserNickName:nickName andUserIcon:userIcon andUserSex:sex andBirthday:birthday andEmainl:email];
//                [array addObject:user];
            }
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return array;
        }
        NSLog(@"查询领域用户出错");
        return nil;
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (BOOL) insertLeyyeDomain:(RKLeyyeDomain *)domain{
    if ([self createAndOpenDatabase]) {
        const char * insertSQL = "insert into domain(_id,domain_id,domain_name,domain_icon,articleCount,userCount,total_coin,rank) values(null,?,?,?,?,?,?,?)";
        NSParameterAssert(domain != nil);
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int result = sqlite3_prepare_v2(database,insertSQL, -1, &stmt, nil);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1,domain.domainId);
            sqlite3_bind_text(stmt, 2,[domain.domainTitle UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3,[domain.domainIcon UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 4, domain.articleCount);
            sqlite3_bind_int(stmt, 5, domain.userCount);
            sqlite3_bind_int(stmt, 6, domain.coins);
            sqlite3_bind_int(stmt, 7, domain.rank);
            // 执行SQL语句
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            NSLog(@"插入领域数据成功");
            return YES;
        }
        NSLog(@"插入领域数据出错");
        return NO;
    }
    NSLog(@"打开数据库出错");
    return NO;
}

- (NSMutableArray *) queryLeyyeDomain{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from domain";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        debugLog(@"queryLeyyeDomain -> result:%i",result);
        if (result == SQLITE_OK) {
            NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                int domainId = sqlite3_column_int(stmt, 1);
                NSString * title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                NSString * icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                int articleCount = sqlite3_column_int(stmt , 4);
                int userCount = sqlite3_column_int(stmt , 5);
                int coins = sqlite3_column_int(stmt , 6);
                int rank = sqlite3_column_int(stmt , 7);
                RKLeyyeDomain * domain = [[RKLeyyeDomain alloc] initWithParameters:domainId andDomainTitle:title andDomainIcon:icon andArticleCount:articleCount andUserCount:userCount andCoins:coins andRank:rank];
                [mutableArray addObject:domain];
            }
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return mutableArray;
        }
        NSLog(@"查询领域出错");
        return nil;
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (BOOL) insertLeyyeArticle:(RKLeyyeArticle *) article{
    if ([self createAndOpenDatabase]) {
        const char * insertSQL = "insert into article(_id,score,title,intro,content,domain_id,domain,author,author_nick,author_icon,author_icon_data,author_lv,author_rank,date,remark,img,awayFromFirst,aid) values(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        NSParameterAssert(article != nil);
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int result = sqlite3_prepare_v2(database,insertSQL, -1, &stmt, nil);
        debugLog(@"%sresult:%i",__FUNCTION__,result);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_double(stmt, 1, article.score);
            sqlite3_bind_text(stmt, 2,[article.title UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3,[article.intro UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4,[article.content UTF8String], -1, NULL);
            sqlite3_bind_double(stmt, 5, article.domainId);
            sqlite3_bind_text(stmt, 6,[article.domain UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 7,[article.author UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 8,[article.authorNick UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 9,[article.authorIcon UTF8String], -1, NULL);
            sqlite3_bind_blob(stmt, 10,[article.dAuthorIcon bytes],-1, NULL);
            sqlite3_bind_double(stmt, 11,article.authorLevel);
            sqlite3_bind_double(stmt, 12,article.authorRank);
            sqlite3_bind_double(stmt, 13, article.pubDate);
            sqlite3_bind_int(stmt, 14, article.remark);
            sqlite3_bind_text(stmt, 15, [article.articleImgAddr UTF8String], -1, NULL);
            sqlite3_bind_double(stmt, 16, article.awayFromFirst);
            sqlite3_bind_int(stmt, 17, article.aid);
            // 执行SQL语句
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return YES;
        }else if(result == SQLITE_ERROR){
            NSLog(@"文章插入出错");
            return NO;
        }
    }
    NSLog(@"打开数据库出错");
    return NO;
}

- (NSMutableArray *) queryLeyyeArticle{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from article";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        debugLog(@"RKDBHelper -> queryLeyyeArticle:result:%i",result);
        if (result == SQLITE_OK) {
            NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:10];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                int score = sqlite3_column_int(stmt , 1);
                NSString * title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
//                NSString * intro = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                NSString * content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                double  authorId = sqlite3_column_double(stmt, 5);
                NSString * domain = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                NSString * author = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                NSString * authorNickName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
                NSString * authorIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
                int iconLength = sqlite3_column_bytes(stmt, 10);
//                NSData * authorIconData = [[NSString stringWithUTF8String:(char *)sqlite3_column_bytes(stmt, 10)] dataUsingEncoding:NSUTF8StringEncoding];
                NSData * authorIconData = [NSData dataWithBytes:sqlite3_column_blob(stmt, 10) length:iconLength];
//                double  authorLevel = sqlite3_column_blob(stmt, 10);
                double  authorRank = sqlite3_column_double(stmt, 11);
                double  date = sqlite3_column_double(stmt, 12);
//                int  remark = sqlite3_column_int(stmt, 13);
                NSString * imgAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 14)];
                int awayFromFirst = sqlite3_column_int(stmt, 15);
                int articleId = sqlite3_column_int(stmt, 17);
                RKLeyyeArticle * article = [[RKLeyyeArticle alloc] initWithParameters:domain andAuthor:author andAuthorId:authorId andAuthorNick:authorNickName andAuthorIcon:authorIcon andAuthorIconData:authorIconData andAuthorRank:authorRank andPubDate:date andTitle:title andContent:content andArticleImages:imgAddress andScore:score andAwayFromFirst:awayFromFirst andArticleId:articleId];
                [array addObject:article];
            }
            sqlite3_finalize(stmt);
            return array;
        }
        NSLog(@"查询文章出错");
        return nil;
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (int) updateLeyyeArticle:(RKLeyyeArticle *) article{
    NSParameterAssert(article != nil);
    if ([self createAndOpenDatabase]) {
        const char * updateSQL = "UPDATE article SET domain_id = ?, title = ?,intro = ?,content = ?,score = ?, domain = ?,author = ?,author_nick = ?,author_icon = ?,author_icon_data = ?,author_lv = ?,author_rank = ?,date = ?,remark = ?,img = ?,awayFromFirst = ? where aid = ?";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,updateSQL, -1, &stmt, nil);
        debugLog(@"%sresult:%i",__FUNCTION__,result);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_double(stmt, 1, article.domainId);
            if (article.title != nil) {
                sqlite3_bind_text(stmt, 2, [article.title UTF8String], -1, NULL);
            }
            
            if (article.intro != nil) {
                sqlite3_bind_text(stmt, 3, [article.intro UTF8String], -1, NULL);
            }
            
            if (article.content != nil) {
                sqlite3_bind_text(stmt, 4, [article.content UTF8String], -1, NULL);
            }
//            sqlite3_bind_int(stmt, 5, [article.score intValue]);
//            sqlite3_bind_text(stmt, 6, [article.domain UTF8String], -1, NULL);
            if (article.author != nil) {
                sqlite3_bind_text(stmt, 7, [article.author UTF8String], -1, NULL);
            }
            
            if (article.authorNick != nil) {
                sqlite3_bind_text(stmt, 8, [article.authorNick UTF8String], -1, NULL);
            }
            
            if (article.authorIcon != nil) {
                sqlite3_bind_text(stmt, 9, [article.authorIcon UTF8String], -1, NULL);
            }
//            sqlite3_bind_text(stmt, 10, [article.authorIcon UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 11, article.authorLevel);
            sqlite3_bind_int(stmt, 12, article.authorRank);
//            sqlite3_bind_text(stmt, 13, [article.pubDate UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 14, article.remark);
            if (article.articleImgAddr != nil) {
                sqlite3_bind_text(stmt, 15, [article.articleImgAddr UTF8String], -1, NULL);
            }
//            sqlite3_bind_text(stmt, 16, [article.awayFromFirst UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 17, article.aid);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return YES;
        }
    }
    return 0;
}

- (BOOL) insertArticleComment:(RKLeyyeComment *)comment{
    NSParameterAssert(comment != nil);
    if ([self createAndOpenDatabase]) {
        const char * insertSQL = "insert into comment(_id,cid,aid,comment_nickname,comment_icon,comment_content,comment_date) values(null,?,?,?,?,?,?)";
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int result = sqlite3_prepare_v2(database,insertSQL, -1, &stmt, nil);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1,comment.cid);
            sqlite3_bind_int(stmt, 2,comment.articleId);
            sqlite3_bind_text(stmt, 3,[comment.commentNickName UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4,[comment.commentIcon UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5,[comment.commentContent UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 6,[comment.commentDate UTF8String], -1, NULL);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return YES;
        }
        NSLog(@"插入评论出错");
        return NO;
    }
    NSLog(@"打开数据库出错");
    return NO;
}

- (NSMutableArray *) queryArticleComment:(int) articleId{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from comment where aid = ?";
        sqlite3_stmt * stmt;
        if (articleId == 0){
            NSLog(@"查询%i评论出错",articleId);
            return nil;
        }else{
            sqlite3_bind_int(stmt,2,articleId);
            int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
            if (result == SQLITE_OK) {
                NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    int commentId = sqlite3_column_int(stmt, 1);
                    NSString * commentNickName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                    NSString * commentIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                    NSString * commentContent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                    NSString * commentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                    RKLeyyeComment * club = [[RKLeyyeComment alloc] initWithParameters:commentId andArticleId:articleId andCommentNickName:commentNickName andCommentIcon:commentIcon andCommentContent:commentContent andCommentDate:commentDate];
                    [mutableArray addObject:club];
                }
                sqlite3_finalize(stmt);
                sqlite3_close(database);
                return mutableArray;
            }
        }
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (BOOL) insertLeyyeActivity:(RKLeyyeActivity *)activity{
    return NO;
}

- (BOOL) insertLeyyeClub:(RKLeyyeClub *) club{
    if ([self createAndOpenDatabase]) {
        const char * insertSQL = "insert into club(_id,sid,title,icon,intro,user_count) values(null,?,?,?,?,?)";
        NSParameterAssert(club != nil);
        sqlite3_stmt * stmt;
        // 预编译SQL语句，stmt变量保存了预编译结果的指针
        int result = sqlite3_prepare_v2(database,insertSQL, -1, &stmt, nil);
        // 如果预编译成功
        if (result == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1,club.sId);
            sqlite3_bind_text(stmt, 2,[club.title UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3,[club.icon UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4,[club.intro UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 5,club.userCount);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return YES;
        }
        NSLog(@"插入俱乐部出错");
        return NO;
    }
    NSLog(@"打开数据库出错");
    return NO;
}

- (NSMutableArray *) queryLeyyeClubs{
    if ([self createAndOpenDatabase]) {
        const char * selectSQL = "select * from club";
        sqlite3_stmt * stmt;
        int result = sqlite3_prepare_v2(database,selectSQL, -1, &stmt, nil);
        debugLog(@"queryLeyyeClubs -> result:%i",result);
        if (result == SQLITE_OK) {
            NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                int clubId = sqlite3_column_int(stmt, 1);
                NSString * title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                NSString * icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                NSString * intro = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                int userCount = sqlite3_column_int(stmt , 5);
                RKLeyyeClub * club = [[RKLeyyeClub alloc] initWithParameters:clubId andTitle:title andIcon:icon andIntro:intro andUserCount:userCount];
                [mutableArray addObject:club];
            }
            sqlite3_finalize(stmt);
            sqlite3_close(database);
            return mutableArray;
        }
        NSLog(@"查询领域出错");
        return nil;
    }
    NSLog(@"打开数据库出错");
    return nil;
}

- (void) updateLeyyeClubs{
    
}

@end









