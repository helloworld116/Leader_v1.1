//
//  RKLeyyeDomain.h
//  Leader
//
//  Created by leyye on 14-11-6.
//  Copyright (c) 2014年 leyye. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RKLeyyeDomain : NSObject{
}

@property (nonatomic, assign) int domainId; // 领域号ID
@property (nonatomic, strong) NSString * domainTitle; // 领域标题
@property (nonatomic, strong) NSString * domainIcon; // 领域图标
@property (nonatomic, assign) int articleCount; // 文章总数
@property (nonatomic, assign) int userCount;  // 用户总数
@property (nonatomic, assign) int coins;  // 总金额
@property (nonatomic, assign) int rank; // 等级



- (id) initWithParameters:(int) mDonmainId
             andDomainTitle:(NSString *) mDomainTitle
              andDomainIcon:(NSString *) mDomainIcon
            andArticleCount:(int) mArticleCount
             andUserCount:(int) mUserCount
             andCoins:(int) mCoins
                  andRank:(int)mRank;

+ (NSMutableArray *) parserDomain:(NSString *) str;


//+ (void) saveLeyyeDomain:(id) sender;


@end
