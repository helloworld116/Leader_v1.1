//
//  RKLeyyeDomain.m
//  Leader
//
//  Created by leyye on 14-11-6.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeDomain.h"
#import "RKDBHelper.h"
#import "RKFileManager.h"

@implementation RKLeyyeDomain

@synthesize domainId;
@synthesize domainTitle;
@synthesize domainIcon;
@synthesize articleCount;
@synthesize userCount;
@synthesize coins;
@synthesize rank;

- (id) initWithParameters:(int) mDonmainId
             andDomainTitle:(NSString *) mDomainTitle
              andDomainIcon:(NSString *) mDomainIcon
            andArticleCount:(int) mArticleCount
             andUserCount:(int) mUserCount
                 andCoins:(int) mCoins
                  andRank:(int)mRank{
    RKLeyyeDomain *domain = [[RKLeyyeDomain alloc]init];
    domain.domainId = mDonmainId;
    domain.domainTitle = mDomainTitle;
    domain.domainIcon = mDomainIcon;
    domain.articleCount = mArticleCount;
    domain.userCount = mUserCount;
    domain.coins = mCoins;
    domain.rank = mRank;
    return domain;
}

+ (NSMutableArray *) parserDomain:(NSString *) str{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    NSMutableDictionary * domains = json[@"data"][@"circles"];
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary * domain in domains) {
        RKLeyyeDomain * domainObj = [[RKLeyyeDomain alloc]initWithParameters:[domain[@"id"] intValue] andDomainTitle:domain[@"title"] andDomainIcon:domain[@"icon"] andArticleCount:[domain[@"userCount"] intValue] andUserCount:[domain[@"articleCount"] intValue] andCoins:[domain[@"totalCoins"] intValue] andRank:[domain[@"rank"] intValue]];
        [dbHelper insertLeyyeDomain:domainObj];
        [mutableArray addObject:domainObj];
    }
    return mutableArray;
}


@end
