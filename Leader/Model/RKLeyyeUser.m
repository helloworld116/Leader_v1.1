//
//  RKLeyyeUser.m
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeUser.h"
#import "RKDBHelper.h"
#import "RKLeyyeUtilKit.h"

@implementation RKLeyyeUser{
    NSMutableArray * array;
}

@synthesize uid;
@synthesize leyyeName;
@synthesize realName;
@synthesize userNick;
@synthesize password;
@synthesize age,sex,school;
@synthesize telephone,qq,email,address;
@synthesize introduction;
@synthesize rank;
@synthesize userIcon;
@synthesize mPswType;
@synthesize expires;
@synthesize coins,contribution;
@synthesize fansNo;
@synthesize isSavePassword;
@synthesize isManuallyLogin;

- (id)initWithParameters:(int)aUID
             /*andUserName:(NSString *)aUserName
         andUserNickName:(NSString *)aUserNickName*/{
    RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] init];
    leyyeUser.uid = aUID;
//    leyyeUser.leyyeName = aUserName;
//    leyyeUser.userNick = aUserNickName;
    return leyyeUser;
}

- (id)initWithParameters:(NSString *)aUserNickName
             andUserIcon:(NSString *)aUserIcon
              andExpires:(int)aExpires{
    RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] init];
    leyyeUser.userNick = aUserNickName;
    leyyeUser.userIcon = aUserIcon;
    leyyeUser.expires = aExpires;
    return leyyeUser;
}

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
                 andRank:(int)aRank{
    RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] init];
    leyyeUser.uid = aUID;
    leyyeUser.leyyeName = aUserName;
    leyyeUser.realName = aRealName;
    leyyeUser.password = aPassword;
    leyyeUser.userNick = aUserNickName;
    leyyeUser.userIcon = aUserIcon;
    leyyeUser.sex = aSex;
    leyyeUser.birthday = aBirthday;
    leyyeUser.email = aEmail;
    leyyeUser.introduction = aIntroduction;
    leyyeUser.telephone = aTelephone;
    leyyeUser.qq = aQq;
    leyyeUser.coins = aCoins;
    leyyeUser.contribution = aContribution;
    leyyeUser.rank = aRank;
    return leyyeUser;
}

+ (BOOL) parserLoginInfo:(NSDictionary *) dict{
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] initWithParameters:dict[@"nickname"] andUserIcon:dict[@"icon"] andExpires:[dict[@"expiresIn"] intValue]];
    [dbHelper insertLeyyeAppUser:leyyeUser];
    return YES;
}

+ (RKLeyyeUser *) parserAndSaveUserAppLogin:(NSDictionary *) dict{
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] initWithParameters:[dict[@"id"] intValue] andUserName:dict[@"username"] andRealName:dict[@"realName"] andPassword:dict[@"password"] andUserNickName:dict[@"nickname"]andUserIcon:dict[@"icon"] andUserSex:dict[@"sex"] andBirthday:dict[@"birthday"] andEmainl:dict[@"email"] andTelephone:dict[@"phone"] andQQ:dict[@"qq"] andIntroduction:dict[@"introduction"] andCoins:[dict[@"coins"] intValue] andContribution:[dict[@"contribution"] intValue] andRank:[dict[@"rank"] intValue]];
    [dbHelper insertLeyyeUser:leyyeUser];
    return leyyeUser;
}

+ (void) parserAndSaveLeyyeAuthorInfo:(NSMutableDictionary *) mutableDict{
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    for(NSDictionary * dict in mutableDict){
        [RKLeyyeUtilKit downloadImage:dict[@"icon"]];
        RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] initWithParameters:[dict[@"id"] intValue] andUserName:dict[@"username"] andRealName:dict[@"realName"] andPassword:dict[@"password"] andUserNickName:dict[@"nickname"]andUserIcon:dict[@"icon"] andUserSex:dict[@"sex"] andBirthday:dict[@"birthday"] andEmainl:dict[@"email"]andTelephone:dict[@"phone"]andQQ:dict[@"qq"]andIntroduction:dict[@"introduction"]andCoins:[dict[@"coins"] intValue] andContribution:[dict[@"contribution"] intValue] andRank:[dict[@"rank"] intValue]];
        [dbHelper insertLeyyeUser:leyyeUser];
    }
}

+ (NSMutableArray *) parserLeyyeAuthorInfo:(NSMutableDictionary * ) mutableDict{
    NSMutableArray * mArray = [NSMutableArray array];
    for(NSDictionary * dict in mutableDict){
        RKLeyyeUser * leyyeUser = [[RKLeyyeUser alloc] initWithParameters:[dict[@"id"] intValue] andUserName:dict[@"username"] andRealName:dict[@"realName"] andPassword:dict[@"password"] andUserNickName:dict[@"nickname"]andUserIcon:dict[@"icon"] andUserSex:dict[@"sex"] andBirthday:dict[@"birthday"] andEmainl:dict[@"email"]andTelephone:dict[@"phone"]andQQ:dict[@"qq"]andIntroduction:dict[@"introduction"]andCoins:[dict[@"coins"] intValue] andContribution:[dict[@"contribution"] intValue] andRank:[dict[@"rank"] intValue]];
        [mArray addObject:leyyeUser];
    }
    return mArray;
}

@end
