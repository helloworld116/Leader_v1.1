//
//  RKLeyyeUser.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLeyyeUser : NSObject{
    NSUserDefaults * defaults;
    RKLeyyeUser * mLeyyeUser;
}

@property (nonatomic, assign) int uid; //
@property (nonatomic, strong) NSString * leyyeName; //
@property (nonatomic, strong) NSString * realName;
@property (copy,nonatomic) NSString * userNick; //
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString * sex; // 0 代表男，1 代表女 2 代表不男不女；
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, strong) NSString * school;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * position;

@property (nonatomic, strong) NSString * introduction; // 自我介绍

@property (nonatomic, copy) NSString * password; //
@property (nonatomic, copy) NSString * telephone; //
@property (nonatomic, copy) NSString * userIcon; //
@property (nonatomic, assign) int rank;

@property (nonatomic, assign) int mPswType; //密码类型: 0-表示与phone一致
@property (nonatomic, assign) int expires;
@property (nonatomic, assign) int coins; // 金钱
@property (nonatomic, assign) int contribution;//贡献
@property (nonatomic, assign) int fansNo; //粉丝数
@property (nonatomic, assign) BOOL isSavePassword; //是否保存密码
@property (nonatomic, assign) BOOL isManuallyLogin; //是否手动登录
//@property (copy,nonatomic) NS mDomain; //威望列表（各领域列表）
//@property UserInfoItem[] mItems; //用户资料列表

@property (nonatomic,retain) RKLeyyeUser * aLeyyeUser;

- (id)initWithParameters:(int)aUID
             /*andUserName:(NSString *)aUserName
         andUserNickName:(NSString *)aUserNickName*/;

- (id)initWithParameters:(NSString *)aUserNickName
             andUserIcon:(NSString *)aUserIcon
              andExpires:(int)aExpires;

- (id)initWithParameters:(int)aUID
             andUserName:(NSString *)aUserName
             andRealName:(NSString *)aRealName
             andPassword:(NSString *)aPassword
         andUserNickName:(NSString *)aUserNickName
             andUserIcon:(NSString *)aUserIcon
              andUserSex:(NSString *)aSex
             andBirthday:(NSString *)aBirthday
               andEmainl:(NSString *)aEmail
            andTelephone:(NSString *)aTelephone
            andQQ:(NSString *)aQq
         andIntroduction:(NSString *)aIntroduction
                andCoins:(int)aCoins
         andContribution:(int)aContribution
         andRank:(int)aRank;

+ (BOOL) parserLoginInfo:(NSString *) str;
+ (RKLeyyeUser *) parserAndSaveUserAppLogin:(NSDictionary *) dict;
+ (void) parserAndSaveLeyyeAuthorInfo:(NSMutableDictionary *) mutableDict;
+ (NSMutableArray *) parserLeyyeAuthorInfo:(NSMutableDictionary * ) mutableDict;

@end
